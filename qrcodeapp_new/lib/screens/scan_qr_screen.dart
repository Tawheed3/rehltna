// lib/screens/scan_qr_screen.dart
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:intl/intl.dart';
import '../database/database_helper.dart';
import '../model/product_model.dart';  // تأكد من المسار models مش model
import '../model/product_data.dart';    // استيراد JSON
import 'manual_add_dialog.dart';

class ScanQRScreen extends StatefulWidget {
  const ScanQRScreen({super.key});

  @override
  State<ScanQRScreen> createState() => _ScanQRScreenState();
}

class _ScanQRScreenState extends State<ScanQRScreen> {
  final MobileScannerController controller = MobileScannerController(
    formats: [BarcodeFormat.qrCode],
  );

  final DatabaseHelper _dbHelper = DatabaseHelper();

  bool isFlashOn = false;
  bool isProcessing = false;
  Product? _scannedProduct;
  String? _lastScannedData;
  String? _successMessage;

  // متغيرات الكمية
  int _selectedQuantity = 1;
  bool _showQuantitySelector = false;
  Map<String, dynamic>? _pendingProductData;
  bool _isExistingProduct = false; // لتحديد إذا كان المنتج موجود

  // متغيرات JSON
  List<JsonProduct> _jsonProducts = [];
  bool _showJsonSelector = false;
  String _jsonSearchText = '';

  @override
  void initState() {
    super.initState();
    _loadJsonProducts();
  }

