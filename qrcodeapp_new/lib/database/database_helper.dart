// lib/database/database_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/product_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'products.db');
    return await openDatabase(
      path,
      version: 4, // زودنا الإصدار لـ 4
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onCreate(Database db, int version) async {
    // جدول المنتجات
    await db.execute('''
      CREATE TABLE products(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        productId TEXT UNIQUE NOT NULL,
        name TEXT NOT NULL,
        price REAL NOT NULL,
        quantity INTEGER NOT NULL DEFAULT 0,
        expiryDate TEXT NOT NULL,
        storedAt TEXT NOT NULL,
        barcodeImagePath TEXT
      )
    ''');

    // جدول المبيعات
    await db.execute('''
      CREATE TABLE sales(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        saleId TEXT UNIQUE NOT NULL,
        saleDate TEXT NOT NULL,
        totalAmount REAL NOT NULL,
        paymentMethod TEXT,
        notes TEXT
      )
    ''');

    // جدول تفاصيل المبيعات
    await db.execute('''
      CREATE TABLE sale_items(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        saleId INTEGER NOT NULL,
        productId TEXT NOT NULL,
        productName TEXT NOT NULL,
        price REAL NOT NULL,
        quantity INTEGER NOT NULL,
        total REAL NOT NULL,
        FOREIGN KEY (saleId) REFERENCES sales (id) ON DELETE CASCADE
      )
    ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE products ADD COLUMN quantity INTEGER NOT NULL DEFAULT 0');
    }
    if (oldVersion < 3) {
      await db.execute('ALTER TABLE products ADD COLUMN barcodeImagePath TEXT');
    }
    if (oldVersion < 4) {
      // جدول المبيعات
      await db.execute('''
        CREATE TABLE sales(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          saleId TEXT UNIQUE NOT NULL,
          saleDate TEXT NOT NULL,
          totalAmount REAL NOT NULL,
          paymentMethod TEXT,
          notes TEXT
        )
      ''');

      // جدول تفاصيل المبيعات
      await db.execute('''
        CREATE TABLE sale_items(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          saleId INTEGER NOT NULL,
          productId TEXT NOT NULL,
          productName TEXT NOT NULL,
          price REAL NOT NULL,
          quantity INTEGER NOT NULL,
          total REAL NOT NULL,
          FOREIGN KEY (saleId) REFERENCES sales (id) ON DELETE CASCADE
        )
      ''');
    }
  }

  // =============== دوال المنتجات ===============
  Future<int> insertProduct(Product product) async {
    Database db = await database;
    return await db.insert('products', product.toJson());
  }

  Future<List<Product>> getAllProducts() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'products',
      orderBy: 'storedAt DESC',
    );
    return List.generate(maps.length, (i) => Product.fromJson(maps[i]));
  }

  Future<Product?> getProductByProductId(String productId) async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'products',
      where: 'productId = ?',
      whereArgs: [productId],
    );
    if (maps.isNotEmpty) return Product.fromJson(maps.first);
    return null;
  }

  Future<int> updateProduct(Product product) async {
    Database db = await database;
    return await db.update(
      'products',
      product.toJson(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  Future<int> deleteProduct(int id) async {
    Database db = await database;
    return await db.delete(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // =============== دوال المبيعات ===============
  Future<int> insertSale(Sale sale) async {
    Database db = await database;
    return await db.transaction((txn) async {
      // إدخال المبيعة
      int saleId = await txn.insert('sales', {
        'saleId': sale.saleId,
        'saleDate': sale.saleDate.toIso8601String(),
        'totalAmount': sale.totalAmount,
        'paymentMethod': sale.paymentMethod,
        'notes': sale.notes,
      });

      // إدخال تفاصيل المبيعة
      for (var item in sale.items) {
        await txn.insert('sale_items', {
          'saleId': saleId,
          'productId': item.productId,
          'productName': item.productName,
          'price': item.price,
          'quantity': item.quantity,
          'total': item.total,
        });
      }

      return saleId;
    });
  }

  Future<List<Sale>> getAllSales() async {
    Database db = await database;

    // جلب كل المبيعات
    final List<Map<String, dynamic>> salesMaps = await db.query(
      'sales',
      orderBy: 'saleDate DESC',
    );

    List<Sale> sales = [];
    for (var saleMap in salesMaps) {
      // جلب تفاصيل كل مبيعة
      final List<Map<String, dynamic>> itemsMaps = await db.query(
        'sale_items',
        where: 'saleId = ?',
        whereArgs: [saleMap['id']],
      );

      List<SaleItem> items = itemsMaps.map((itemMap) => SaleItem.fromJson(itemMap)).toList();

      sales.add(Sale(
        id: saleMap['id'],
        saleId: saleMap['saleId'],
        saleDate: DateTime.parse(saleMap['saleDate']),
        items: items,
        totalAmount: saleMap['totalAmount'],
        paymentMethod: saleMap['paymentMethod'],
        notes: saleMap['notes'],
      ));
    }

    return sales;
  }

  Future<Sale?> getSaleById(int id) async {
    Database db = await database;

    final List<Map<String, dynamic>> saleMaps = await db.query(
      'sales',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (saleMaps.isEmpty) return null;

    var saleMap = saleMaps.first;

    final List<Map<String, dynamic>> itemsMaps = await db.query(
      'sale_items',
      where: 'saleId = ?',
      whereArgs: [saleMap['id']],
    );

    List<SaleItem> items = itemsMaps.map((itemMap) => SaleItem.fromJson(itemMap)).toList();

    return Sale(
      id: saleMap['id'],
      saleId: saleMap['saleId'],
      saleDate: DateTime.parse(saleMap['saleDate']),
      items: items,
      totalAmount: saleMap['totalAmount'],
      paymentMethod: saleMap['paymentMethod'],
      notes: saleMap['notes'],
    );
  }

  Future<List<Sale>> getSalesByDateRange(DateTime start, DateTime end) async {
    Database db = await database;

    final List<Map<String, dynamic>> salesMaps = await db.query(
      'sales',
      where: 'saleDate BETWEEN ? AND ?',
      whereArgs: [start.toIso8601String(), end.toIso8601String()],
      orderBy: 'saleDate DESC',
    );

    List<Sale> sales = [];
    for (var saleMap in salesMaps) {
      final List<Map<String, dynamic>> itemsMaps = await db.query(
        'sale_items',
        where: 'saleId = ?',
        whereArgs: [saleMap['id']],
      );

      List<SaleItem> items = itemsMaps.map((itemMap) => SaleItem.fromJson(itemMap)).toList();

      sales.add(Sale(
        id: saleMap['id'],
        saleId: saleMap['saleId'],
        saleDate: DateTime.parse(saleMap['saleDate']),
        items: items,
        totalAmount: saleMap['totalAmount'],
        paymentMethod: saleMap['paymentMethod'],
        notes: saleMap['notes'],
      ));
    }

    return sales;
  }

  Future<double> getTotalSales() async {
    Database db = await database;
    final result = await db.rawQuery('SELECT SUM(totalAmount) as total FROM sales');
    return result.first['total'] as double? ?? 0.0;
  }

  Future<int> getSalesCount() async {
    Database db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM sales');
    return result.first['count'] as int? ?? 0;
  }
  // في database_helper.dart، أضف هذه الدالة

  Future<List<Sale>> getLastTransactions(int count) async {
    Database db = await database;

    final List<Map<String, dynamic>> salesMaps = await db.query(
      'sales',
      orderBy: 'saleDate DESC',
      limit: count,
    );

    List<Sale> sales = [];
    for (var saleMap in salesMaps) {
      final List<Map<String, dynamic>> itemsMaps = await db.query(
        'sale_items',
        where: 'saleId = ?',
        whereArgs: [saleMap['id']],
      );

      List<SaleItem> items = itemsMaps.map((itemMap) => SaleItem.fromJson(itemMap)).toList();

      sales.add(Sale(
        id: saleMap['id'],
        saleId: saleMap['saleId'],
        saleDate: DateTime.parse(saleMap['saleDate']),
        items: items,
        totalAmount: saleMap['totalAmount'],
        paymentMethod: saleMap['paymentMethod'],
        notes: saleMap['notes'],
      ));
    }

    return sales;
  }
}