import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/item_model.dart';
import '../../data/models/payment_method_model.dart';
import '../../data/providers/payment_methods_provider.dart';
import '../../data/providers/auth_provider.dart';
import '../../data/providers/settings_provider.dart';
import '../../data/services/settings_service.dart';
import 'checkout_screen.dart';
import 'bank_transfer_details_screen.dart';

// ==================== PaymentOptionsScreen ====================

class PaymentOptionsScreen extends StatefulWidget {
  final ItemModel item;
  final double price;
  final int? attendees;
  final List<Map<String, dynamic>>? selectedPrices;

  const PaymentOptionsScreen({
    Key? key,
    required this.item,
    required this.price,
    this.attendees,
    this.selectedPrices,
  }) : super(key: key);

  @override
  State<PaymentOptionsScreen> createState() => _PaymentOptionsScreenState();
}

class _PaymentOptionsScreenState extends State<PaymentOptionsScreen> {

  // ==================== المتغيرات ====================

  final _couponController = TextEditingController();

  bool _isCheckingCoupon = false;
  bool _isCheckingPoints = false;
  String? _couponMessage;
  String? _pointsMessage;
  bool _isCouponValid = false;
  bool _isPointsApplied = false;
  double _discountAmount = 0;
  double _pointsDiscount = 0;
  double _couponDiscount = 0;
  double _discountPercentage = 0;
  double _finalPrice = 0;
  bool _usePoints = false;

  late List<Map<String, dynamic>> _localSelectedPrices;
  late int _localAttendees;
  PaymentMethodModel? _selectedMethod;
  bool _isPaymentExpanded = false;