  // تحميل المنتجات من JSON
  Future<void> _loadJsonProducts() async {
    List<JsonProduct> products = await ProductDataLoader.loadProducts();
    setState(() {
      _jsonProducts = products;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('مسح وتخزين QR Code'),
          backgroundColor: const Color(0xFF3498DB),
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: Icon(isFlashOn ? Icons.flash_on : Icons.flash_off),
              onPressed: () {
                controller.toggleTorch();
                setState(() => isFlashOn = !isFlashOn);
              },
            ),
            IconButton(
              icon: const Icon(Icons.add_box_rounded),
              onPressed: () {
                _showManualAddDialog();
              },
              tooltip: 'إضافة منتج يدوياً',
            ),
            IconButton(
              icon: const Icon(Icons.cloud),
              onPressed: () {
                setState(() {
                  _showJsonSelector = !_showJsonSelector;
                });
              },
              tooltip: 'منتجات JSON',
            ),
          ],
        ),
        body: Stack(
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
                  width: 280,
                  height: 280,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF3498DB), width: 3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.qr_code_scanner, size: 60, color: Colors.white70),
                      Text('امسح QR Code', style: TextStyle(color: Colors.white)),
                      SizedBox(height: 5),
                      Text(
                        'سيتم تخزين المنتج تلقائياً',
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
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3498DB)),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'جاري تخزين المنتج...',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),

            // منتقي الكمية للمنتج الحالي
            if (_showQuantitySelector)
              _buildQuantitySelector(),

            // قائمة منتجات JSON
            if (_showJsonSelector)
              _buildJsonSelector(),
          ],
        ),

        // إما عرض منتج موجود أو منتج جديد مع اختيار الكمية
        bottomSheet: _scannedProduct != null
            ? _buildProductInfo()
            : null,
      ),
    );
  }

  // دالة عرض نافذة الإضافة اليدوية
  void _showManualAddDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.all(20),
        child: const ManualAddDialog(),
      ),
    ).then((value) {
      if (value == true) {
        // ممكن نحدث حاجة هنا
      }
    });
  }

  // منتقي الكمية
  Widget _buildQuantitySelector() {
    // تحديد عنوان مناسب
    String title = _isExistingProduct
        ? 'إضافة كمية للمنتج'
        : 'تحديد الكمية للمنتج الجديد';

    String buttonText = _isExistingProduct
        ? 'إضافة الكمية للمخزون'
        : 'تأكيد الحفظ';

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // عنوان
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3498DB).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    _isExistingProduct ? Icons.add_shopping_cart : Icons.inventory,
                    color: const Color(0xFF3498DB),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // معلومات المنتج
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  _buildInfoRow('ID', _pendingProductData!['productId']),
                  const Divider(height: 1),
                  _buildInfoRow('الاسم', _pendingProductData!['name']),
                  const Divider(height: 1),
                  _buildInfoRow('السعر', '${_pendingProductData!['price']} ج.م'),
                  const Divider(height: 1),
                  _buildInfoRow('تاريخ الصلاحية', _formatExpiryDate(_pendingProductData!['expiryDate'])),

                  // لو منتج موجود، نعرض الكمية الحالية
                  if (_isExistingProduct) ...[
                    const Divider(height: 1),
                    _buildInfoRow('الكمية الحالية', '${_pendingProductData!['currentQuantity']}'),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 20),

            // اختيار الكمية
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Text(
                    _isExistingProduct ? 'الكمية المضافة' : 'الكمية',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // زر الناقص
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.red.shade100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.remove, color: Colors.red),
                          onPressed: _selectedQuantity > 1
                              ? () => setState(() => _selectedQuantity--)
                              : null,
                          iconSize: 30,
                        ),
                      ),
                      const SizedBox(width: 20),
                      // عرض الكمية
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
                            '$_selectedQuantity',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      // زر الزايد
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.add, color: Colors.green),
                          onPressed: () => setState(() => _selectedQuantity++),
                          iconSize: 30,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // السعر الإجمالي
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blue),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'الإجمالي:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${(_pendingProductData!['price'] * _selectedQuantity).toStringAsFixed(2)} ج.م',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
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
                    onPressed: _cancelQuantitySelection,
                    child: const Text('إلغاء'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _processQuantitySelection,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3498DB),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: Text(buttonText),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // منتقي منتجات JSON
  Widget _buildJsonSelector() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.7,
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)],
        ),
        child: Column(
          children: [
            // عنوان
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xFF3498DB),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'منتجات JSON',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        _showJsonSelector = false;
                      });
                    },
                  ),
                ],
              ),
            ),

            // حقل البحث
            Padding(
              padding: const EdgeInsets.all(15),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _jsonSearchText = value.toLowerCase();
                  });
                },
                decoration: InputDecoration(
                  hintText: 'ابحث عن منتج...',
                  prefixIcon: const Icon(Icons.search, color: Color(0xFF3498DB)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),

            // قائمة المنتجات
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                itemCount: _jsonProducts.length,
                itemBuilder: (context, index) {
                  final product = _jsonProducts[index];

                  // تصفية حسب البحث
                  if (_jsonSearchText.isNotEmpty &&
                      !product.name.toLowerCase().contains(_jsonSearchText) &&
                      !product.id.toLowerCase().contains(_jsonSearchText)) {
                    return const SizedBox.shrink();
                  }

                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: const Color(0xFF3498DB).withOpacity(0.1),
                        child: const Icon(Icons.cloud, color: Color(0xFF3498DB)),
                      ),
                      title: Text(product.name),
                      subtitle: Text('${product.price} ج.م'),
                      trailing: IconButton(
                        icon: const Icon(Icons.add, color: Color(0xFF3498DB)),
                        onPressed: () {
                          // تعيين تاريخ صلاحية افتراضي (بعد سنة)
                          DateTime now = DateTime.now();
                          String defaultExpiry = '${now.year + 1}-${now.month.toString().padLeft(2, '0')}';

                          setState(() {
                            _pendingProductData = {
                              'productId': product.id,
                              'name': product.name,
                              'price': product.price,
                              'expiryDate': defaultExpiry,
                            };
                            _isExistingProduct = false;
                            _showQuantitySelector = true;
                            _showJsonSelector = false;
                            _selectedQuantity = 1;
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // إلغاء اختيار الكمية
  void _cancelQuantitySelection() {
    setState(() {
      _showQuantitySelector = false;
      _pendingProductData = null;
      _selectedQuantity = 1;
      _isExistingProduct = false;
    });
    controller.start();
  }

  // معالجة الكمية المختارة
  Future<void> _processQuantitySelection() async {
    if (_pendingProductData == null) return;

    setState(() {
      isProcessing = true;
    });

    try {
      if (_isExistingProduct) {
        // منتج موجود - إضافة الكمية
        Product updatedProduct = Product(
          id: _pendingProductData!['id'],
          productId: _pendingProductData!['productId'],
          name: _pendingProductData!['name'],
          price: _pendingProductData!['price'],
          quantity: _pendingProductData!['currentQuantity'] + _selectedQuantity,
          expiryDate: _pendingProductData!['expiryDate'],
          storedAt: DateTime.now(),
          barcodeImagePath: null,
        );

        int result = await _dbHelper.updateProduct(updatedProduct);

        setState(() {
          isProcessing = false;
          if (result > 0) {
            _scannedProduct = updatedProduct;
            _successMessage = '✅ تم إضافة $_selectedQuantity وحدات للمخزون';
            _showQuantitySelector = false;
            _pendingProductData = null;
            _selectedQuantity = 1;
            _isExistingProduct = false;
          }
        });
      } else {
        // منتج جديد - حفظ كامل
        Product newProduct = Product(
          productId: _pendingProductData!['productId'],
          name: _pendingProductData!['name'],
          price: _pendingProductData!['price'],
          quantity: _selectedQuantity,
          expiryDate: _pendingProductData!['expiryDate'],
          storedAt: DateTime.now(),
          barcodeImagePath: null,
        );

        int id = await _dbHelper.insertProduct(newProduct);

        setState(() {
          isProcessing = false;
          if (id > 0) {
            _scannedProduct = newProduct;
            _successMessage = '✅ تم تخزين المنتج بنجاح';
            _showQuantitySelector = false;
            _pendingProductData = null;
            _selectedQuantity = 1;
            _isExistingProduct = false;
          }
        });
      }
    } catch (e) {
      setState(() {
        isProcessing = false;
      });
      _showErrorDialog('فشل في التخزين: $e');
    }
  }

  // عرض معلومات المنتج (للمنتجات الموجودة)
  Widget _buildProductInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // رسالة النجاح لو في
          if (_successMessage != null) ...[
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.green),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _successMessage!,
                      style: const TextStyle(color: Colors.green),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
          ],

          // عنوان
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF3498DB).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.inventory, color: Color(0xFF3498DB)),
              ),
              const SizedBox(width: 10),
              const Text(
                'معلومات المنتج',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // تفاصيل المنتج
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                _buildInfoRow('ID', _scannedProduct!.productId),
                const Divider(height: 1),
                _buildInfoRow('الاسم', _scannedProduct!.name),
                const Divider(height: 1),
                _buildInfoRow('السعر', '${_scannedProduct!.price} ج.م'),
                const Divider(height: 1),
                _buildInfoRow('الكمية المتوفرة', '${_scannedProduct!.quantity}'),
                const Divider(height: 1),
                _buildInfoRow('تاريخ الصلاحية', _formatExpiryDate(_scannedProduct!.expiryDate)),
                const Divider(height: 1),
                _buildInfoRow('وقت التخزين', DateFormat('yyyy/MM/dd - hh:mm a').format(_scannedProduct!.storedAt)),
              ],
            ),
          ),

          const SizedBox(height: 15),

          // زر إضافة كمية
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  // تجهيز بيانات المنتج لإضافة كمية
                  _pendingProductData = {
                    'id': _scannedProduct!.id,
                    'productId': _scannedProduct!.productId,
                    'name': _scannedProduct!.name,
                    'price': _scannedProduct!.price,
                    'expiryDate': _scannedProduct!.expiryDate,
                    'currentQuantity': _scannedProduct!.quantity,
                  };
                  _isExistingProduct = true;
                  _showQuantitySelector = true;
                  _scannedProduct = null; // إخفاء الشاشة الحالية
                });
              },
              icon: const Icon(Icons.add_shopping_cart),
              label: const Text('إضافة كمية للمخزون'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // أزرار
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.home),
                  label: const Text('الرئيسية'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _resetScan,
                  icon: const Icon(Icons.qr_code_scanner),
                  label: const Text('مسح جديد'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3498DB),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  String _formatExpiryDate(String expiryDate) {
    try {
      List<String> parts = expiryDate.split('-');
      if (parts.length == 2) {
        int year = int.parse(parts[0]);
        int month = int.parse(parts[1]);
        List<String> months = [
          'يناير', 'فبراير', 'مارس', 'إبريل', 'مايو', 'يونيو',
          'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
        ];
        return '${months[month - 1]} $year';
      }
    } catch (e) {
      return expiryDate;
    }
    return expiryDate;
  }

  void _onDetect(BarcodeCapture capture) async {
    if (isProcessing || _scannedProduct != null || _showQuantitySelector) return;

    for (final barcode in capture.barcodes) {
      if (barcode.rawValue != null) {
        setState(() {
          isProcessing = true;
          _successMessage = null;
        });

        String qrData = barcode.rawValue!;
        Map<String, dynamic>? productData = _parseQRData(qrData);

        if (productData != null) {
          Product? existing = await _dbHelper.getProductByProductId(productData['productId']);

          if (existing != null) {
            // منتج موجود - عرض معلوماته مع زر إضافة كمية
            setState(() {
              isProcessing = false;
              _scannedProduct = existing;
            });
          } else {
            // منتج جديد - عرض منتقي الكمية
            setState(() {
              isProcessing = false;
              _pendingProductData = productData;
              _showQuantitySelector = true;
              _isExistingProduct = false;
              _selectedQuantity = 1;
            });
          }
        } else {
          setState(() => isProcessing = false);
          _showErrorDialog('QR Code غير صالح أو لا يحتوي على بيانات منتج');
        }

        controller.stop();
        break;
      }
    }
  }

  Map<String, dynamic>? _parseQRData(String qrData) {
    try {
      Map<String, dynamic> result = {};

      // التنسيق 1: ID:value,NAME:value,PRICE:value,EXP:value
      if (qrData.contains(',') && qrData.contains(':')) {
        List<String> parts = qrData.split(',');
        for (String part in parts) {
          List<String> keyValue = part.split(':');
          if (keyValue.length == 2) {
            String key = keyValue[0].trim().toUpperCase();
            String value = keyValue[1].trim();

            if (key == 'ID') result['productId'] = value;
            if (key == 'NAME') result['name'] = value;
            if (key == 'PRICE') result['price'] = double.parse(value);
            if (key == 'EXP') result['expiryDate'] = value;
          }
        }
      }

      // التنسيق 2: ID:value\nNAME:value\nPRICE:value\nEXP:value
      else if (qrData.contains('\n') && qrData.contains(':')) {
        List<String> lines = qrData.split('\n');
        for (String line in lines) {
          List<String> keyValue = line.split(':');
          if (keyValue.length == 2) {
            String key = keyValue[0].trim().toUpperCase();
            String value = keyValue[1].trim();

            if (key == 'ID') result['productId'] = value;
            if (key == 'NAME') result['name'] = value;
            if (key == 'PRICE') result['price'] = double.parse(value);
            if (key == 'EXP') result['expiryDate'] = value;
          }
        }
      }

      // التنسيق 3: JSON
      else if (qrData.startsWith('{') && qrData.endsWith('}')) {
        String cleanData = qrData.substring(1, qrData.length - 1);
        List<String> pairs = cleanData.split(',');

        for (String pair in pairs) {
          List<String> keyValue = pair.split(':');
          if (keyValue.length == 2) {
            String key = keyValue[0].trim().replaceAll('"', '').toUpperCase();
            String value = keyValue[1].trim().replaceAll('"', '');

            if (key == 'ID') result['productId'] = value;
            if (key == 'NAME') result['name'] = value;
            if (key == 'PRICE') result['price'] = double.parse(value);
            if (key == 'EXP') result['expiryDate'] = value;
          }
        }
      }

      if (result.containsKey('productId') &&
          result.containsKey('name') &&
          result.containsKey('price')) {
        return result;
      }
    } catch (e) {
      debugPrint('خطأ في تحليل QR Code: $e');
      return null;
    }
    return null;
  }

  void _resetScan() {
    setState(() {
      _scannedProduct = null;
      _lastScannedData = null;
      _successMessage = null;
      _showQuantitySelector = false;
      _pendingProductData = null;
      _selectedQuantity = 1;
      _isExistingProduct = false;
    });
    controller.start();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Icon(Icons.error, color: Colors.red, size: 50),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _resetScan();
            },
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}