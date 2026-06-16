// lib/screens/saved_items_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:barcode_widget/barcode_widget.dart';
import '../model/product_model.dart'; // تأكد من المسار (models مش model)
import '../database/database_helper.dart';

class SavedItemsScreen extends StatefulWidget {
  const SavedItemsScreen({super.key});

  @override
  State<SavedItemsScreen> createState() => _SavedItemsScreenState();
}

class _SavedItemsScreenState extends State<SavedItemsScreen> {
  final _dbHelper = DatabaseHelper();
  late Future<List<Product>> _productsFuture;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() {
    setState(() {
      _productsFuture = _dbHelper.getAllProducts();
    });
  }

  // دالة تنسيق تاريخ الصلاحية
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

  // دالة تنسيق وقت التخزين
  String _formatStoredAt(DateTime dateTime) {
    return DateFormat('yyyy/MM/dd - hh:mm a').format(dateTime);
  }

  // استخراج رقم للباركود من ID المنتج
  String _extractNumericCodeForBarcode(String productId) {
    String numbers = productId.replaceAll(RegExp(r'[^0-9]'), '');
    if (numbers.isEmpty) numbers = '1234567890';
    if (numbers.length > 12) numbers = numbers.substring(0, 12);
    return numbers.padRight(12, '0');
  }

