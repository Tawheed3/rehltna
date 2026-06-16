// lib/screens/sell_screen.dart
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../database/database_helper.dart';
import '../model/product_model.dart';  // تأكد من المسار models مش model
import '../model/product_data.dart';    // تأكد من المسار models مش model
import 'cart_screen.dart';

class SellScreen extends StatefulWidget {
  const SellScreen({super.key});

  @override
  State<SellScreen> createState() => _SellScreenState();
}

class _SellScreenState extends State<SellScreen> {
  final MobileScannerController controller = MobileScannerController(
    formats: [BarcodeFormat.qrCode, BarcodeFormat.ean13, BarcodeFormat.ean8, BarcodeFormat.code128],
  );

  final DatabaseHelper _dbHelper = DatabaseHelper();

  // متغيرات المسح
  bool isFlashOn = false;
  bool isProcessing = false;
  bool isScanMode = true;

  // السلة
  List<CartItem> _cart = [];

  // متغيرات المنتج الحالي
  Product? _currentProduct;
  int _currentQuantity = 1;

  // للإدخال اليدوي
  final TextEditingController _manualIdController = TextEditingController();
  String? _errorMessage;

  // قائمة المنتجات للإدخال اليدوي (من قاعدة البيانات)
  List<Product> _allProducts = [];

  // قائمة المنتجات من JSON
  List<JsonProduct> _allJsonProducts = [];

  bool _isSearching = false;
  String _searchText = '';

  // متغير للتبديل بين مصدري المنتجات
  bool _useJsonProducts = true; // true = JSON, false = قاعدة البيانات

  @override
  void initState() {
    super.initState();
    _loadAllProducts();
    _loadJsonProducts();
  }

  // تحميل كل المنتجات من قاعدة البيانات
  Future<void> _loadAllProducts() async {
    List<Product> products = await _dbHelper.getAllProducts();
    setState(() {
      _allProducts = products;
    });
  }

