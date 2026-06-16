// lib/screens/manual_add_dialog.dart
import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../model/product_model.dart';  // تأكد من المسار models مش model
import '../model/product_data.dart';    // استيراد JSON

class ManualAddDialog extends StatefulWidget {
  const ManualAddDialog({super.key});

  @override
  State<ManualAddDialog> createState() => _ManualAddDialogState();
}

class _ManualAddDialogState extends State<ManualAddDialog> {
  final _formKey = GlobalKey<FormState>();
  final _dbHelper = DatabaseHelper();

  final _productIdController = TextEditingController();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();

  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;
  String _expiryDate = '';
  bool _isLoading = false;

  // للبحث والاختيار من المنتجات الموجودة في قاعدة البيانات
  List<Product> _existingProducts = [];

  // للبحث والاختيار من منتجات JSON
  List<JsonProduct> _jsonProducts = [];

  bool _isSearching = false;
  String _searchText = '';

  // المنتج المختار (إذا كان موجود)
  Product? _selectedProduct;

  // متغير للتبديل بين المصادر
  bool _useJsonProducts = true; // true = JSON, false = قاعدة البيانات

  final List<String> _months = [
    'يناير', 'فبراير', 'مارس', 'إبريل', 'مايو', 'يونيو',
    'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
  ];

  final List<int> _years = List.generate(10, (index) => DateTime.now().year + index);

  @override
  void initState() {
    super.initState();
    _updateExpiryDate();
    _loadExistingProducts();
    _loadJsonProducts();
  }

  // تحميل المنتجات الموجودة في قاعدة البيانات
  Future<void> _loadExistingProducts() async {
    List<Product> products = await _dbHelper.getAllProducts();
    setState(() {
      _existingProducts = products;
    });
  }

  // تحميل المنتجات من JSON
  Future<void> _loadJsonProducts() async {
    List<JsonProduct> products = await ProductDataLoader.loadProducts();
    setState(() {
      _jsonProducts = products;
    });
  }

  void _updateExpiryDate() {
    setState(() {
      _expiryDate = '${_selectedYear.toString()}-${_selectedMonth.toString().padLeft(2, '0')}';
    });
  }

  // اختيار منتج من قاعدة البيانات
  void _selectProduct(Product product) {
    setState(() {
      _productIdController.text = product.productId;
      _nameController.text = product.name;
      _priceController.text = product.price.toString();
      _selectedProduct = product;

      // تحويل تاريخ الصلاحية
      try {
        List<String> parts = product.expiryDate.split('-');
        if (parts.length == 2) {
          _selectedYear = int.parse(parts[0]);
          _selectedMonth = int.parse(parts[1]);
          _updateExpiryDate();
        }
      } catch (e) {
        // إذا فشل التحليل، استخدم التاريخ الحالي
      }

      _isSearching = false;
      _searchText = '';

      _showMessage('سيتم إضافة الكمية للمنتج الموجود', Colors.blue);
    });
  }

  // اختيار منتج من JSON
  void _selectJsonProduct(JsonProduct jsonProduct) {
    setState(() {
      _productIdController.text = jsonProduct.id;
      _nameController.text = jsonProduct.name;
      _priceController.text = jsonProduct.price.toString();

      // تعيين تاريخ صلاحية افتراضي (بعد سنة)
      DateTime now = DateTime.now();
      _selectedYear = now.year + 1;
      _selectedMonth = now.month;
      _updateExpiryDate();

      _selectedProduct = null; // لأنه مش موجود في قاعدة البيانات
      _isSearching = false;
      _searchText = '';

      _showMessage('تم اختيار المنتج من JSON، أدخل الكمية المضافة', Colors.blue);
    });
  }

  // حفظ أو إضافة كمية للمنتج
  Future<void> _saveOrUpdateProduct() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        // البحث عن المنتج بالـ ID في قاعدة البيانات
        Product? existing = await _dbHelper.getProductByProductId(_productIdController.text);

