// lib/screens/read_qr_screen.dart
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ReadQRScreen extends StatefulWidget {
  const ReadQRScreen({super.key});

  @override
  State<ReadQRScreen> createState() => _ReadQRScreenState();
}

class _ReadQRScreenState extends State<ReadQRScreen> {
  final MobileScannerController controller = MobileScannerController(
    formats: [BarcodeFormat.qrCode], // فقط QR Code
  );

  bool isFlashOn = false;
  bool isProcessing = false;
  Barcode? _scannedQR;
  String? _rawData;
  Map<String, dynamic>? _decodedData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('قراءة QR Code فقط'),
        backgroundColor: const Color(0xFF3498DB), // لون أزرق
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
            icon: const Icon(Icons.refresh),
            onPressed: _resetScan,
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
                      'قراءة فقط - لن يتم التخزين',
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
                      'جاري قراءة QR Code...',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),

      bottomSheet: _scannedQR != null ? _buildResultSheet() : null,
    );
  }

  Widget _buildResultSheet() {
    return
      SafeArea(child:  Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // عنوان مع أيقونة
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF3498DB).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.qr_code, color: Color(0xFF3498DB)),
              ),
              const SizedBox(width: 10),
              const Text(
                'بيانات QR Code',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.copy, color: Colors.grey),
                onPressed: _copyToClipboard,
                tooltip: 'نسخ البيانات',
              ),
            ],
          ),
          const SizedBox(height: 20),

          // معلومات QR Code
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // نوع الباركود
                _buildInfoRow('النوع', 'QR Code'),
                const Divider(),

                // البيانات الخام
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.data_usage, size: 18, color: Colors.blue),
                          SizedBox(width: 8),
                          Text(
                            'البيانات الخام:',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      SelectableText(
                        _rawData ?? '',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'طول البيانات: ${_rawData?.length ?? 0} حرف',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 15),

                // البيانات المحللة (إذا وجدت)
                if (_decodedData != null && _decodedData!.isNotEmpty) ...[
                  const Text(
                    'البيانات المحللة:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ..._buildDecodedData(),
                ],

                // إذا كان JSON
                if (_rawData != null &&
                    _rawData!.startsWith('{') &&
                    _rawData!.endsWith('}')) ...[
                  const Divider(),
                  _buildInfoRow('نوع البيانات', 'JSON'),
                ],

                // إذا كان نص عادي
                if (_decodedData == null || _decodedData!.isEmpty) ...[
                  const Divider(),
                  _buildInfoRow('نوع البيانات', 'نص عادي'),
                ],
              ],
            ),
          ),

          const SizedBox(height: 20),

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
      )
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
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
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildDecodedData() {
    List<Widget> widgets = [];
    _decodedData!.forEach((key, value) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 80,
                child: Text(
                  '$key:',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3498DB),
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  value.toString(),
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      );
    });
    return widgets;
  }

  void _onDetect(BarcodeCapture capture) async {
    if (isProcessing || _scannedQR != null) return;

    for (final barcode in capture.barcodes) {
      if (barcode.rawValue != null) {
        setState(() {
          isProcessing = true;
        });

        await Future.delayed(const Duration(milliseconds: 500));

        setState(() {
          isProcessing = false;
          _scannedQR = barcode;
          _rawData = barcode.rawValue!;
          _decodedData = _parseQRData(barcode.rawValue!);
        });

        controller.stop();
        break;
      }
    }
  }

  Map<String, dynamic>? _parseQRData(String qrData) {
    // محاولة تحليل JSON
    if (qrData.startsWith('{') && qrData.endsWith('}')) {
      try {
        // محاولة تحليل JSON (في تطبيق حقيقي هنستخدم json.decode)
        // لكن هنا هنستخدم طريقة بسيطة
        Map<String, dynamic> result = {};

        // إزالة الأقواس
        String cleanData = qrData.substring(1, qrData.length - 1);
        List<String> pairs = cleanData.split(',');

        for (String pair in pairs) {
          List<String> keyValue = pair.split(':');
          if (keyValue.length == 2) {
            String key = keyValue[0].trim().replaceAll('"', '');
            String value = keyValue[1].trim().replaceAll('"', '');
            result[key] = value;
          }
        }

        if (result.isNotEmpty) {
          return result;
        }
      } catch (e) {
        debugPrint('خطأ في تحليل JSON: $e');
      }
    }

    // تحليل البيانات بالمفاتيح المألوفة (ID, NAME, PRICE, EXP)
    try {
      Map<String, dynamic> result = {};

      // البحث عن الأنماط
      RegExp idReg = RegExp(r'ID[:\s]+([^\n,]+)');
      RegExp nameReg = RegExp(r'NAME[:\s]+([^\n,]+)');
      RegExp priceReg = RegExp(r'PRICE[:\s]+([^\n,]+)');
      RegExp expReg = RegExp(r'EXP[:\s]+([^\n,]+)');

      Match? idMatch = idReg.firstMatch(qrData);
      Match? nameMatch = nameReg.firstMatch(qrData);
      Match? priceMatch = priceReg.firstMatch(qrData);
      Match? expMatch = expReg.firstMatch(qrData);

      if (idMatch != null) result['ID'] = idMatch.group(1)?.trim();
      if (nameMatch != null) result['الاسم'] = nameMatch.group(1)?.trim();
      if (priceMatch != null) result['السعر'] = '${priceMatch.group(1)?.trim()} ج.م';
      if (expMatch != null) {
        String exp = expMatch.group(1)?.trim() ?? '';
        // محاولة تنسيق التاريخ
        if (exp.contains('-')) {
          List<String> dateParts = exp.split('-');
          if (dateParts.length == 2) {
            List<String> months = [
              'يناير', 'فبراير', 'مارس', 'إبريل', 'مايو', 'يونيو',
              'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
            ];
            int month = int.parse(dateParts[1]);
            result['الصلاحية'] = '${months[month - 1]} ${dateParts[0]}';
          } else {
            result['الصلاحية'] = exp;
          }
        } else {
          result['الصلاحية'] = exp;
        }
      }

      if (result.isNotEmpty) {
        return result;
      }
    } catch (e) {
      debugPrint('خطأ في تحليل البيانات: $e');
    }

    // إذا لم نتمكن من التحليل
    return null;
  }

  void _copyToClipboard() {
    if (_rawData != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم نسخ البيانات'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  void _resetScan() {
    setState(() {
      _scannedQR = null;
      _rawData = null;
      _decodedData = null;
    });
    controller.start();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}