  // تحميل المنتجات من JSON
  Future<void> _loadJsonProducts() async {
    List<JsonProduct> products = await ProductDataLoader.loadProducts();
    setState(() {
      _allJsonProducts = products;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('نقطة البيع'),
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.qr_code_scanner), text: 'مسح'),
              Tab(icon: Icon(Icons.edit), text: 'إدخال يدوي'),
            ],
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
          ),
          actions: [
            // أيقونة السلة
            Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: _openCart,
                  tooltip: 'عرض السلة',
                ),
                if (_cart.isNotEmpty)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${_cart.length}',
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            // زر الفلاش (للمسح فقط)
            if (isScanMode)
              IconButton(
                icon: Icon(isFlashOn ? Icons.flash_on : Icons.flash_off),
                onPressed: () {
                  controller.toggleTorch();
                  setState(() => isFlashOn = !isFlashOn);
                },
              ),
            // زر التبديل بين المصادر (اختياري)
            PopupMenuButton<String>(
              icon: const Icon(Icons.filter_list),
              tooltip: 'مصدر المنتجات',
              onSelected: (value) {
                setState(() {
                  _useJsonProducts = value == 'json';
                });
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'json',
                  child: Row(
                    children: [
                      Icon(Icons.cloud, color: Colors.blue),
                      SizedBox(width: 8),
                      Text('منتجات JSON'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'db',
                  child: Row(
                    children: [
                      Icon(Icons.storage, color: Colors.green),
                      SizedBox(width: 8),
                      Text('منتجات المخزون'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        body: TabBarView(
          children: [
            _buildScanTab(),
            _buildManualTab(),
          ],
        ),
      ),
    );
  }

  // فتح شاشة السلة
  void _openCart() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartScreen(
          initialCart: _cart,
          onCartUpdated: (updatedCart) {
            setState(() {
              _cart = updatedCart;
            });
          },
          onCheckout: _processCheckout,
        ),
      ),
    );
  }

  // معالجة الدفع
  Future<void> _processCheckout() async {
    if (_cart.isEmpty) return;

    setState(() => isProcessing = true);

    try {
      for (var item in _cart) {
        Product updatedProduct = Product(
          id: item.product.id,
          productId: item.product.productId,
          name: item.product.name,
          price: item.product.price,
          quantity: item.product.quantity - item.quantity,
          expiryDate: item.product.expiryDate,
          storedAt: item.product.storedAt,
          barcodeImagePath: item.product.barcodeImagePath,
        );

        await _dbHelper.updateProduct(updatedProduct);
      }

      double total = _cart.fold(0, (sum, item) => sum + item.totalPrice);

      // إنشاء رقم فاتورة
      String saleId = 'INV-${DateTime.now().millisecondsSinceEpoch}';

      // إنشاء كائن المبيعة
      Sale sale = Sale(
        saleId: saleId,
        saleDate: DateTime.now(),
        items: _cart.map((item) => SaleItem(
          saleId: 0,
          productId: item.product.productId,
          productName: item.product.name,
          price: item.product.price,
          quantity: item.quantity,
          total: item.totalPrice,
        )).toList(),
        totalAmount: total,
        paymentMethod: 'نقدي',
        notes: 'بيع من نقطة البيع',
      );

      await _dbHelper.insertSale(sale);

      setState(() {
        isProcessing = false;
        _cart.clear();
      });

      _showSuccessDialog(total);

    } catch (e) {
      setState(() => isProcessing = false);
      _showErrorDialog('حدث خطأ: $e');
    }
  }

  // إضافة منتج للسلة
  void _addToCart(Product product, int quantity) {
    setState(() {
      int existingIndex = _cart.indexWhere((item) => item.product.productId == product.productId);

      if (existingIndex >= 0) {
        int newQuantity = _cart[existingIndex].quantity + quantity;
        if (newQuantity <= product.quantity) {
          _cart[existingIndex] = CartItem(
            product: product,
            quantity: newQuantity,
          );
          _showSnackBar('تم تحديث كمية ${product.name} في السلة');
        } else {
          _showErrorDialog('الكمية المطلوبة (${newQuantity}) أكبر من المتوفر (${product.quantity})');
          return;
        }
      } else {
        if (quantity <= product.quantity) {
          _cart.add(CartItem(
            product: product,
            quantity: quantity,
          ));
          _showSnackBar('تم إضافة ${product.name} إلى السلة');
        } else {
          _showErrorDialog('الكمية المطلوبة ($quantity) أكبر من المتوفر (${product.quantity})');
          return;
        }
      }

      _currentProduct = null;
      _currentQuantity = 1;
    });
  }

  // تبويب المسح
  Widget _buildScanTab() {
    return Stack(
      children: [
        MobileScanner(
          controller: controller,
          onDetect: _onDetect,
        ),

        // إطار المسح
        Container(
          color: Colors.black26,
          child: Center(
            child: Container(
              width: 300,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 3),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.qr_code_scanner, size: 60, color: Colors.white70),
                  Text('امسح الباركود', style: TextStyle(color: Colors.white)),
                  SizedBox(height: 5),
                  Text(
                    'لإضافة المنتج للسلة',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ),

        if (isProcessing)
          Container(
            color: Colors.black54,
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'جاري البحث عن المنتج...',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),

        // منتقي الكمية للمنتج الحالي
        if (_currentProduct != null)
          _buildQuantitySelector(),
      ],
    );
  }

  // تبويب الإدخال اليدوي
  Widget _buildManualTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.edit, size: 80, color: Colors.red),
          const SizedBox(height: 20),

          // عنوان مع مصدر المنتجات
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _useJsonProducts ? 'منتجات JSON' : 'منتجات المخزون',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // حقل البحث
          TextField(
            onChanged: (value) {
              setState(() {
                _searchText = value.toLowerCase();
                _isSearching = true;
              });
            },
            decoration: InputDecoration(
              hintText: 'ابحث عن منتج...',
              prefixIcon: const Icon(Icons.search, color: Colors.red),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // قائمة المنتجات
          Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.5,
            ),
            child: _useJsonProducts
                ? _buildJsonProductList()
                : _buildDatabaseProductList(),
          ),

          // منتقي الكمية للمنتج المختار
          if (_currentProduct != null) ...[
            const SizedBox(height: 20),
            _buildManualQuantitySelector(),
          ],
        ],
      ),
    );
  }

  // قائمة المنتجات من JSON
  Widget _buildJsonProductList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _allJsonProducts.length,
      itemBuilder: (context, index) {
        final jsonProduct = _allJsonProducts[index];

        // تصفية حسب البحث
        if (_searchText.isNotEmpty &&
            !jsonProduct.name.toLowerCase().contains(_searchText) &&
            !jsonProduct.id.toLowerCase().contains(_searchText)) {
          return const SizedBox.shrink();
        }

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue.withOpacity(0.1),
              child: const Icon(Icons.cloud, color: Colors.blue, size: 20),
            ),
            title: Text(jsonProduct.name),
            subtitle: Text('${jsonProduct.price} ج.م'),
            trailing: IconButton(
              icon: const Icon(Icons.add_shopping_cart, color: Colors.blue),
              onPressed: () {
                setState(() {
                  // تحويل JsonProduct إلى Product مؤقت
                  _currentProduct = Product(
                    productId: jsonProduct.id,
                    name: jsonProduct.name,
                    price: jsonProduct.price,
                    quantity: 999999, // كمية كبيرة للاختيار
                    expiryDate: '2026-12-31',
                    storedAt: DateTime.now(),
                  );
                  _currentQuantity = 1;
                  _searchText = '';
                  _isSearching = false;
                });
              },
            ),
          ),
        );
      },
    );
  }

  // قائمة المنتجات من قاعدة البيانات
  Widget _buildDatabaseProductList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _allProducts.length,
      itemBuilder: (context, index) {
        final product = _allProducts[index];

        // تصفية حسب البحث
        if (_searchText.isNotEmpty &&
            !product.name.toLowerCase().contains(_searchText) &&
            !product.productId.toLowerCase().contains(_searchText)) {
          return const SizedBox.shrink();
        }

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.red.withOpacity(0.1),
              child: const Icon(Icons.inventory, color: Colors.red),
            ),
            title: Text(product.name),
            subtitle: Text(
              '${product.price} ج.م | متوفر: ${product.quantity}',
              style: const TextStyle(fontSize: 12),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.add_shopping_cart, color: Colors.red),
              onPressed: () {
                setState(() {
                  _currentProduct = product;
                  _currentQuantity = 1;
                  _searchText = '';
                  _isSearching = false;
                });
              },
            ),
          ),
        );
      },
    );
  }

  // منتقي الكمية للإدخال اليدوي
  Widget _buildManualQuantitySelector() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Column(
        children: [
          Text(
            _currentProduct!.name,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text('المتوفر: ${_currentProduct!.quantity}'),
          const SizedBox(height: 15),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: _currentQuantity > 1
                    ? () => setState(() => _currentQuantity--)
                    : null,
                icon: const Icon(Icons.remove_circle, size: 40),
                color: Colors.red,
              ),
              Container(
                width: 80,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Center(
                  child: Text(
                    '$_currentQuantity',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: _currentQuantity < _currentProduct!.quantity
                    ? () => setState(() => _currentQuantity++)
                    : null,
                icon: const Icon(Icons.add_circle, size: 40),
                color: Colors.green,
              ),
            ],
          ),

          const SizedBox(height: 10),

          // السعر الإجمالي
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'الإجمالي:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '${(_currentProduct!.price * _currentQuantity).toStringAsFixed(2)} ج.م',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 15),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _currentProduct = null;
                      _currentQuantity = 1;
                    });
                  },
                  child: const Text('إلغاء'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    _addToCart(_currentProduct!, _currentQuantity);
                    setState(() {
                      _currentProduct = null;
                      _currentQuantity = 1;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('إضافة للسلة'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // منتقي الكمية للمسح
  Widget _buildQuantitySelector() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // معلومات المنتج
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.inventory, color: Colors.red),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _currentProduct!.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'المتوفر: ${_currentProduct!.quantity}',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // اختيار الكمية
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: _currentQuantity > 1
                      ? () => setState(() => _currentQuantity--)
                      : null,
                  icon: const Icon(Icons.remove_circle, size: 40),
                  color: Colors.red,
                ),
                Container(
                  width: 80,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Center(
                    child: Text(
                      '$_currentQuantity',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _currentQuantity < _currentProduct!.quantity
                      ? () => setState(() => _currentQuantity++)
                      : null,
                  icon: const Icon(Icons.add_circle, size: 40),
                  color: Colors.green,
                ),
              ],
            ),

            const SizedBox(height: 10),

            // السعر الإجمالي
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'الإجمالي:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${(_currentProduct!.price * _currentQuantity).toStringAsFixed(2)} ج.م',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // أزرار
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _currentProduct = null;
                        _currentQuantity = 1;
                      });
                    },
                    child: const Text('إلغاء'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _addToCart(_currentProduct!, _currentQuantity);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('إضافة للسلة'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // دالة المسح
  void _onDetect(BarcodeCapture capture) async {
    if (isProcessing || _currentProduct != null) return;

    for (final barcode in capture.barcodes) {
      if (barcode.rawValue != null) {
        setState(() => isProcessing = true);

        String barcodeData = barcode.rawValue!;
        String? productId = _extractProductId(barcodeData);

        if (productId != null) {
          Product? product = await _dbHelper.getProductByProductId(productId);

          setState(() => isProcessing = false);

          if (product != null) {
            setState(() {
              _currentProduct = product;
              _currentQuantity = 1;
            });
          } else {
            _showErrorDialog('المنتج غير موجود في المخزون');
          }
        } else {
          setState(() => isProcessing = false);
          _showErrorDialog('باركود غير صالح');
        }
        break;
      }
    }
  }

  // استخراج ID من الباركود
  String? _extractProductId(String barcodeData) {
    try {
      RegExp regExp = RegExp(r'ID:([^,]*)');
      Match? match = regExp.firstMatch(barcodeData);
      return match?.group(1);
    } catch (e) {
      return null;
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Icon(Icons.error, color: Colors.red, size: 50),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(double total) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Icon(Icons.check_circle, color: Colors.green, size: 60),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('تم البيع بنجاح', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('إجمالي المبيعات: $total ج.م'),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: const Text('تم'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    _manualIdController.dispose();
    super.dispose();
  }
}