  // عرض الباركود في نافذة منبثقة
  void _showBarcodeDialog(Product product) {
    String numericCode = _extractNumericCodeForBarcode(product.productId);

    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
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
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.qr_code_2_outlined, color: Colors.blue),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'باركود ${product.name}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // صورة الباركود المحفوظة (إذا وجدت)
              if (product.barcodeImagePath != null && File(product.barcodeImagePath!).existsSync())
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Image.file(
                        File(product.barcodeImagePath!),
                        width: 300,
                        height: 150,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'صورة الباركود المحفوظة',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                      ),
                    ],
                  ),
                )
              else
              // باركود مولّد إذا لم توجد صورة
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      BarcodeWidget(
                        barcode: Barcode.code128(),
                        data: numericCode,
                        width: 300,
                        height: 100,
                        drawText: false,
                        backgroundColor: Colors.white,
                        color: Colors.black,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'باركود مولّد تلقائياً',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 20),

              // معلومات إضافية
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    _buildInfoRow('المنتج', product.name),
                    const Divider(),
                    _buildInfoRow('ID', product.productId),
                    const Divider(),
                    _buildInfoRow('السعر', '${product.price} ج.م'),
                    const Divider(),
                    _buildInfoRow('الصلاحية', _formatExpiryDate(product.expiryDate)),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // أزرار
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('إغلاق'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                    ),
                  ),
                  if (product.barcodeImagePath != null) ...[
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // مشاركة صورة الباركود
                        },
                        icon: const Icon(Icons.share),
                        label: const Text('مشاركة'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // الحصول على حجم الشاشة
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('المنتجات المخزنة'),
        backgroundColor: const Color(0xFFE67E22),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadProducts,
          ),
        ],
      ),
      body: SafeArea( // إضافة SafeArea
        child: Column(
          children: [
            // شريط البحث
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.04), // 4% من عرض الشاشة
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.toLowerCase();
                  });
                },
                decoration: InputDecoration(
                  hintText: 'بحث عن منتج...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.04,
                    vertical: screenHeight * 0.02,
                  ),
                ),
              ),
            ),

            // قائمة المنتجات
            Expanded(
              child: FutureBuilder<List<Product>>(
                future: _productsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, size: 60, color: Colors.red),
                          const SizedBox(height: 16),
                          Text('حدث خطأ: ${snapshot.error}'),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _loadProducts,
                            child: const Text('إعادة المحاولة'),
                          ),
                        ],
                      ),
                    );
                  }

                  final products = snapshot.data ?? [];

                  // تصفية حسب البحث
                  final filteredProducts = products.where((product) {
                    return product.name.toLowerCase().contains(_searchQuery) ||
                        product.productId.toLowerCase().contains(_searchQuery);
                  }).toList();

                  if (filteredProducts.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(screenWidth * 0.05),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.inventory_2_outlined,
                              size: screenWidth * 0.2, // 20% من عرض الشاشة
                              color: Colors.grey.shade400,
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            Text(
                              products.isEmpty
                                  ? 'لا توجد منتجات مخزنة'
                                  : 'لا توجد نتائج للبحث',
                              style: TextStyle(
                                fontSize: screenWidth * 0.045,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            if (products.isEmpty) ...[
                              SizedBox(height: screenHeight * 0.02),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('إضافة منتج جديد'),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: EdgeInsets.all(screenWidth * 0.04),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return Padding(
                        padding: EdgeInsets.only(bottom: screenHeight * 0.015),
                        child: _buildProductCard(product, screenWidth),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(Product product, double screenWidth) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: () => _showProductDetails(product),
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.03),
          child: Row(
            children: [
              // أيقونة المنتج
              Container(
                width: screenWidth * 0.12, // 12% من عرض الشاشة
                height: screenWidth * 0.12,
                decoration: BoxDecoration(
                  color: const Color(0xFFE67E22).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.inventory,
                  size: screenWidth * 0.06,
                  color: const Color(0xFFE67E22),
                ),
              ),
              SizedBox(width: screenWidth * 0.03),

              // معلومات المنتج
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: TextStyle(
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: screenWidth * 0.01),
                    Text(
                      'ID: ${product.productId}',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: screenWidth * 0.03,
                      ),
                    ),
                    SizedBox(height: screenWidth * 0.02),
                    Row(
                      children: [
                        Text(
                          '${product.price} ج.م',
                          style: TextStyle(
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF2ECC71),
                          ),
                        ),
                        const Spacer(),
                        Flexible(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.02,
                              vertical: screenWidth * 0.01,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              'صلاحية: ${_formatExpiryDate(product.expiryDate)}',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: screenWidth * 0.025,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // أزرار
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // زر عرض الباركود
                  IconButton(
                    icon: Icon(
                      Icons.qr_code_2_outlined,
                      color: Colors.blue,
                      size: screenWidth * 0.06,
                    ),
                    onPressed: () => _showBarcodeDialog(product),
                    tooltip: 'عرض الباركود',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  // زر القائمة
                  PopupMenuButton(
                    icon: Icon(
                      Icons.more_vert,
                      size: screenWidth * 0.06,
                    ),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'view',
                        child: Row(
                          children: [
                            Icon(Icons.visibility, color: Colors.blue, size: 20),
                            SizedBox(width: 8),
                            Text('عرض التفاصيل'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red, size: 20),
                            SizedBox(width: 8),
                            Text('حذف'),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) async {
                      if (value == 'view') {
                        _showProductDetails(product);
                      } else if (value == 'delete') {
                        _showDeleteDialog(product);
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showProductDetails(Product product) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              padding: EdgeInsets.all(screenWidth * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    product.name,
                    style: TextStyle(
                      fontSize: screenWidth * 0.06,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      children: [
                        _buildDetailRow('ID المنتج', product.productId, screenWidth),
                        _buildDetailRow('السعر', '${product.price} ج.م', screenWidth),
                        _buildDetailRow('الكمية', '${product.quantity}', screenWidth),
                        _buildDetailRow('تاريخ الصلاحية', _formatExpiryDate(product.expiryDate), screenWidth),
                        _buildDetailRow('وقت التخزين', _formatStoredAt(product.storedAt), screenWidth),
                        if (product.barcodeImagePath != null) ...[
                          const Divider(),
                          _buildDetailRow('الباركود', 'موجود', screenWidth),
                        ],
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  // زر عرض الباركود
                  if (product.barcodeImagePath != null)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _showBarcodeDialog(product);
                        },
                        icon: const Icon(Icons.qr_code_2_outlined),
                        label: const Text('عرض الباركود'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, double screenWidth) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: screenWidth * 0.25,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
                fontSize: screenWidth * 0.035,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: screenWidth * 0.04,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(Product product) async {
    final screenWidth = MediaQuery.of(context).size.width;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: Text('هل أنت متأكد من حذف "${product.name}"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('حذف'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      int result = await _dbHelper.deleteProduct(product.id!);
      if (result > 0) {
        _loadProducts();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('تم حذف "${product.name}" بنجاح'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }
}