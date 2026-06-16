// lib/models/product_model.dart
class Product {
  int? id;
  String productId;
  String name;
  double price;
  int quantity;
  String expiryDate;
  DateTime storedAt;
  String? barcodeImagePath;

  Product({
    this.id,
    required this.productId,
    required this.name,
    required this.price,
    required this.quantity,
    required this.expiryDate,
    required this.storedAt,
    this.barcodeImagePath,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      productId: json['productId'],
      name: json['name'],
      price: json['price'].toDouble(),
      quantity: json['quantity'] ?? 0,
      expiryDate: json['expiryDate'],
      storedAt: DateTime.parse(json['storedAt']),
      barcodeImagePath: json['barcodeImagePath'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'name': name,
      'price': price,
      'quantity': quantity,
      'expiryDate': expiryDate,
      'storedAt': storedAt.toIso8601String(),
      'barcodeImagePath': barcodeImagePath,
    };
  }
}

// نموذج المبيعات
class Sale {
  int? id;
  String saleId;           // رقم الفاتورة
  DateTime saleDate;       // تاريخ البيع
  List<SaleItem> items;    // المنتجات المباعة
  double totalAmount;      // الإجمالي
  String? paymentMethod;   // طريقة الدفع (نقدي, بطاقة, إلخ)
  String? notes;           // ملاحظات

  Sale({
    this.id,
    required this.saleId,
    required this.saleDate,
    required this.items,
    required this.totalAmount,
    this.paymentMethod,
    this.notes,
  });

  factory Sale.fromJson(Map<String, dynamic> json) {
    return Sale(
      id: json['id'],
      saleId: json['saleId'],
      saleDate: DateTime.parse(json['saleDate']),
      items: (json['items'] as List).map((i) => SaleItem.fromJson(i)).toList(),
      totalAmount: json['totalAmount'].toDouble(),
      paymentMethod: json['paymentMethod'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'saleId': saleId,
      'saleDate': saleDate.toIso8601String(),
      'items': items.map((i) => i.toJson()).toList(),
      'totalAmount': totalAmount,
      'paymentMethod': paymentMethod,
      'notes': notes,
    };
  }
}

// نموذج عناصر المبيعات
class SaleItem {
  int? id;
  int saleId;             // رقم الفاتورة
  String productId;        // ID المنتج
  String productName;      // اسم المنتج وقت البيع
  double price;            // السعر وقت البيع
  int quantity;            // الكمية
  double total;            // الإجمالي

  SaleItem({
    this.id,
    required this.saleId,
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.total,
  });

  factory SaleItem.fromJson(Map<String, dynamic> json) {
    return SaleItem(
      id: json['id'],
      saleId: json['saleId'],
      productId: json['productId'],
      productName: json['productName'],
      price: json['price'].toDouble(),
      quantity: json['quantity'],
      total: json['total'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'saleId': saleId,
      'productId': productId,
      'productName': productName,
      'price': price,
      'quantity': quantity,
      'total': total,
    };
  }
}