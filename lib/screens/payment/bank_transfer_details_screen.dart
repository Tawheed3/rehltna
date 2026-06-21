import 'dart:developer' as developer;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../core/constants/app_colors.dart';
import '../../data/models/payment_method_model.dart';
import '../../data/models/item_model.dart';
import '../../data/providers/payment_methods_provider.dart';
import '../../data/providers/auth_provider.dart';
import '../../data/services/settings_service.dart';
import '../auth/login_screen.dart';

class BankTransferDetailsScreen extends StatefulWidget {
  final PaymentMethodModel method;
  final double amount;
  final ItemModel item;
  final int? attendees;
  final List<Map<String, dynamic>>? selectedPrices;

  // ✅ الكوبون والنقاط
  final String? couponCode;
  final bool usePoints;

  const BankTransferDetailsScreen({
    Key? key,
    required this.method,
    required this.amount,
    required this.item,
    this.attendees,
    this.selectedPrices,
    this.couponCode,
    this.usePoints = false,
  }) : super(key: key);

  @override
  State<BankTransferDetailsScreen> createState() => _BankTransferDetailsScreenState();
}

class _BankTransferDetailsScreenState extends State<BankTransferDetailsScreen> {
  bool _isLoading = false;
  File? _receiptFile;
  final ImagePicker _picker = ImagePicker();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  bool _isEditingInfo = false;

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.currentUser;

    _nameController = TextEditingController(text: user?.name ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _copy(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تم نسخ $label'), duration: const Duration(seconds: 1), backgroundColor: Colors.green),
    );
  }

  // ==================== رفع الإيصال ====================

  void _showLoginRequired() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(children: [
          Icon(Icons.lock_outline, color: AppColors.primary),
          SizedBox(width: 8),
          Text('تسجيل الدخول مطلوب'),
        ]),
        content: const Text(
          'يجب تسجيل الدخول لإتمام الحجز ورفع الإيصال.\nسيتم إعادتك لهذه الصفحة بعد تسجيل الدخول.',
          textAlign: TextAlign.right,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen(returnOnLogin: true)),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('تسجيل الدخول'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickReceipt() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (!authProvider.isLoggedIn) {
      _showLoginRequired();
      return;
    }
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (image != null) {
      setState(() => _receiptFile = File(image.path));
    }
  }

  Future<void> _createOrderAndUploadReceipt() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (!authProvider.isLoggedIn) {
      _showLoginRequired();
      return;
    }