        if (existing != null) {
          // المنتج موجود - نضيف الكمية للمخزون الحالي
          int newQuantity = existing.quantity + int.parse(_quantityController.text);

          Product updatedProduct = Product(
            id: existing.id,
            productId: existing.productId,
            name: existing.name,
            price: existing.price,
            quantity: newQuantity,
            expiryDate: existing.expiryDate,
            storedAt: DateTime.now(),
            barcodeImagePath: existing.barcodeImagePath,
          );

          int result = await _dbHelper.updateProduct(updatedProduct);

          setState(() => _isLoading = false);

          if (result > 0) {
            Navigator.pop(context, true);
            _showMessage('✅ تم إضافة ${_quantityController.text} وحدات للمخزون', Colors.green);
          }
        } else {
          // منتج جديد - نضيفه كامل
          Product newProduct = Product(
            productId: _productIdController.text,
            name: _nameController.text,
            price: double.parse(_priceController.text),
            quantity: int.parse(_quantityController.text),
            expiryDate: _expiryDate,
            storedAt: DateTime.now(),
            barcodeImagePath: null,
          );

          int id = await _dbHelper.insertProduct(newProduct);

          setState(() => _isLoading = false);

          if (id > 0) {
            Navigator.pop(context, true);
            _showMessage('✅ تم إضافة المنتج الجديد بنجاح', Colors.green);
          }
        }
      } catch (e) {
        setState(() => _isLoading = false);
        _showMessage('❌ حدث خطأ: $e', Colors.red);
      }
    }
  }

  void _showMessage(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth * 0.9,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // العنوان
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2ECC71).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.add_box, color: Color(0xFF2ECC71)),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'إضافة منتج',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // أزرار اختيار المصدر
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _useJsonProducts = true;
                          _isSearching = true;
                          _searchText = '';
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _useJsonProducts ? Colors.blue : Colors.grey,
                        side: BorderSide(
                          color: _useJsonProducts ? Colors.blue : Colors.grey,
                        ),
                      ),
                      child: const Text('منتجات JSON'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _useJsonProducts = false;
                          _isSearching = true;
                          _searchText = '';
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: !_useJsonProducts ? const Color(0xFF2ECC71) : Colors.grey,
                        side: BorderSide(
                          color: !_useJsonProducts ? const Color(0xFF2ECC71) : Colors.grey,
                        ),
                      ),
                      child: const Text('منتجات المخزون'),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              // زر البحث
              OutlinedButton.icon(
                onPressed: () {
                  setState(() {
                    _isSearching = !_isSearching;
                    _searchText = '';
                  });
                },
                icon: Icon(_isSearching ? Icons.close : Icons.search),
                label: Text(_isSearching ? 'إلغاء البحث' : 'اختيار من المنتجات'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: _useJsonProducts ? Colors.blue : const Color(0xFF2ECC71),
                  side: BorderSide(
                    color: _useJsonProducts ? Colors.blue : const Color(0xFF2ECC71),
                  ),
                  minimumSize: const Size(double.infinity, 45),
                ),
              ),

              // قائمة المنتجات (للاختيار)
              if (_isSearching) ...[
                const SizedBox(height: 15),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      _searchText = value.toLowerCase();
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'ابحث عن منتج...',
                    prefixIcon: Icon(
                      Icons.search,
                      color: _useJsonProducts ? Colors.blue : const Color(0xFF2ECC71),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  constraints: BoxConstraints(
                    maxHeight: 200,
                  ),
                  child: _useJsonProducts
                      ? _buildJsonProductList()
                      : _buildDatabaseProductList(),
                ),
                const SizedBox(height: 10),
                const Divider(),
              ],

              const SizedBox(height: 15),

              // الفورم
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // ID المنتج
                    TextFormField(
                      controller: _productIdController,
                      decoration: InputDecoration(
                        labelText: 'ID المنتج',
                        prefixIcon: Icon(
                          Icons.tag,
                          color: _useJsonProducts ? Colors.blue : const Color(0xFF2ECC71),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: 'مثال: PRD001',
                      ),
                      validator: (value) => value!.isEmpty ? 'الرجاء إدخال ID المنتج' : null,
                      onChanged: (value) {
                        // إذا تغير الـ ID، نلغي اختيار المنتج السابق
                        if (_selectedProduct != null &&
                            _selectedProduct!.productId != value) {
                          setState(() {
                            _selectedProduct = null;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 15),

                    // اسم المنتج
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'اسم المنتج',
                        prefixIcon: Icon(
                          Icons.shopping_bag,
                          color: _useJsonProducts ? Colors.blue : const Color(0xFF2ECC71),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) => value!.isEmpty ? 'الرجاء إدخال اسم المنتج' : null,
                    ),
                    const SizedBox(height: 15),

                    // السعر
                    TextFormField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'السعر',
                        prefixIcon: Icon(
                          Icons.attach_money,
                          color: _useJsonProducts ? Colors.blue : const Color(0xFF2ECC71),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) return 'الرجاء إدخال السعر';
                        if (double.tryParse(value) == null) return 'الرجاء إدخال رقم صحيح';
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),

                    // الكمية
                    TextFormField(
                      controller: _quantityController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: _selectedProduct != null
                            ? 'الكمية المضافة للمخزون'
                            : 'الكمية',
                        prefixIcon: Icon(
                          Icons.numbers,
                          color: _useJsonProducts ? Colors.blue : const Color(0xFF2ECC71),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: _selectedProduct != null
                            ? 'أدخل الكمية المراد إضافتها'
                            : 'أدخل الكمية',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) return 'الرجاء إدخال الكمية';
                        if (int.tryParse(value) == null) return 'الرجاء إدخال رقم صحيح';
                        if (int.parse(value) <= 0) return 'الكمية يجب أن تكون أكبر من صفر';
                        return null;
                      },
                    ),

                    // إذا كان المنتج موجود، نعرض الكمية الحالية
                    if (_selectedProduct != null) ...[
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue.shade200),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.info, color: Colors.blue, size: 16),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'الكمية الحالية في المخزون: ${_selectedProduct!.quantity}',
                                style: const TextStyle(color: Colors.blue),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 20),

                    // تاريخ الصلاحية
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'تاريخ الصلاحية',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              // اختيار الشهر
                              Expanded(
                                child: DropdownButtonFormField<int>(
                                  value: _selectedMonth,
                                  decoration: InputDecoration(
                                    labelText: 'الشهر',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  items: List.generate(12, (index) {
                                    return DropdownMenuItem(
                                      value: index + 1,
                                      child: Text(_months[index]),
                                    );
                                  }),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedMonth = value!;
                                      _updateExpiryDate();
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),

                              // اختيار السنة
                              Expanded(
                                child: DropdownButtonFormField<int>(
                                  value: _selectedYear,
                                  decoration: InputDecoration(
                                    labelText: 'السنة',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  items: _years.map((year) {
                                    return DropdownMenuItem(
                                      value: year,
                                      child: Text(year.toString()),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedYear = value!;
                                      _updateExpiryDate();
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today, size: 16, color: Color(0xFF2ECC71)),
                                const SizedBox(width: 8),
                                Text(
                                  'تاريخ الصلاحية: ${_months[_selectedMonth - 1]} $_selectedYear',
                                  style: const TextStyle(color: Color(0xFF2ECC71)),
                                ),
                              ],
                            ),
                          ),
                        ],
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
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('إلغاء'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _saveOrUpdateProduct,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2ECC71),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                          : Text(_selectedProduct != null ? 'إضافة كمية' : 'حفظ'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // قائمة المنتجات من JSON
  Widget _buildJsonProductList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _jsonProducts.length,
      itemBuilder: (context, index) {
        final product = _jsonProducts[index];

        // تصفية حسب البحث
        if (_searchText.isNotEmpty &&
            !product.name.toLowerCase().contains(_searchText) &&
            !product.id.toLowerCase().contains(_searchText)) {
          return const SizedBox.shrink();
        }

        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.blue.withOpacity(0.1),
            child: const Icon(Icons.cloud, color: Colors.blue, size: 20),
          ),
          title: Text(product.name),
          subtitle: Text('${product.price} ج.م'),
          trailing: const Icon(Icons.add, color: Colors.blue),
          onTap: () => _selectJsonProduct(product),
        );
      },
    );
  }

  // قائمة المنتجات من قاعدة البيانات
  Widget _buildDatabaseProductList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _existingProducts.length,
      itemBuilder: (context, index) {
        final product = _existingProducts[index];

        // تصفية حسب البحث
        if (_searchText.isNotEmpty &&
            !product.name.toLowerCase().contains(_searchText) &&
            !product.productId.toLowerCase().contains(_searchText)) {
          return const SizedBox.shrink();
        }

        return ListTile(
          leading: CircleAvatar(
            backgroundColor: const Color(0xFF2ECC71).withOpacity(0.1),
            child: const Icon(Icons.inventory, color: Color(0xFF2ECC71), size: 20),
          ),
          title: Text(product.name),
          subtitle: Text('ID: ${product.productId} - الكمية: ${product.quantity}'),
          trailing: const Icon(Icons.add, color: Color(0xFF2ECC71)),
          onTap: () => _selectProduct(product),
        );
      },
    );
  }

  @override
  void dispose() {
    _productIdController.dispose();
    _nameController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }
}