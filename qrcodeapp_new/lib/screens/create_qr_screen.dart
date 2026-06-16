// lib/screens/create_barcode_screen.dart
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart'; // استخدم QR بدل Barcode
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';

class CreateBarcodeScreen extends StatefulWidget{
  const CreateBarcodeScreen({super.key});

  @override
  State<CreateBarcodeScreen> createState() => _CreateBarcodeScreenState();
}

class _CreateBarcodeScreenState extends State<CreateBarcodeScreen> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey _qrRepaintKey = GlobalKey(); // غيرنا الاسم

  final _productIdController = TextEditingController();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();

  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;
  String _expiryDate = '';
  bool _isLoading = false;

  // متغيرات لعرض QR Code
  bool _showQR = false;
  String _qrData = ''; // البيانات اللي هتتخزن في QR

  final List<String> _months = [
    'يناير', 'فبراير', 'مارس', 'إبريل', 'مايو', 'يونيو',
    'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
  ];

  final List<int> _years = List.generate(10, (index) => DateTime.now().year + index);

  @override
  void initState() {
    super.initState();
    _updateExpiryDate();
  }

  void _updateExpiryDate() {
    setState(() {
      _expiryDate = '${_selectedYear.toString()}-${_selectedMonth.toString().padLeft(2, '0')}';
    });
  }

  // إنشاء QR Code بالبيانات
  void _createQR() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          // البيانات كاملة في QR Code
          _qrData = 'ID:${_productIdController.text}\n'
              'NAME:${_nameController.text}\n'
              'PRICE:${_priceController.text}\n'
              'EXP:$_expiryDate';

          _showQR = true;
          _isLoading = false;
        });
      });
    }
  }

  // دالة طلب صلاحيات التخزين
  Future<bool> _requestStoragePermission() async {
    PermissionStatus status = await Permission.storage.request();
    print('📱 نتيجة طلب permission_handler: $status');

    if (status.isGranted) {
      return true;
    }

    if (await Permission.photos.request().isGranted) {
      return true;
    }

    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        return true;
      }
    } catch (e) {
      print('خطأ في image_picker: $e');
    }

    if (await Permission.storage.isPermanentlyDenied) {
      bool? openSettings = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('صلاحية التخزين مطلوبة'),
          content: const Text(
              'نحتاج إلى صلاحية التخزين لحفظ QR Code في معرض الصور.\n'
                  'الرجاء السماح بالصلاحية من الإعدادات.'
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('فتح الإعدادات'),
            ),
          ],
        ),
      );

      if (openSettings == true) {
        await openAppSettings();
      }
    }

    return false;
  }

  // دالة حفظ QR Code
  Future<void> _saveQRToGallery() async {
    _showMessage('🔄 جاري طلب صلاحية التخزين...', Colors.blue);

    try {
      bool hasPermission = await _requestStoragePermission();
      if (!hasPermission) {
        _showMessage('❌ لا يمكن حفظ الصورة بدون صلاحية', Colors.red);
        return;
      }

      _showMessage('🔄 جاري حفظ QR Code...', Colors.blue);

      RenderRepaintBoundary boundary = _qrRepaintKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) {
        _showMessage('❌ فشل في التقاط الصورة', Colors.red);
        return;
      }

      final tempDir = await getTemporaryDirectory();
      final tempPath = '${tempDir.path}/qr_${DateTime.now().millisecondsSinceEpoch}.png';
      final tempFile = File(tempPath);
      await tempFile.writeAsBytes(byteData.buffer.asUint8List());

      final result = await GallerySaver.saveImage(
        tempFile.path,
        albumName: 'QR Code Manager',
      );

      if (await tempFile.exists()) {
        await tempFile.delete();
      }

      if (result != null && result) {
        _showMessage('✅ تم حفظ QR Code في المعرض', Colors.green);
      } else {
        _showMessage('❌ فشل في حفظ الصورة', Colors.red);
      }
    } catch (e) {
      _showMessage('❌ حدث خطأ: $e', Colors.red);
    }
  }

  // مشاركة QR Code
  Future<void> _shareQR() async {
    try {
      RenderRepaintBoundary boundary = _qrRepaintKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) {
        _showMessage('❌ فشل في التقاط الصورة', Colors.red);
        return;
      }

      final tempDir = await getTemporaryDirectory();
      final tempPath = '${tempDir.path}/qr_share.png';
      final tempFile = File(tempPath);
      await tempFile.writeAsBytes(byteData.buffer.asUint8List());

      String shareText = 'QR Code المنتج: ${_nameController.text}\n';
      shareText += 'السعر: ${_priceController.text} ج.م\n';
      shareText += 'تاريخ الصلاحية: ${_months[_selectedMonth - 1]} $_selectedYear';

      await Share.shareXFiles(
        [XFile(tempFile.path)],
        text: shareText,
      );
    } catch (e) {
      _showMessage('❌ حدث خطأ: $e', Colors.red);
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

  void _resetForm() {
    setState(() {
      _showQR = false;
      _productIdController.clear();
      _nameController.clear();
      _priceController.clear();
      _selectedMonth = DateTime.now().month;
      _selectedYear = DateTime.now().year;
      _updateExpiryDate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إنشاء QR Code'),
        backgroundColor: const Color(0xFF3498DB),
        foregroundColor: Colors.white,
      ),
      body:
      SafeArea(child:  SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // نموذج الإدخال
            if (!_showQR) ...[
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _productIdController,
                      decoration: InputDecoration(
                        labelText: 'ID المنتج',
                        prefixIcon: const Icon(Icons.tag, color: Color(0xFF3498DB)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: 'مثال: PRD001',
                      ),
                      validator: (value) => value!.isEmpty ? 'الرجاء إدخال ID المنتج' : null,
                    ),
                    const SizedBox(height: 15),

                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'اسم المنتج',
                        prefixIcon: const Icon(Icons.shopping_bag, color: Color(0xFF3498DB)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) => value!.isEmpty ? 'الرجاء إدخال اسم المنتج' : null,
                    ),
                    const SizedBox(height: 15),

                    TextFormField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'السعر',
                        prefixIcon: const Icon(Icons.attach_money, color: Color(0xFF3498DB)),
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
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today, size: 16, color: Colors.blue),
                                const SizedBox(width: 8),
                                Text(
                                  'تاريخ الصلاحية: ${_months[_selectedMonth - 1]} $_selectedYear',
                                  style: const TextStyle(color: Colors.blue),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _createQR,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3498DB),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                          'إنشاء QR Code',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // عرض QR Code بعد الإنشاء
            if (_showQR) ...[
              RepaintBoundary(
                key: _qrRepaintKey,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'QR Code الخاص بالمنتج',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),

                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            // QR Code بالبيانات
                            QrImageView(
                              data: _qrData,
                              version: QrVersions.auto,
                              size: 200,
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                            ),
                            const SizedBox(height: 20),

                            // اسم المنتج تحت QR
                            Text(
                              _nameController.text,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),

                            // ID المنتج
                            Text(
                              'ID: ${_productIdController.text}',
                              style: TextStyle(color: Colors.grey.shade600),
                            ),

                            const SizedBox(height: 10),

                            // البيانات كاملة (للتوضيح)
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: SelectableText(
                                _qrData,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.blue,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // أزرار الإجراءات
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _resetForm,
                      icon: const Icon(Icons.refresh),
                      label: const Text('جديد'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _saveQRToGallery,
                      icon: const Icon(Icons.save_alt),
                      label: const Text('حفظ'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _shareQR,
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
      ),
      )
    );
  }

  @override
  void dispose() {
    _productIdController.dispose();
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }
}