  // ==================== دورة الحياة ====================

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
        {"price_id": widget.item.prices.first.id, "attendees": widget.attendees ?? 1}
      ];
      _localAttendees = widget.attendees ?? 1;
    } else {
      _localSelectedPrices = [
        {"price_id": 0, "attendees": widget.attendees ?? 1}
      ];
      _localAttendees = widget.attendees ?? 1;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final pp = Provider.of<PaymentMethodsProvider>(context, listen: false);
      if (pp.paymentMethods.isEmpty) pp.fetchPaymentMethods();
    });
  }

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  // ==================== دوال حسابية ====================

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
        if (rt != null) {
          t += rt.effectivePrice * att;
        } else if (pid == 0) {
          t += widget.item.priceAfterDiscount * att;
        }
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
        _pointsDiscount = 0;
        _couponDiscount = 0;
        return;
      }

      final newPrice = _calculateLocalPrice();
      _updateFinalPrice(newPrice);
    });
  }

  void _updateFinalPrice(double newPrice) {
    double totalDiscount = 0;

    if (_isPointsApplied) {
      totalDiscount += _pointsDiscount;
    }

    if (_isCouponValid && _discountPercentage > 0) {
      _couponDiscount = newPrice * _discountPercentage;
      totalDiscount += _couponDiscount;
    }

    _discountAmount = totalDiscount;
    _finalPrice = newPrice - totalDiscount;
    if (_finalPrice < 0) _finalPrice = 0;
  }

  // ==================== واتساب ====================

  Future<void> _launchWhatsApp(String phone, {String? message}) async {
    final p = phone.replaceAll(RegExp(r'[^\d]'), '');
    String url = 'https://wa.me/$p';

    if (message != null && message.isNotEmpty) {
      url = 'https://wa.me/$p?text=${Uri.encodeComponent(message)}';
    }

    final Uri u = Uri.parse(url);
    if (await canLaunchUrl(u)) {
      await launchUrl(u, mode: LaunchMode.externalApplication);
    }
  }

  // ==================== رسائل واتساب ====================

  String _getTamaraMessage(SettingsService ss) {
    final tripTitle = widget.item.getTitle(ss.languageCode);
    final season = widget.item.season.isNotEmpty ? ' - ${widget.item.season}' : '';
    return 'أريد تقسيط رحلة $tripTitle$season مع تمارا';
  }

  String _getCompanyInstallmentMessage(SettingsService ss) {
    final tripTitle = widget.item.getTitle(ss.languageCode);
    final season = widget.item.season.isNotEmpty ? ' - ${widget.item.season}' : '';
    return 'أريد تقسيط رحلة $tripTitle$season مع الشركة';
  }

  // ==================== النقاط ====================

  Future<void> _togglePoints(bool value) async {
    if (value && _localAttendees == 0) {
      setState(() => _pointsMessage = '❌ الرجاء اختيار عدد الأفراد أولاً');
      return;
    }

    if (value) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userPoints = authProvider.currentUser?.availablePoints ?? 0;
      if (userPoints <= 0) {
        setState(() {
          _pointsMessage = '❌ ليس لديك نقاط كافية';
          _usePoints = false;
        });
        return;
      }
    }

    setState(() {
      _usePoints = value;
      _isCheckingPoints = true;
      _pointsMessage = null;
    });

    if (!value) {
      setState(() {
        _isPointsApplied = false;
        _pointsDiscount = 0;
        _isCheckingPoints = false;
      });
      _updateFinalPrice(_calculateLocalPrice());
      return;
    }

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      final items = [
        {
          "item_id": widget.item.id,
          "attendees": _localAttendees,
          "selected_prices": _localSelectedPrices
        }
      ];

      final result = await Provider.of<PaymentMethodsProvider>(context, listen: false).checkCoupon(
        email: authProvider.currentUser?.email ?? '',
        items: items,
        couponCode: "",
        usePoints: true,
      );

      if (result != null && result['code'] == 200) {
        final data = result['data'];
        double d = 0;

        if (data['total_discount'] != null) {
          d = (data['total_discount'] as num).toDouble();
          if (_isCouponValid) {
            d = d - (_couponDiscount);
          }
        }

        setState(() {
          _isPointsApplied = true;
          _pointsDiscount = d;
          _pointsMessage = d > 0
              ? '✅ تم خصم ${d.toStringAsFixed(0)} ريال'
              : '✅ تم تطبيق النقاط';
        });

        _updateFinalPrice(_calculateLocalPrice());
      } else {
        setState(() {
          _usePoints = false;
          _isPointsApplied = false;
          _pointsDiscount = 0;
          _pointsMessage = '❌ ${result?['message'] ?? 'لا يمكن استخدام النقاط'}';
        });
      }
    } catch (e) {
      setState(() {
        _usePoints = false;
        _isPointsApplied = false;
        _pointsDiscount = 0;
        _pointsMessage = '❌ حدث خطأ';
      });
    } finally {
      setState(() => _isCheckingPoints = false);
    }
  }

  // ==================== كوبون ====================

  Future<void> _checkCoupon() async {
    if (_localAttendees == 0) {
      setState(() => _couponMessage = '❌ الرجاء اختيار عدد الأفراد أولاً');
      return;
    }
    if (_couponController.text.isEmpty) {
      setState(() => _couponMessage = '❌ الرجاء إدخال كود الخصم');
      return;
    }

    setState(() {
      _isCheckingCoupon = true;
      _couponMessage = null;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      final items = [
        {
          "item_id": widget.item.id,
          "attendees": _localAttendees,
          "selected_prices": _localSelectedPrices
        }
      ];

      final result = await Provider.of<PaymentMethodsProvider>(context, listen: false).checkCoupon(
        email: authProvider.currentUser?.email ?? '',
        items: items,
        couponCode: _couponController.text,
        usePoints: _isPointsApplied,
      );

      if (result != null && result['code'] == 200) {
        final data = result['data'];
        double d = 0;
        double subTotal = 0;

        if (data['total_discount'] != null) d = (data['total_discount'] as num).toDouble();
        if (data['sub_total'] != null) subTotal = (data['sub_total'] as num).toDouble();

        final currentPrice = _calculateLocalPrice();
        double couponOnlyDiscount = d - _pointsDiscount;

        if (couponOnlyDiscount > 0 && subTotal > 0) {
          _discountPercentage = couponOnlyDiscount / subTotal;
          _couponDiscount = currentPrice * _discountPercentage;
        } else {
          _discountPercentage = 0;
          _couponDiscount = 0;
        }

        setState(() {
          _isCouponValid = true;
          if (_couponDiscount > 0) {
            _couponMessage = '✅ خصم ${_couponDiscount.toStringAsFixed(0)} ريال';
          } else {
            _couponMessage = '✅ تم تطبيق الكوبون';
          }
        });

        _updateFinalPrice(currentPrice);
      } else {
        setState(() {
          _isCouponValid = false;
          _couponMessage = '❌ ${result?['message'] ?? 'كود غير صالح'}';
          _couponDiscount = 0;
          _discountPercentage = 0;
        });
        _updateFinalPrice(_calculateLocalPrice());
      }
    } catch (e) {
      setState(() {
        _isCouponValid = false;
        _couponMessage = '❌ حدث خطأ';
        _discountPercentage = 0;
        _couponDiscount = 0;
      });
      _updateFinalPrice(_calculateLocalPrice());
    } finally {
      setState(() => _isCheckingCoupon = false);
    }
  }

  void _removeCoupon() {
    setState(() {
      _couponController.clear();
      _isCouponValid = false;
      _couponMessage = null;
      _couponDiscount = 0;
      _discountPercentage = 0;
    });
    _updateFinalPrice(_calculateLocalPrice());
  }

  // ==================== متابعة للدفع ====================

  void _continueToPayment() {
    if (_localAttendees == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء اختيار عدد الأفراد'), backgroundColor: Colors.orange),
      );
      return;
    }
    if (_selectedMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء اختيار طريقة الدفع'), backgroundColor: Colors.orange),
      );
      return;
    }

    if (_selectedMethod!.isBankTransfer) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (ctx) => BankTransferDetailsScreen(
            method: _selectedMethod!,
            amount: _finalPrice,
            item: widget.item,
            attendees: _localAttendees,
            selectedPrices: _localSelectedPrices,
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (ctx) => CheckoutScreen(
            item: widget.item,
            paymentMethod: _selectedMethod!,
            price: _finalPrice,
            attendees: _localAttendees,
            selectedPrices: _localSelectedPrices,
          ),
        ),
      );
    }
  }

  // ==================== الواجهة ====================

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final ss = Provider.of<SettingsService>(context);
    final pp = Provider.of<PaymentMethodsProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final settingsProvider = Provider.of<SettingsProvider>(context);

    final userPoints = authProvider.currentUser?.availablePoints ?? 0;
    final employeeWhatsApp = settingsProvider.settings?.whatsappNumber ?? '';

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('إتمام الحجز', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
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
      body: pp.isLoading && pp.paymentMethods.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ملخص الطلب
            _buildOrderSummary(ss, isDark, userPoints),
            const SizedBox(height: 24),

            // إتمام الحجز (Dropdown)
            _buildPaymentDropdown(pp, ss, isDark, employeeWhatsApp, settingsProvider),
            const SizedBox(height: 24),

            // زر تأكيد الطلب
            SizedBox(
              width: double.infinity, height: 55,
              child: ElevatedButton(
                onPressed: _localAttendees > 0 ? _continueToPayment : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _localAttendees > 0 ? AppColors.primary : Colors.grey,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 3,
                ),
                child: Text(
                  _localAttendees > 0
                      ? 'تأكيد الطلب (${_finalPrice.toStringAsFixed(0)} ريال)'
                      : 'الرجاء اختيار عدد الأفراد',
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // ==================== ملخص الطلب ====================

  Widget _buildOrderSummary(SettingsService ss, bool isDark, double userPoints) {
    final currentPrice = _localAttendees > 0 ? _calculateLocalPrice() : 0;

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
          // عنوان الملخص
          const Row(children: [
            Icon(Icons.receipt_long, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text('ملخص الطلب', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          ]),
          const SizedBox(height: 12),

          // اسم الرحلة
          Row(children: [
            const Icon(Icons.flight_takeoff, color: Colors.white70, size: 16),
            const SizedBox(width: 6),
            Expanded(child: Text(widget.item.getTitle(ss.languageCode), style: const TextStyle(color: Colors.white, fontSize: 14))),
          ]),
          const SizedBox(height: 4),

          // عدد الليالي
          Row(children: [
            const Icon(Icons.nightlight_round, color: Colors.green, size: 14),
            const SizedBox(width: 6),
            Text('${widget.item.totalNights} ليالي', style: const TextStyle(color: Colors.white70, fontSize: 12)),
          ]),
          const SizedBox(height: 12),
          const Divider(color: Colors.white24),
          const SizedBox(height: 12),

          // تفاصيل الغرف
          if (_localSelectedPrices.isNotEmpty) ...[
            const Row(children: [
              Icon(Icons.hotel, color: Colors.amber, size: 16),
              SizedBox(width: 6),
              Text('تفاصيل الحجز', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
            ]),
            const SizedBox(height: 8),
            ..._localSelectedPrices.where((sp) => (sp['attendees'] as int? ?? 0) > 0).map((sp) {
              final pid = sp['price_id'] as int?;
              final att = sp['attendees'] as int? ?? 0;
              if (pid == null || att == 0) return const SizedBox.shrink();
              final rt = widget.item.getPriceById(pid);
              if (rt == null && pid != 0) return const SizedBox.shrink();

              final effectivePrice = rt?.effectivePrice ?? widget.item.priceAfterDiscount;
              final title = rt?.getTitle('ar') ?? 'سعر اساسي';
              final st = effectivePrice * att;

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Container(
                        width: 24, height: 24,
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(6)),
                        child: Center(child: Text('$att', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold))),
                      ),
                      const SizedBox(width: 8),
                      Expanded(child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600))),
                      GestureDetector(
                        onTap: () => _updateLocalAttendees(pid, -1),
                        child: Container(
                          width: 28, height: 28,
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
                          child: const Icon(Icons.remove, color: Colors.white, size: 16),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text('$att', style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: () => _updateLocalAttendees(pid, 1),
                        child: Container(
                          width: 28, height: 28,
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
                          child: const Icon(Icons.add, color: Colors.white, size: 16),
                        ),
                      ),
                    ]),
                    const SizedBox(height: 6),
                    Row(children: [
                      const SizedBox(width: 32),
                      Text('$att فرد × ${effectivePrice.toStringAsFixed(0)} ريال', style: const TextStyle(color: Colors.white54, fontSize: 11)),
                      const Spacer(),
                      Text('${st.toStringAsFixed(0)} ريال', style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                    ]),
                  ],
                ),
              );
            }),
            const SizedBox(height: 8),
            const Divider(color: Colors.white24),
            const SizedBox(height: 8),
          ],

          // إجمالي المسافرين
          Row(children: [
            const Icon(Icons.people, color: Colors.white70, size: 14),
            const SizedBox(width: 6),
            Text('إجمالي المسافرين: $_localAttendees فرد', style: const TextStyle(color: Colors.white70, fontSize: 12)),
          ]),
          const SizedBox(height: 12),

          // المجموع الفرعي
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Padding(padding: EdgeInsets.only(left: 12), child: Text('المجموع الفرعي', style: TextStyle(color: Colors.white70, fontSize: 14))),
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Text(
                  '${currentPrice.toStringAsFixed(0)} ريال',
                  style: TextStyle(color: _localAttendees > 0 ? Colors.white : Colors.white38, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ]),
          ),

          // قسم الخصم (نقاط + كوبون)
          Container(
            margin: const EdgeInsets.only(top: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // النقاط
                  Row(children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            Icon(Icons.card_giftcard, color: Colors.amber.shade300, size: 18),
                            const SizedBox(width: 8),
                            const Text('استخدام نقاطي', style: TextStyle(color: Colors.white70, fontSize: 13)),
                            if (_isCheckingPoints) ...[
                              const SizedBox(width: 8),
                              const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)),
                            ],
                          ]),
                          const SizedBox(height: 2),
                          Text(
                            'الربح: ${userPoints.toStringAsFixed(2)} نقطة',
                            style: TextStyle(color: Colors.amber.shade200, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _usePoints,
                      onChanged: _isCheckingPoints ? null : (v) => _togglePoints(v),
                      activeColor: Colors.amber,
                      activeTrackColor: Colors.amber.withOpacity(0.3),
                    ),
                  ]),

                  if (_pointsMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 26, top: 2),
                      child: Text(
                        _pointsMessage!,
                        style: TextStyle(
                          fontSize: 11,
                          color: _isPointsApplied ? Colors.amber.shade300 : Colors.red.shade300,
                        ),
                      ),
                    ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Divider(color: Colors.white.withOpacity(0.2)),
                  ),

                  // الكوبون
                  Row(children: [
                    Expanded(
                      child: TextFormField(
                        controller: _couponController,
                        enabled: !_isCouponValid,
                        style: const TextStyle(color: Colors.white, fontSize: 13),
                        decoration: InputDecoration(
                          hintText: 'أدخل كود الخصم',
                          hintStyle: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          isDense: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.1),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (_isCouponValid)
                      GestureDetector(
                        onTap: _removeCoupon,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.close, color: Colors.white, size: 18),
                        ),
                      )
                    else
                      GestureDetector(
                        onTap: _isCheckingCoupon ? null : _checkCoupon,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: _isCheckingCoupon
                              ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                              : const Text('تطبيق', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                        ),
                      ),
                  ]),

                  if (_couponMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        _couponMessage!,
                        style: TextStyle(
                          fontSize: 11,
                          color: _isCouponValid ? Colors.green.shade300 : Colors.red.shade300,
                        ),
                      ),
                    ),
                ]),
          ),

          // خصم النقاط
          if (_isPointsApplied && _pointsDiscount > 0) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber.withOpacity(0.3)),
              ),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Padding(padding: EdgeInsets.only(left: 12), child: Row(children: [
                  Icon(Icons.card_giftcard, color: Colors.amber, size: 16),
                  SizedBox(width: 6),
                  Text('خصم النقاط', style: TextStyle(color: Colors.amber, fontSize: 14)),
                ])),
                Padding(padding: const EdgeInsets.only(right: 12), child: Text(
                  '-${_pointsDiscount.toStringAsFixed(0)} ريال',
                  style: const TextStyle(color: Colors.amber, fontSize: 16, fontWeight: FontWeight.bold),
                )),
              ]),
            ),
          ],

          // خصم الكوبون
          if (_isCouponValid && _couponDiscount > 0) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.withOpacity(0.3)),
              ),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Padding(padding: EdgeInsets.only(left: 12), child: Row(children: [
                  Icon(Icons.discount, color: Colors.green, size: 16),
                  SizedBox(width: 6),
                  Text('خصم الكوبون', style: TextStyle(color: Colors.green, fontSize: 14)),
                ])),
                Padding(padding: const EdgeInsets.only(right: 12), child: Text(
                  '-${_couponDiscount.toStringAsFixed(0)} ريال',
                  style: const TextStyle(color: Colors.green, fontSize: 16, fontWeight: FontWeight.bold),
                )),
              ]),
            ),
          ],

          // الإجمالي
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white.withOpacity(0.2), Colors.white.withOpacity(0.1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Row(children: [
                Icon(Icons.payment, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text('الإجمالي', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
              ]),
              Text(
                '${_finalPrice.toStringAsFixed(0)} ريال',
                style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  // ==================== إتمام الحجز (Dropdown) ====================

  Widget _buildPaymentDropdown(
      PaymentMethodsProvider pp,
      SettingsService ss,
      bool isDark,
      String employeeWhatsApp,
      SettingsProvider settingsProvider,
      ) {
    final allMethods = pp.paymentMethods;

    if (allMethods.isEmpty) {
      return const SizedBox.shrink();
    }

    // شعار الشركة
    final companyLogo = settingsProvider.settings?.getLogo(isDark) ?? '';

    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade900 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // هيدر إتمام الحجز
          GestureDetector(
            onTap: () {
              setState(() {
                _isPaymentExpanded = !_isPaymentExpanded;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey.shade800 : Colors.grey.shade50,
                borderRadius: _isPaymentExpanded
                    ? const BorderRadius.vertical(top: Radius.circular(16))
                    : BorderRadius.circular(16),
              ),
              child: Row(children: [
                Container(
                  width: 45, height: 45,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.payment, color: AppColors.primary, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selectedMethod != null
                            ? _selectedMethod!.getTitle(ss.languageCode)
                            : 'اختر طريقة الدفع',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      if (_selectedMethod != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          _selectedMethod!.isBankTransfer ? 'تحويل بنكي' : 'دفع إلكتروني',
                          style: TextStyle(
                            fontSize: 12,
                            color: _selectedMethod!.isBankTransfer ? Colors.blue : Colors.green,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (_selectedMethod != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      _selectedMethod!.banner,
                      width: 70, height: 50, fit: BoxFit.cover,
                      errorBuilder: (ctx, e, s) => Icon(
                        _selectedMethod!.isBankTransfer ? Icons.account_balance : Icons.payment,
                        color: AppColors.primary, size: 30,
                      ),
                    ),
                  ),
                const SizedBox(width: 10),
                AnimatedRotation(
                  turns: _isPaymentExpanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: isDark ? Colors.white54 : Colors.grey[600],
                    size: 28,
                  ),
                ),
              ]),
            ),
          ),

          // قائمة طرق الدفع
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: _isPaymentExpanded
                ? Column(
              children: [
                ...allMethods.map((method) {
                  final isSelected = _selectedMethod?.id == method.id;
                  final cardColor = method.isBankTransfer ? Colors.blue : Colors.green;

                  return GestureDetector(
                    onTap: () {
                      // تمارا → فتح واتساب
                      if (method.isTamara && employeeWhatsApp.isNotEmpty) {
                        _launchWhatsApp(employeeWhatsApp, message: _getTamaraMessage(ss));
                        return;
                      }

                      // طرق الدفع العادية
                      setState(() {
                        _selectedMethod = method;
                        _isPaymentExpanded = false;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? cardColor.withOpacity(0.1) : Colors.transparent,
                        border: Border(
                          bottom: BorderSide(
                            color: isDark ? Colors.grey.shade700 : Colors.grey.shade200,
                            width: 0.5,
                          ),
                        ),
                      ),
                      child: Row(children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            method.banner,
                            width: 140, height: 100, fit: BoxFit.cover,
                            errorBuilder: (ctx, e, s) => Container(
                              width: 120, height: 100,
                              decoration: BoxDecoration(
                                color: cardColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                method.isBankTransfer ? Icons.account_balance : Icons.payment,
                                color: cardColor, size: 24,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            method.getTitle(ss.languageCode),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                        if (isSelected)
                          Icon(Icons.check_circle, color: cardColor, size: 24),
                      ]),
                    ),
                  );
                }),

                // تقسيط مع الشركة
                if (employeeWhatsApp.isNotEmpty) ...[
                  const Divider(height: 1),
                  GestureDetector(
                    onTap: () => _launchWhatsApp(employeeWhatsApp, message: _getCompanyInstallmentMessage(ss)),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.05),
                        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
                      ),
                      child: Row(children: [
                        // شعار الشركة
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: companyLogo.isNotEmpty
                              ? Image.network(
                            companyLogo,
                            width: 140,
                            height: 100,
                            fit: BoxFit.contain,
                            errorBuilder: (ctx, e, s) => Container(
                              width: 140,
                              height: 100,
                              decoration: BoxDecoration(
                                color: const Color(0xFF25D366).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.business, color: Color(0xFF25D366), size: 26),
                            ),
                          )
                              : Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: const Color(0xFF25D366).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.business, color: Color(0xFF25D366), size: 26),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('تقسيط مع الشركة', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                      ]),
                    ),
                  ),
                ],
              ],
            )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}