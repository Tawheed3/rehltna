import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_colors.dart';
import '../../data/providers/payment_methods_provider.dart';
import '../../data/services/settings_service.dart';
import '../../data/models/item_model.dart';
import '../../data/models/payment_method_model.dart';

class CheckoutScreen extends StatefulWidget {
  final ItemModel item;
  final PaymentMethodModel paymentMethod;
  final double price;
  final int? attendees;
  final List<Map<String, dynamic>>? selectedPrices;

  const CheckoutScreen({
    Key? key,
    required this.item,
    required this.paymentMethod,
    required this.price,
    this.attendees,
    this.selectedPrices,
  }) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _couponController = TextEditingController();
  bool _isLoading = false;
  File? _receiptFile;
  Map<String, dynamic>? _checkoutResult;
  bool _isCheckingCoupon = false;
  String? _couponMessage;
  bool _isCouponValid = false;
  double _discountAmount = 0;
  double _finalPrice = 0;
  bool _usePoints = false;
  final ImagePicker _picker = ImagePicker();
  late List<Map<String, dynamic>> _localSelectedPrices;
  late int _localAttendees;
  double _discountPercentage = 0;
  bool _orderCreated = false; // ✅ هل تم إنشاء الطلب

  @override
  void initState() {
    super.initState();
    _finalPrice = widget.price;
    if (widget.selectedPrices != null && widget.selectedPrices!.isNotEmpty) {
      _localSelectedPrices = List.from(
          widget.selectedPrices!.map((e) => Map<String, dynamic>.from(e)));
      _localAttendees = _getTotalFromLocal();
    } else if (widget.item.prices.isNotEmpty) {
      _localSelectedPrices = [
        {
          "price_id": widget.item.prices.first.id,
          "attendees": widget.attendees ?? 1
        }
      ];
      _localAttendees = widget.attendees ?? 1;
    } else {
      _localSelectedPrices = [];
      _localAttendees = widget.attendees ?? 1;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _couponController.dispose();
    super.dispose();
  }

  int _getTotalFromLocal() {
    int t = 0;
    for (var p in _localSelectedPrices) {
      t += (p['attendees'] as int?) ?? 0;
    }
    return t;
  }

  double _calculateLocalPrice() {
    if (_localAttendees == 0) return 0;
    double t = 0;
    for (var sp in _localSelectedPrices) {
      final pid = sp['price_id'] as int?;
      final att = sp['attendees'] as int? ?? 0;
      if (pid != null && att > 0) {
        final rt = widget.item.getPriceById(pid);
        if (rt != null) t += rt.effectivePrice * att;
      }
    }
    return t > 0 ? t : widget.price;
  }

  void _updateLocalAttendees(int priceId, int delta) {
    setState(() {
      for (int i = 0; i < _localSelectedPrices.length; i++) {
        if (_localSelectedPrices[i]['price_id'] == priceId) {
          int cur = (_localSelectedPrices[i]['attendees'] as int?) ?? 0;
          int nv = cur + delta;
          if (nv >= 0 && nv <= 50) _localSelectedPrices[i]['attendees'] = nv;
          break;
        }
      }

      _localAttendees = _getTotalFromLocal();

      if (_localAttendees == 0) {
        _finalPrice = 0;
        _discountAmount = 0;
        return;
      }

      final newPrice = _calculateLocalPrice();

      if (_isCouponValid && _discountPercentage > 0) {
        _discountAmount = newPrice * _discountPercentage;
        _finalPrice = newPrice - _discountAmount;
        if (_finalPrice < 0) _finalPrice = 0;
      } else {
        _finalPrice = newPrice;
      }
    });
  }

  Future<void> _checkCoupon() async {
    if (_localAttendees == 0) {
      setState(() => _couponMessage = '❌ الرجاء اختيار عدد الأفراد أولاً');
      return;
    }
    if (_couponController.text.isEmpty && !_usePoints) {
      setState(() => _couponMessage = '❌ الرجاء إدخال كود الخصم أو تفعيل استخدام النقاط');
      return;
    }
    if (_emailController.text.isEmpty) {
      setState(() => _couponMessage = '❌ الرجاء إدخال البريد الإلكتروني أولاً');
      return;
    }

    setState(() {
      _isCheckingCoupon = true;
      _couponMessage = null;
    });

    try {
      final items = [
        {"item_id": widget.item.id, "selected_prices": _localSelectedPrices}
      ];

      final result = await Provider.of<PaymentMethodsProvider>(context, listen: false).checkCoupon(
        email: _emailController.text,
        items: items,
        couponCode: _couponController.text.isNotEmpty ? _couponController.text : null,
        usePoints: _usePoints,
      );

      if (result != null && result['code'] == 200) {
        final data = result['data'];
        double d = 0;
        double subTotal = 0;

        if (data['total_discount'] != null) d = (data['total_discount'] as num).toDouble();
        if (data['sub_total'] != null) subTotal = (data['sub_total'] as num).toDouble();

        final currentPrice = _calculateLocalPrice();

        if (d > 0 && subTotal > 0) {
          _discountPercentage = d / subTotal;
        } else {
          _discountPercentage = 0;
        }

        _discountAmount = currentPrice * _discountPercentage;
        _finalPrice = currentPrice - _discountAmount;

        setState(() {
          _isCouponValid = true;
          if (_discountPercentage > 0) {
            _couponMessage = '✅ خصم ${_discountAmount.toStringAsFixed(0)} ريال';
          }
          if (_finalPrice < 0) _finalPrice = 0;
        });
      } else {
        setState(() {
          _isCouponValid = false;
          _couponMessage = '❌ ${result?['message'] ?? 'كود غير صالح'}';
          _discountAmount = 0;
          _discountPercentage = 0;
          _finalPrice = _calculateLocalPrice();
        });
      }
    } catch (e) {
      setState(() {
        _isCouponValid = false;
        _couponMessage = '❌ حدث خطأ';
        _discountPercentage = 0;
        _finalPrice = _calculateLocalPrice();
      });
    } finally {
      setState(() => _isCheckingCoupon = false);
    }
  }

  void _removeCoupon() {
    setState(() {
      _couponController.clear();
      _isCouponValid = false;
      _couponMessage = null;
      _discountAmount = 0;
      _discountPercentage = 0;
      _finalPrice = _localAttendees > 0 ? _calculateLocalPrice() : 0;
      _usePoints = false;
    });
  }

  List<Map<String, dynamic>> _buildItemsForCheckout() {
    return [
      {
        "item_id": widget.item.id,
        "attendees": _localAttendees,
        "selected_prices": _localSelectedPrices
      }
    ];
  }

  // ==================== ملخص الطلب ====================

  Widget _buildOrderSummary(SettingsService ss) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.receipt_long, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text('ملخص الطلب', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.flight_takeoff, color: Colors.white70, size: 16),
              const SizedBox(width: 6),
              Expanded(child: Text(widget.item.getTitle(ss.languageCode), style: const TextStyle(color: Colors.white, fontSize: 14))),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.nightlight_round, color: Colors.green, size: 14),
              const SizedBox(width: 6),
              Text('${widget.item.totalNights} ليالي', style: const TextStyle(color: Colors.white70, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: Colors.white24),
          const SizedBox(height: 12),
          if (_localSelectedPrices.isNotEmpty) ...[
            const Row(
              children: [
                Icon(Icons.hotel, color: Colors.amber, size: 16),
                SizedBox(width: 6),
                Text('تفاصيل الحجز', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            ..._localSelectedPrices.map((sp) {
              final pid = sp['price_id'] as int?;
              final att = sp['attendees'] as int? ?? 0;
              if (pid == null) return const SizedBox.shrink();
              final rt = widget.item.getPriceById(pid);
              if (rt == null) return const SizedBox.shrink();
              final st = att > 0 ? rt.effectivePrice * att : 0;

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: att > 0 ? Colors.white.withOpacity(0.1) : Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 22, height: 22,
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(5)),
                          child: Center(child: Text('$att', style: TextStyle(color: att > 0 ? Colors.white : Colors.white38, fontSize: 10, fontWeight: FontWeight.bold))),
                        ),
                        const SizedBox(width: 8),
                        Expanded(child: Text(rt.getTitle('ar'), style: TextStyle(color: att > 0 ? Colors.white : Colors.white38, fontSize: 12, fontWeight: FontWeight.w600))),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: att > 0 ? () => _updateLocalAttendees(pid, -1) : null,
                              child: Container(
                                width: 26, height: 26,
                                decoration: BoxDecoration(color: att > 0 ? Colors.white.withOpacity(0.2) : Colors.white.withOpacity(0.05), shape: BoxShape.circle),
                                child: Icon(Icons.remove, color: att > 0 ? Colors.white : Colors.white24, size: 14),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text('$att', style: TextStyle(color: att > 0 ? Colors.white : Colors.white38, fontSize: 13, fontWeight: FontWeight.bold)),
                            const SizedBox(width: 6),
                            GestureDetector(
                              onTap: () => _updateLocalAttendees(pid, 1),
                              child: Container(
                                width: 26, height: 26,
                                decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
                                child: const Icon(Icons.add, color: Colors.white, size: 14),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const SizedBox(width: 30),
                        Expanded(child: Text(att > 0 ? '$att فرد × ${rt.effectivePrice.toStringAsFixed(0)} ريال' : '0 فرد', style: TextStyle(color: att > 0 ? Colors.white54 : Colors.white24, fontSize: 11))),
                        Text('$st ريال', style: TextStyle(color: att > 0 ? Colors.white : Colors.white38, fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 8),
            const Divider(color: Colors.white24),
            const SizedBox(height: 8),
          ],
          Row(
            children: [
              const Icon(Icons.people, color: Colors.white70, size: 14),
              const SizedBox(width: 6),
              Text('إجمالي المسافرين: $_localAttendees فرد', style: const TextStyle(color: Colors.white70, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(padding: EdgeInsets.only(left: 12), child: Text('الإجمالي', style: TextStyle(color: Colors.white70, fontSize: 14))),
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Text('${_localAttendees > 0 ? _calculateLocalPrice().toStringAsFixed(0) : "0"} ريال',
                      style: TextStyle(color: _localAttendees > 0 ? Colors.white : Colors.white38, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          if (_isCouponValid && _localAttendees > 0 && _discountAmount > 0) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(color: Colors.green.withOpacity(0.15), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.green.withOpacity(0.3))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(padding: EdgeInsets.only(left: 12), child: Row(children: [Icon(Icons.discount, color: Colors.green, size: 16), SizedBox(width: 6), Text('الخصم', style: TextStyle(color: Colors.green, fontSize: 14))])),
                  Padding(padding: const EdgeInsets.only(right: 12), child: Text('-${_discountAmount.toStringAsFixed(0)} ريال', style: const TextStyle(color: Colors.green, fontSize: 16, fontWeight: FontWeight.bold))),
                ],
              ),
            ),
          ],
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.white.withOpacity(0.2), Colors.white.withOpacity(0.1)], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(children: [Icon(Icons.payment, color: Colors.white, size: 20), SizedBox(width: 8), Text('المبلغ المطلوب', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold))]),
                Text('${_finalPrice.toStringAsFixed(0)} ريال', style: TextStyle(color: _localAttendees > 0 ? Colors.white : Colors.white38, fontSize: 22, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==================== تأكيد الحجز ====================

  Future<void> _checkout() async {
    if (_localAttendees == 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('الرجاء اختيار عدد الأفراد'), backgroundColor: Colors.orange));
      return;
    }
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final r = await Provider.of<PaymentMethodsProvider>(context, listen: false).checkout(
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        paymentMethodCode: widget.paymentMethod.code,
        couponCode: _isCouponValid ? _couponController.text : null,
        items: _buildItemsForCheckout(),
      );

      if (r != null && r['code'] == 200) {
        setState(() {
          _checkoutResult = r['data'];
          _orderCreated = true; // ✅ تم إنشاء الطلب
        });
        _showBankTransferInstructions();
      } else {
        String err = r?['message'] ?? 'فشل';
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err), backgroundColor: Colors.red));
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('خطأ: $e'), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _handleRedirectPayment(Map<String, dynamic> data) {
    if (data['redirect_url'] != null) {
      _launchURL(data['redirect_url']);
    } else if (data['payment_url'] != null) {
      _launchURL(data['payment_url']);
    } else {
      _showSuccessDialog();
    }
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  // ==================== رفع الإيصال ====================

  Future<void> _pickReceipt() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (image != null) {
      setState(() => _receiptFile = File(image.path));
    }
  }

  Future<void> _uploadReceipt() async {
    if (_receiptFile == null || _checkoutResult == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('الرجاء اختيار صورة الإيصال'), backgroundColor: Colors.orange));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final orderId = _checkoutResult!['order_id'] ?? _checkoutResult!['id'];
      final transactionToken = _checkoutResult!['transaction_token'];

      developer.log('[Checkout] Uploading receipt: orderId=$orderId, token=$transactionToken', name: 'Response-output');

      final result = await Provider.of<PaymentMethodsProvider>(context, listen: false).uploadReceipt(
        orderId: int.tryParse(orderId.toString()) ?? 0,
        transactionToken: transactionToken.toString(),
        receiptPath: _receiptFile!.path,
      );

      if (result != null && (result['code'] == 200 || result['code'] == 201)) {
        _showSuccessDialog();
      } else {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result?['message'] ?? 'فشل رفع الإيصال'), backgroundColor: Colors.red));
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('خطأ: $e'), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showBankTransferInstructions() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), shape: BoxShape.circle),
                    child: const Icon(Icons.check_circle, color: Colors.green, size: 32),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(child: Text('تم إنشاء الطلب بنجاح', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey.shade800 : Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('📋 تعليمات التحويل:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 12),
                    Text('1. قم بتحويل المبلغ إلى الحساب البنكي'),
                    Text('2. احفظ إيصال التحويل'),
                    Text('3. ارفع الإيصال من الأسفل'),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ✅ قسم رفع الإيصال
              Text('📎 رفع إيصال التحويل', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: _pickReceipt,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primary.withOpacity(0.5), width: 2, strokeAlign: BorderSide.strokeAlignInside),
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.primary.withOpacity(0.05),
                  ),
                  child: Column(
                    children: [
                      Icon(_receiptFile != null ? Icons.check_circle : Icons.cloud_upload_outlined, size: 40, color: AppColors.primary),
                      const SizedBox(height: 8),
                      Text(
                        _receiptFile != null ? 'تم اختيار الصورة ✅' : 'اضغط لاختيار صورة الإيصال',
                        style: TextStyle(color: AppColors.primary, fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      if (_receiptFile != null) ...[
                        const SizedBox(height: 8),
                        Text('${_receiptFile!.path.split('/').last}', style: TextStyle(color: Colors.grey, fontSize: 11)),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // ✅ زر رفع الإيصال
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _receiptFile != null ? _uploadReceipt : null,
                  icon: _isLoading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Icon(Icons.upload),
                  label: Text(_isLoading ? 'جاري الرفع...' : 'رفع الإيصال'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _receiptFile != null ? AppColors.primary : Colors.grey,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        );
      },
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تم بنجاح 🎉'),
        content: const Text('تم رفع الإيصال بنجاح. سيتم مراجعة طلبك قريباً'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }

  // ==================== الواجهة ====================

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final ss = Provider.of<SettingsService>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('إتمام الحجز', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: AppColors.primary, elevation: 0, centerTitle: true,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
          child: IconButton(icon: const Icon(Icons.arrow_back_ios, size: 18, color: Colors.white), onPressed: () => Navigator.pop(context)),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _orderCreated
          ? _buildReceiptUploadView(isDark)
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildOrderSummary(ss),
              const SizedBox(height: 24),

              // كود خصم
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: isDark ? Colors.grey.shade800 : Colors.white, borderRadius: BorderRadius.circular(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), shape: BoxShape.circle), child: const Icon(Icons.local_offer, color: Colors.orange, size: 20)),
                      const SizedBox(width: 12),
                      const Text('كود خصم / نقاط', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ]),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _couponController,
                      decoration: InputDecoration(hintText: 'أدخل كود الخصم', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: isDark ? Colors.grey.shade700 : Colors.grey.shade50, enabled: !_isCouponValid),
                    ),
                    const SizedBox(height: 8),
                    Row(children: [Checkbox(value: _usePoints, onChanged: _isCouponValid ? null : (v) => setState(() => _usePoints = v ?? false), activeColor: AppColors.primary), const Text('استخدام نقاطي')]),
                    const SizedBox(height: 8),
                    Row(children: [
                      if (_isCouponValid)
                        Container(decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: IconButton(onPressed: _removeCoupon, icon: const Icon(Icons.close, color: Colors.red)))
                      else
                        ElevatedButton(onPressed: _isCheckingCoupon ? null : _checkCoupon, style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: _isCheckingCoupon ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Text('تطبيق')),
                      if (_couponMessage != null) ...[const SizedBox(width: 12), Expanded(child: Row(children: [Icon(_isCouponValid ? Icons.check_circle : Icons.error, size: 16, color: _isCouponValid ? Colors.green : Colors.red), const SizedBox(width: 4), Expanded(child: Text(_couponMessage!, style: TextStyle(fontSize: 12, color: _isCouponValid ? Colors.green : Colors.red)))]))],
                    ]),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // طريقة الدفع
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: isDark ? Colors.grey.shade800 : Colors.white, borderRadius: BorderRadius.circular(16)),
                child: Row(children: [
                  Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: widget.paymentMethod.isBankTransfer ? Colors.blue.withOpacity(0.1) : Colors.green.withOpacity(0.1), shape: BoxShape.circle), child: Icon(widget.paymentMethod.isBankTransfer ? Icons.account_balance : Icons.payment, color: widget.paymentMethod.isBankTransfer ? Colors.blue : Colors.green, size: 22)),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('طريقة الدفع', style: TextStyle(fontSize: 11, color: Colors.grey)), Text(widget.paymentMethod.getTitle(ss.languageCode), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold))])),
                ]),
              ),
              const SizedBox(height: 24),

              // معلومات الاتصال
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: isDark ? Colors.grey.shade800 : Colors.white, borderRadius: BorderRadius.circular(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('معلومات الاتصال', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), const SizedBox(height: 16),
                    TextFormField(controller: _nameController, decoration: const InputDecoration(labelText: 'الاسم', border: OutlineInputBorder()), validator: (v) => v?.isEmpty == true ? 'مطلوب' : null), const SizedBox(height: 12),
                    TextFormField(controller: _emailController, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'البريد الإلكتروني', border: OutlineInputBorder()), validator: (v) => v?.isEmpty == true ? 'مطلوب' : null), const SizedBox(height: 12),
                    TextFormField(controller: _phoneController, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'رقم الهاتف', border: OutlineInputBorder()), validator: (v) => v?.isEmpty == true ? 'مطلوب' : null),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // زر تأكيد الحجز
              SizedBox(
                width: double.infinity, height: 50,
                child: ElevatedButton(
                  onPressed: _localAttendees > 0 ? _checkout : null,
                  style: ElevatedButton.styleFrom(backgroundColor: _localAttendees > 0 ? AppColors.primary : Colors.grey, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  child: const Text('تأكيد الحجز', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  /// ✅ شاشة رفع الإيصال بعد إنشاء الطلب
  Widget _buildReceiptUploadView(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ملخص الطلب
          _buildOrderSummary(Provider.of<SettingsService>(context)),
          const SizedBox(height: 24),

          // ✅ قسم رفع الإيصال
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey.shade800 : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.primary.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), shape: BoxShape.circle), child: const Icon(Icons.receipt_long, color: Colors.orange, size: 24)),
                    const SizedBox(width: 12),
                    const Expanded(child: Text('رفع إيصال التحويل', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                  ],
                ),
                const SizedBox(height: 8),
                Text('الرجاء تحويل المبلغ ورفع الإيصال هنا', style: TextStyle(color: isDark ? Colors.white70 : Colors.grey.shade600, fontSize: 14)),
                const SizedBox(height: 20),

                // ✅ حقل رفع الصورة
                GestureDetector(
                  onTap: _pickReceipt,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.primary.withOpacity(0.5), width: 2),
                      borderRadius: BorderRadius.circular(12),
                      color: AppColors.primary.withOpacity(0.05),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          _receiptFile != null ? Icons.check_circle : Icons.cloud_upload_outlined,
                          size: 50,
                          color: _receiptFile != null ? Colors.green : AppColors.primary,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _receiptFile != null ? 'تم اختيار الصورة ✅' : 'اضغط لاختيار صورة الإيصال',
                          style: TextStyle(color: AppColors.primary, fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        if (_receiptFile != null) ...[
                          const SizedBox(height: 8),
                          Text(_receiptFile!.path.split('/').last, style: TextStyle(color: Colors.grey, fontSize: 12)),
                          const SizedBox(height: 12),
                          TextButton.icon(
                            onPressed: _pickReceipt,
                            icon: const Icon(Icons.refresh, size: 16),
                            label: const Text('تغيير الصورة'),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // ✅ زر رفع الإيصال
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: _receiptFile != null ? _uploadReceipt : null,
                    icon: _isLoading
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Icon(Icons.cloud_upload),
                    label: Text(_isLoading ? 'جاري الرفع...' : 'رفع الإيصال'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _receiptFile != null ? AppColors.primary : Colors.grey,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}