    if (_receiptFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء اختيار صورة الإيصال'), backgroundColor: Colors.orange),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // ✅ checkout مع الكوبون والنقاط
      final checkoutResult = await Provider.of<PaymentMethodsProvider>(context, listen: false).checkout(
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        paymentMethodCode: widget.method.code,
        couponCode: widget.couponCode,
        usePoints: widget.usePoints, // ✅ إرسال use_points
        items: _buildItemsForCheckout(),
      );

      if (checkoutResult == null || checkoutResult['code'] != 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(checkoutResult?['message'] ?? 'فشل إنشاء الطلب'),
              backgroundColor: Colors.red,
            ),
          );
        }
        setState(() => _isLoading = false);
        return;
      }

      final orderData = checkoutResult['data'];
      final orderId = orderData['order_id'] ?? orderData['id'];
      final transactionToken = orderData['transaction_token'];

      developer.log('[BankTransfer] Order created: orderId=$orderId, token=$transactionToken', name: 'Response-output');

      final uploadResult = await Provider.of<PaymentMethodsProvider>(context, listen: false).uploadReceipt(
        orderId: int.tryParse(orderId.toString()) ?? 0,
        transactionToken: transactionToken.toString(),
        receiptPath: _receiptFile!.path,
      );

      if (uploadResult != null && (uploadResult['code'] == 200 || uploadResult['code'] == 201)) {
        if (mounted) _showSuccessDialog();
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(uploadResult?['message'] ?? 'فشل رفع الإيصال'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  List<Map<String, dynamic>> _buildItemsForCheckout() {
    return [
      {
        "item_id": widget.item.id,
        "attendees": widget.attendees ?? 1,
        "selected_prices": widget.selectedPrices ?? [],
      }
    ];
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('تم بنجاح 🎉'),
        content: const Text('تم إنشاء الطلب ورفع الإيصال بنجاح.\nسيتم مراجعة طلبك قريباً'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }

  // ==================== تفاصيل الحجز ====================

  Widget _buildBookingDetails(bool isDark) {
    final tc = isDark ? Colors.white : Colors.grey.shade900;
    final sc = isDark ? Colors.white70 : Colors.grey.shade700;

    if (widget.selectedPrices == null || widget.selectedPrices!.isEmpty) {
      return Column(children: [
        _row(Icons.people, 'عدد المسافرين', '${widget.attendees ?? 1} فرد', Colors.blue, tc),
        const SizedBox(height: 8),
        _row(Icons.nightlight_round, 'عدد الليالي', '${widget.item.totalNights} ليلة', Colors.green, tc),
      ]);
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Icon(Icons.hotel, size: 18, color: Colors.amber.shade700),
        const SizedBox(width: 8),
        Text('تفاصيل الغرف', style: TextStyle(color: tc, fontSize: 15, fontWeight: FontWeight.bold)),
      ]),
      const SizedBox(height: 12),
      ...widget.selectedPrices!.map((sp) {
        final pid = sp['price_id'] as int?;
        final att = sp['attendees'] as int? ?? 0;
        if (pid == null || att == 0) return const SizedBox.shrink();
        final rt = widget.item.getPriceById(pid);
        if (rt == null) return const SizedBox.shrink();
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isDark ? Colors.white10 : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(children: [
            Container(
              width: 28, height: 28,
              decoration: BoxDecoration(color: Colors.blue.withOpacity(0.15), borderRadius: BorderRadius.circular(6)),
              child: Center(child: Text('$att', style: TextStyle(color: Colors.blue.shade700, fontSize: 12, fontWeight: FontWeight.bold))),
            ),
            const SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(rt.getTitle('ar'), style: TextStyle(color: tc, fontSize: 13, fontWeight: FontWeight.w600)),
              const SizedBox(height: 2),
              Text('$att فرد × ${rt.effectivePrice.toStringAsFixed(0)} ريال', style: TextStyle(color: sc, fontSize: 11)),
            ])),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: Colors.green.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
              child: Text('${(rt.effectivePrice * att).toStringAsFixed(0)} ريال', style: TextStyle(color: Colors.green.shade700, fontSize: 13, fontWeight: FontWeight.bold)),
            ),
          ]),
        );
      }),
      const SizedBox(height: 8),
      Divider(color: isDark ? Colors.white24 : Colors.grey.shade300),
      const SizedBox(height: 12),
      _row(Icons.people, 'إجمالي المسافرين', '${widget.attendees ?? 1} فرد', Colors.blue, tc),
      const SizedBox(height: 6),
      _row(Icons.nightlight_round, 'عدد الليالي', '${widget.item.totalNights} ليلة', Colors.green, tc),
    ]);
  }

  Widget _row(IconData icon, String label, String value, Color color, Color tc) {
    return Row(children: [
      Icon(icon, size: 16, color: color),
      const SizedBox(width: 8),
      Text('$label: ', style: TextStyle(color: tc.withOpacity(0.7), fontSize: 13)),
      Text(value, style: TextStyle(color: tc, fontSize: 13, fontWeight: FontWeight.w600)),
    ]);
  }

  Widget _card(IconData icon, String label, String value, Color color, Color tc, Color sc, [bool copy = false]) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: TextStyle(fontSize: 12, color: sc)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: tc)),
        ])),
        if (copy) IconButton(icon: Icon(Icons.copy, color: color, size: 20), onPressed: () => _copy(value, label)),
      ]),
    );
  }

  // ==================== الواجهة ====================

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final ss = Provider.of<SettingsService>(context);
    final config = widget.method.bankTransferConfig;
    final tc = isDark ? Colors.white : Colors.grey.shade900;
    final sc = isDark ? Colors.white70 : Colors.grey.shade700;

    if (config == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('خطأ')),
        body: const Center(child: Text('بيانات التحويل غير متوفرة')),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('تفاصيل التحويل البنكي', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: AppColors.primary, elevation: 0, centerTitle: true,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 18, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          :
      SafeArea(
        child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: double.infinity,
              height: 160,
              decoration: BoxDecoration(
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: widget.method.banner,
                    width: double.infinity, height: 160, fit: BoxFit.cover,
                    placeholder: (c, url) => Container(height: 160, color: Colors.grey.shade200),
                    errorWidget: (ctx, url, e) => Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.primary, AppColors.secondary],
                          begin: Alignment.topLeft, end: Alignment.bottomRight,
                        ),
                      ),
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
                          child: const Icon(Icons.account_balance, color: Colors.white, size: 40),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter, end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black.withOpacity(0.6)],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16, left: 16, right: 16,
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(widget.method.getTitle(ss.languageCode),
                          style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                        child: const Text('تحويل بنكي', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
                      ),
                    ]),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey.shade800 : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('المبلغ المطلوب', style: TextStyle(color: sc, fontSize: 16)),
                Text('${widget.amount.toStringAsFixed(0)} ريال',
                    style: TextStyle(color: AppColors.primary, fontSize: 24, fontWeight: FontWeight.bold)),
              ]),
              const SizedBox(height: 16),
              Divider(color: isDark ? Colors.white24 : Colors.grey.shade300),
              const SizedBox(height: 16),
              _buildBookingDetails(isDark),
            ]),
          ),
          const SizedBox(height: 24),

          Text('تفاصيل الحساب البنكي', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: tc)),
          const SizedBox(height: 16),
          _card(Icons.account_balance, 'اسم البنك', config.bankName, Colors.blue, tc, sc),
          const SizedBox(height: 12),
          _card(Icons.person, 'اسم الحساب', config.accountName, Colors.green, tc, sc),
          const SizedBox(height: 12),
          _card(Icons.numbers, 'رقم الحساب', config.accountNumber, Colors.purple, tc, sc, true),
          const SizedBox(height: 12),
          _card(Icons.qr_code, 'IBAN', config.iban, Colors.orange, tc, sc, true),
          const SizedBox(height: 12),
          _card(Icons.location_on, 'عنوان البنك', config.bankAddress, Colors.teal, tc, sc),
          const SizedBox(height: 24),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.blue.withOpacity(0.3)),
            ),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Icon(Icons.info_outline, color: Colors.blue, size: 24),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('تعليمات مهمة', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue)),
                const SizedBox(height: 8),
                Text(config.instructions, style: TextStyle(fontSize: 14, color: tc, height: 1.5)),
              ])),
            ]),
          ),
          const SizedBox(height: 24),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('معلومات الرحلة', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: tc)),
              const SizedBox(height: 12),
              Row(children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: widget.item.getBanner(ss.languageCode),
                    width: 50, height: 50, fit: BoxFit.cover,
                    placeholder: (c, url) => Container(width: 50, height: 50, color: Colors.grey.shade300),
                    errorWidget: (ctx, url, e) => Container(
                      width: 50, height: 50, color: Colors.grey.shade300,
                      child: const Icon(Icons.image, size: 30),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(widget.item.getTitle(ss.languageCode),
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: tc),
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text('${widget.item.totalNights} ليالي', style: TextStyle(fontSize: 12, color: sc)),
                ])),
              ]),
            ]),
          ),
          const SizedBox(height: 24),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey.shade800 : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.withOpacity(0.3)),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                const Icon(Icons.person, size: 18, color: AppColors.primary),
                const SizedBox(width: 8),
                const Text('معلومات الحجز', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    setState(() => _isEditingInfo = !_isEditingInfo);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: _isEditingInfo ? Colors.green.withOpacity(0.1) : AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(
                        _isEditingInfo ? Icons.check : Icons.edit,
                        size: 14,
                        color: _isEditingInfo ? Colors.green : AppColors.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _isEditingInfo ? 'تم' : 'تعديل',
                        style: TextStyle(
                          fontSize: 12,
                          color: _isEditingInfo ? Colors.green : AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ]),
                  ),
                ),
              ]),
              const SizedBox(height: 16),

              if (_isEditingInfo) ...[
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'الاسم',
                    prefixIcon: const Icon(Icons.person_outline),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    filled: true,
                    fillColor: isDark ? Colors.grey.shade700 : Colors.grey.shade50,
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'البريد الإلكتروني',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    filled: true,
                    fillColor: isDark ? Colors.grey.shade700 : Colors.grey.shade50,
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'رقم الهاتف',
                    prefixIcon: const Icon(Icons.phone),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    filled: true,
                    fillColor: isDark ? Colors.grey.shade700 : Colors.grey.shade50,
                  ),
                ),
              ] else ...[
                _row(Icons.person_outline, 'الاسم', _nameController.text, AppColors.primary, tc),
                const SizedBox(height: 10),
                _row(Icons.email_outlined, 'البريد', _emailController.text, AppColors.primary, tc),
                const SizedBox(height: 10),
                _row(Icons.phone, 'الهاتف', _phoneController.text.isNotEmpty ? _phoneController.text : 'غير محدد', AppColors.primary, tc),
              ],
            ]),
          ),
          const SizedBox(height: 24),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey.shade800 : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.primary.withOpacity(0.3)),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), shape: BoxShape.circle),
                  child: const Icon(Icons.receipt_long, color: Colors.orange, size: 24),
                ),
                const SizedBox(width: 12),
                const Expanded(child: Text('رفع إيصال التحويل', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
              ]),
              const SizedBox(height: 8),
              Text('الرجاء تحويل المبلغ ورفع الإيصال هنا',
                  style: TextStyle(color: isDark ? Colors.white70 : Colors.grey.shade600, fontSize: 14)),
              const SizedBox(height: 20),

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
                  child: Column(children: [
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
                  ]),
                ),
              ),
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity, height: 56,
                child: ElevatedButton.icon(
                  onPressed: _receiptFile != null ? _createOrderAndUploadReceipt : null,
                  icon: _isLoading
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Icon(Icons.lock),
                  label: Text(_isLoading ? 'جاري التأكيد...' : 'تأكيد الحجز ورفع الإيصال',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _receiptFile != null ? AppColors.primary : Colors.grey,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 4,
                  ),
                ),
              ),
            ]),
          ),
          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity, height: 56,
            child: OutlinedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close),
              label: const Text('إلغاء', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ),
        ]),
      ),
      )
    );
  }
}