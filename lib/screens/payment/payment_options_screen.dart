import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/item_model.dart';
import '../../data/models/payment_method_model.dart';
import '../../data/providers/payment_methods_provider.dart';
import '../../data/providers/auth_provider.dart';
import '../../data/providers/settings_provider.dart';
import '../../data/services/settings_service.dart';
import 'bank_transfer_details_screen.dart';
import '../../data/providers/user_provider.dart';

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

  // ==================== Controllers ====================

  final _couponController = TextEditingController();

  // ==================== حالة الكوبون والنقاط ====================

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

  // ==================== حالة الحجز ====================

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
        widget.selectedPrices!.map((e) => Map<String, dynamic>.from(e)),
      );
      _localAttendees = _getTotalFromLocal();
    } else if (widget.item.prices.isNotEmpty) {
      _localSelectedPrices = [
        {
          "price_id": widget.item.prices.first.id,
          "attendees": widget.attendees ?? 1,
        }
      ];
      _localAttendees = widget.attendees ?? 1;
    } else {
      _localSelectedPrices = [
        {
          "price_id": 0,
          "attendees": widget.attendees ?? 1,
        }
      ];
      _localAttendees = widget.attendees ?? 1;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // ✅ تحديث البروفايل عشان نجيب أحدث نقاط
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.fetchProfile();

      // ✅ جلب طرق الدفع
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
    if (_isPointsApplied) totalDiscount += _pointsDiscount;
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

  // ==============================================================
  // ⭐ النقاط - تشتغل لوحدها أو مع الكوبون
  // ==============================================================

  Future<void> _togglePoints(bool value) async {
    if (value && _localAttendees == 0) {
      setState(() => _pointsMessage = '❌ الرجاء اختيار عدد الأفراد أولاً');
      return;
    }

    if (value) {
      // ✅ اقرأ النقاط من UserProvider
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final auth = Provider.of<AuthProvider>(context, listen: false); // ✅ عرف authProvider محلياً
      final user = userProvider.user ?? auth.currentUser;
      final userPoints = user?.availablePoints ?? 0;

      if (userPoints <= 0) {
        setState(() {
          _pointsMessage = '❌ ليس لديك نقاط';
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

    // ✅ إلغاء النقاط
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
          "selected_prices": _localSelectedPrices,
        }
      ];

      // ============================================================
      // Step 1: نجيب خصم النقاط لوحدها (من غير كوبون)
      // ============================================================
      final pointsOnlyResult = await Provider.of<PaymentMethodsProvider>(
        context,
        listen: false,
      ).checkCoupon(
        email: authProvider.currentUser?.email ?? '',
        items: items,
        couponCode: "",       // بدون كوبون
        usePoints: true,      // النقاط مفعلة
      );

      double pointsOnlyDiscount = 0;

      if (pointsOnlyResult != null && pointsOnlyResult['code'] == 200) {
        final data = pointsOnlyResult['data'];
        if (data['total_discount'] != null) {
          pointsOnlyDiscount = (data['total_discount'] as num).toDouble();
        }
      }

      // ============================================================
      // Step 2: لو الكوبون مفعل، نجيب الخصم الكلي (نقاط + كوبون)
      // ============================================================
      if (_isCouponValid) {
        final combinedResult = await Provider.of<PaymentMethodsProvider>(
          context,
          listen: false,
        ).checkCoupon(
          email: authProvider.currentUser?.email ?? '',
          items: items,
          couponCode: _couponController.text.trim(),
          usePoints: true,
        );

        if (combinedResult != null && combinedResult['code'] == 200) {
          final data = combinedResult['data'];
          double combinedDiscount = 0;
          double subTotal = 0;

          if (data['total_discount'] != null) {
            combinedDiscount = (data['total_discount'] as num).toDouble();
          }
          if (data['sub_total'] != null) {
            subTotal = (data['sub_total'] as num).toDouble();
          }

          // خصم الكوبون = الخصم الكلي - خصم النقاط
          double couponOnlyDiscount = combinedDiscount - pointsOnlyDiscount;
          if (couponOnlyDiscount < 0) couponOnlyDiscount = 0;

          final currentPrice = _calculateLocalPrice();

          // تحديث نسبة الكوبون
          if (couponOnlyDiscount > 0 && subTotal > 0) {
            _discountPercentage = couponOnlyDiscount / subTotal;
            _couponDiscount = currentPrice * _discountPercentage;
          }

          // السعر النهائي
          _finalPrice = currentPrice - pointsOnlyDiscount - _couponDiscount;
          if (_finalPrice < 0) _finalPrice = 0;

          setState(() {
            _isPointsApplied = true;
            _pointsDiscount = pointsOnlyDiscount;
            _pointsMessage = pointsOnlyDiscount > 0
                ? '✅ تم خصم ${pointsOnlyDiscount.toStringAsFixed(0)} ريال'
                : '✅ تم تطبيق النقاط';
            _isCheckingPoints = false;
          });
        }
      } else {
        // ✅ لو مفيش كوبون، خصم النقاط بس
        _finalPrice = _calculateLocalPrice() - pointsOnlyDiscount;
        if (_finalPrice < 0) _finalPrice = 0;

        setState(() {
          _isPointsApplied = true;
          _pointsDiscount = pointsOnlyDiscount;
          _pointsMessage = pointsOnlyDiscount > 0
              ? '✅ تم خصم ${pointsOnlyDiscount.toStringAsFixed(0)} ريال'
              : '✅ تم تطبيق النقاط';
          _isCheckingPoints = false;
        });
      }
    } catch (e) {
      setState(() {
        _usePoints = false;
        _isPointsApplied = false;
        _pointsDiscount = 0;
        _pointsMessage = '❌ حدث خطأ';
        _isCheckingPoints = false;
      });
    }
  }

  // ==============================================================
  // ⭐ الكوبون - يشتغل لوحده أو مع النقاط
  // ==============================================================

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
          "selected_prices": _localSelectedPrices,
        }
      ];

      final result = await Provider.of<PaymentMethodsProvider>(
        context,
        listen: false,
      ).checkCoupon(
        email: authProvider.currentUser?.email ?? '',
        items: items,
        couponCode: _couponController.text.trim(),
        usePoints: _isPointsApplied,  // ✅ حالة النقاط الحالية
      );

      if (result != null && result['code'] == 200) {
        final data = result['data'];
        double totalDiscount = 0;
        double subTotal = 0;

        if (data['total_discount'] != null) {
          totalDiscount = (data['total_discount'] as num).toDouble();
        }
        if (data['sub_total'] != null) {
          subTotal = (data['sub_total'] as num).toDouble();
        }

        final currentPrice = _calculateLocalPrice();

        // خصم الكوبون = الخصم الكلي - خصم النقاط
        double couponOnlyDiscount = totalDiscount - _pointsDiscount;
        if (couponOnlyDiscount < 0) couponOnlyDiscount = 0;

        if (couponOnlyDiscount > 0 && subTotal > 0) {
          _discountPercentage = couponOnlyDiscount / subTotal;
          _couponDiscount = currentPrice * _discountPercentage;
        } else {
          _discountPercentage = 0;
          _couponDiscount = 0;
        }

        setState(() {
          _isCouponValid = true;
          _couponMessage = _couponDiscount > 0
              ? '✅ خصم ${_couponDiscount.toStringAsFixed(0)} ريال'
              : '✅ تم تطبيق الكوبون';
          _isCheckingCoupon = false;
        });

        _updateFinalPrice(currentPrice);
      } else {
        setState(() {
          _isCouponValid = false;
          _couponMessage = '❌ ${result?['message'] ?? 'كود غير صالح'}';
          _couponDiscount = 0;
          _discountPercentage = 0;
          _isCheckingCoupon = false;
        });
        _updateFinalPrice(_calculateLocalPrice());
      }
    } catch (e) {
      setState(() {
        _isCouponValid = false;
        _couponMessage = '❌ حدث خطأ';
        _discountPercentage = 0;
        _couponDiscount = 0;
        _isCheckingCoupon = false;
      });
      _updateFinalPrice(_calculateLocalPrice());
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
        const SnackBar(
          content: Text('الرجاء اختيار عدد الأفراد'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    if (_selectedMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('الرجاء اختيار طريقة الدفع'),
          backgroundColor: Colors.orange,
        ),
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
            couponCode: _isCouponValid
                ? _couponController.text.trim()
                : null,
            usePoints: _isPointsApplied,
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

    // ✅ اقرأ النقاط من UserProvider (بيتحدث بعد fetchProfile)
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user ?? authProvider.currentUser;
    final userPoints = user?.availablePoints ?? 0;
    final employeeWhatsApp = settingsProvider.settings?.whatsappNumber ?? '';

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'إتمام الحجز',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 18,
              color: Colors.white,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: pp.isLoading && pp.paymentMethods.isEmpty
          ? _PaymentShimmer(isDark: isDark)
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOrderSummary(ss, isDark, userPoints),
            const SizedBox(height: 24),
            _buildPaymentDropdown(
              pp,
              ss,
              isDark,
              employeeWhatsApp,
              settingsProvider,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _localAttendees > 0
                    ? _continueToPayment
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _localAttendees > 0
                      ? AppColors.primary
                      : Colors.grey,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 3,
                ),
                child: Text(
                  _localAttendees > 0
                      ? 'تأكيد الطلب (${_finalPrice.toStringAsFixed(0)} ريال)'
                      : 'الرجاء اختيار عدد الأفراد',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
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

  Widget _buildOrderSummary(
      SettingsService ss,
      bool isDark,
      double userPoints,
      ) {
    final currentPrice =
    _localAttendees > 0 ? _calculateLocalPrice() : 0;
    final cardBg = isDark ? Colors.grey.shade900 : Colors.white;
    final textPrimary = isDark ? Colors.white : Colors.black87;
    final textSecondary =
    isDark ? Colors.white60 : Colors.grey.shade600;
    final dividerColor =
    isDark ? Colors.white12 : Colors.grey.shade200;
    final rowBg =
    isDark ? Colors.grey.shade800 : Colors.grey.shade50;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── هيدر أزرق ──
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary,
                AppColors.primary.withOpacity(0.85),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(16),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.receipt_long, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'ملخص الطلب',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(
                    Icons.flight_takeoff,
                    color: Colors.white70,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      widget.item.getTitle(ss.languageCode),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(
                    Icons.nightlight_round,
                    color: Colors.greenAccent,
                    size: 14,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${widget.item.totalNights} ليالي',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // ── جسم الكارد ──
        Container(
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(16),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.07),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // تفاصيل الغرف
              if (_localSelectedPrices.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Row(
                    children: [
                      Icon(
                        Icons.hotel,
                        color: AppColors.primary,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'تفاصيل الحجز',
                        style: TextStyle(
                          color: textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: _localSelectedPrices
                        .where(
                          (sp) => (sp['attendees'] as int? ?? 0) > 0,
                    )
                        .map((sp) {
                      final pid = sp['price_id'] as int?;
                      final att = sp['attendees'] as int? ?? 0;
                      if (pid == null || att == 0) {
                        return const SizedBox.shrink();
                      }
                      final rt = widget.item.getPriceById(pid);
                      if (rt == null && pid != 0) {
                        return const SizedBox.shrink();
                      }
                      final effectivePrice =
                          rt?.effectivePrice ??
                              widget.item.priceAfterDiscount;
                      final title = rt?.getTitle('ar') ?? 'سعر اساسي';
                      final st = effectivePrice * att;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: rowBg,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: dividerColor),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 26,
                                  height: 26,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary
                                        .withOpacity(0.12),
                                    borderRadius:
                                    BorderRadius.circular(6),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '$att',
                                      style: const TextStyle(
                                        color: AppColors.primary,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    title,
                                    style: TextStyle(
                                      color: textPrimary,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () =>
                                      _updateLocalAttendees(pid, -1),
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.remove,
                                      color: Colors.red.shade400,
                                      size: 16,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '$att',
                                  style: TextStyle(
                                    color: textPrimary,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () =>
                                      _updateLocalAttendees(pid, 1),
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary
                                          .withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.add,
                                      color: AppColors.primary,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const SizedBox(width: 34),
                                Text(
                                  '$att فرد × ${effectivePrice.toStringAsFixed(0)} ريال',
                                  style: TextStyle(
                                    color: textSecondary,
                                    fontSize: 15,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  '${st.toStringAsFixed(0)} ريال',
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Divider(
                  color: dividerColor,
                  height: 1,
                  indent: 16,
                  endIndent: 16,
                ),
              ],

              // إجمالي المسافرين
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Row(
                  children: [
                    Icon(
                      Icons.people,
                      color: textSecondary,
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'إجمالي المسافرين: $_localAttendees فرد',
                      style: TextStyle(
                        color: textSecondary,
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
              ),

              // المجموع الفرعي
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    color: rowBg,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: dividerColor),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'المجموع الفرعي',
                        style: TextStyle(
                          color: textSecondary,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '${currentPrice.toStringAsFixed(0)} ريال',
                        style: TextStyle(
                          color: _localAttendees > 0
                              ? textPrimary
                              : textSecondary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // النقاط + الكوبون
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: rowBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: dividerColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── النقاط ──
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.card_giftcard,
                                      color: Colors.amber.shade600,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'استخدام نقاطي',
                                      style: TextStyle(
                                        color: textPrimary,
                                        fontSize: 16,
                                      ),
                                    ),
                                    if (_isCheckingPoints) ...[
                                      const SizedBox(width: 8),
                                      SizedBox(
                                        width: 14,
                                        height: 14,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'الرصيد: ${userPoints.toStringAsFixed(2)} نقطة',
                                  style: TextStyle(
                                    color: Colors.amber.shade700,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: _usePoints,
                            onChanged: _isCheckingPoints
                                ? null
                                : (v) => _togglePoints(v),
                            activeColor: Colors.amber,
                            activeTrackColor:
                            Colors.amber.withOpacity(0.3),
                          ),
                        ],
                      ),
                      if (_pointsMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 26,
                            top: 2,
                          ),
                          child: Text(
                            _pointsMessage!,
                            style: TextStyle(
                              fontSize: 14,
                              color: _isPointsApplied
                                  ? Colors.amber.shade700
                                  : Colors.red.shade600,
                            ),
                          ),
                        ),

                      // ── فاصل ──
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Divider(color: dividerColor),
                      ),

                      // ── الكوبون ──
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _couponController,
                              enabled: !_isCouponValid,
                              style: TextStyle(
                                color: textPrimary,
                                fontSize: 14,
                              ),
                              decoration: InputDecoration(
                                hintText: 'أدخل كود الخصم',
                                hintStyle: TextStyle(
                                  color: textSecondary,
                                  fontSize: 14,
                                ),
                                contentPadding:
                                const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                isDense: true,
                                border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(8),
                                  borderSide:
                                  BorderSide(color: dividerColor),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(8),
                                  borderSide:
                                  BorderSide(color: dividerColor),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: AppColors.primary,
                                  ),
                                ),
                                filled: true,
                                fillColor: isDark
                                    ? Colors.grey.shade800
                                    : Colors.white,
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
                                  color: Colors.red.withOpacity(0.1),
                                  borderRadius:
                                  BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.close,
                                  color: Colors.red.shade400,
                                  size: 18,
                                ),
                              ),
                            )
                          else
                            GestureDetector(
                              onTap: _isCheckingCoupon
                                  ? null
                                  : _checkCoupon,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius:
                                  BorderRadius.circular(8),
                                ),
                                child: _isCheckingCoupon
                                    ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                                    : const Text(
                                  'تطبيق',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      if (_couponMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            _couponMessage!,
                            style: TextStyle(
                              fontSize: 14,
                              color: _isCouponValid
                                  ? Colors.green.shade600
                                  : Colors.red.shade600,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // خصم النقاط
              if (_isPointsApplied && _pointsDiscount > 0)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.amber.withOpacity(0.15)
                          : Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isDark
                            ? Colors.amber.withOpacity(0.3)
                            : Colors.amber.shade200,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.card_giftcard,
                              color: Colors.amber.shade700,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'خصم النقاط',
                              style: TextStyle(
                                color: Colors.amber.shade700,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '-${_pointsDiscount.toStringAsFixed(0)} ريال',
                          style: TextStyle(
                            color: Colors.amber.shade700,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // خصم الكوبون
              if (_isCouponValid && _couponDiscount > 0)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.green.withOpacity(0.15)
                          : Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isDark
                            ? Colors.green.withOpacity(0.3)
                            : Colors.green.shade200,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.discount,
                              color: Colors.green.shade600,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'خصم الكوبون',
                              style: TextStyle(
                                color: Colors.green.shade600,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '-${_couponDiscount.toStringAsFixed(0)} ريال',
                          style: TextStyle(
                            color: Colors.green.shade600,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // الإجمالي
              Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.payment, color: Colors.white, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'الإجمالي',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '${_finalPrice.toStringAsFixed(0)} ريال',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
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
    if (allMethods.isEmpty) return const SizedBox.shrink();

    final companyLogo =
        settingsProvider.settings?.getLogo(isDark) ?? '';

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
          // ==================== هيدر طريقة الدفع ====================
          GestureDetector(
            onTap: () => setState(
                  () => _isPaymentExpanded = !_isPaymentExpanded,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey.shade800 : Colors.grey.shade50,
                borderRadius: _isPaymentExpanded
                    ? const BorderRadius.vertical(
                  top: Radius.circular(16),
                )
                    : BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.payment,
                      color: AppColors.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _selectedMethod != null
                              ? (_selectedMethod!.isTamara
                              ? 'قسطها مع ${_selectedMethod!.getTitle(ss.languageCode)}'
                              : _selectedMethod!.getTitle(ss.languageCode))
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
                            _selectedMethod!.isTamara
                                ? 'تقسيط'
                                : _selectedMethod!.isBankTransfer
                                ? 'تحويل بنكي'
                                : 'دفع إلكتروني',
                            style: TextStyle(
                              fontSize: 12,
                              color: _selectedMethod!.isTamara
                                  ? Colors.purple
                                  : _selectedMethod!.isBankTransfer
                                  ? Colors.blue
                                  : Colors.green,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (_selectedMethod != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: _selectedMethod!.banner,
                        width: 70,
                        height: 50,
                        fit: BoxFit.cover,
                        errorWidget: (ctx, url, e) => Icon(
                          _selectedMethod!.isTamara
                              ? Icons.credit_score
                              : _selectedMethod!.isBankTransfer
                              ? Icons.account_balance
                              : Icons.payment,
                          color: AppColors.primary,
                          size: 30,
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
                ],
              ),
            ),
          ),

          // ==================== قائمة طرق الدفع ====================
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: _isPaymentExpanded
                ? Column(
              children: [
                ...allMethods.map((method) {
                  final isSelected =
                      _selectedMethod?.id == method.id;
                  final cardColor = method.isBankTransfer
                      ? Colors.blue
                      : method.isTamara
                      ? Colors.purple
                      : Colors.green;

                  return GestureDetector(
                    onTap: () {
                      if (method.isTamara &&
                          employeeWhatsApp.isNotEmpty) {
                        _launchWhatsApp(
                          employeeWhatsApp,
                          message: _getTamaraMessage(ss),
                        );
                        return;
                      }
                      setState(() {
                        _selectedMethod = method;
                        _isPaymentExpanded = false;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? cardColor.withOpacity(0.1)
                            : Colors.transparent,
                        border: Border(
                          bottom: BorderSide(
                            color: isDark
                                ? Colors.grey.shade700
                                : Colors.grey.shade200,
                            width: 0.5,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl: method.banner,
                              width: 140,
                              height: 100,
                              fit: BoxFit.cover,
                              placeholder: (c, url) => Container(width: 140, height: 100, color: cardColor.withOpacity(0.05)),
                              errorWidget: (ctx, url, e) =>
                                  Container(
                                    width: 120,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: cardColor.withOpacity(0.1),
                                      borderRadius:
                                      BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      method.isTamara
                                          ? Icons.credit_score
                                          : method.isBankTransfer
                                          ? Icons.account_balance
                                          : Icons.payment,
                                      color: cardColor,
                                      size: 24,
                                    ),
                                  ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              method.isTamara
                                  ? 'قسطها مع ${method.getTitle(ss.languageCode)}'
                                  : method.getTitle(ss.languageCode),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isDark
                                    ? Colors.white
                                    : Colors.black87,
                              ),
                            ),
                          ),
                          if (isSelected)
                            Icon(
                              Icons.check_circle,
                              color: cardColor,
                              size: 24,
                            ),
                        ],
                      ),
                    ),
                  );
                }),

                // ==================== تقسيط مع الشركة ====================
                if (employeeWhatsApp.isNotEmpty) ...[
                  const Divider(height: 1),
                  GestureDetector(
                    onTap: () => _launchWhatsApp(
                      employeeWhatsApp,
                      message: _getCompanyInstallmentMessage(ss),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.05),
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(16),
                        ),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: companyLogo.isNotEmpty
                                ? CachedNetworkImage(
                              imageUrl: companyLogo,
                              width: 140,
                              height: 100,
                              fit: BoxFit.contain,
                              placeholder: (c, url) => Container(width: 140, height: 100, color: const Color(0xFF25D366).withOpacity(0.05)),
                              errorWidget: (ctx, url, e) =>
                                  Container(
                                    width: 140,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF25D366)
                                          .withOpacity(0.1),
                                      borderRadius:
                                      BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.business,
                                      color: Color(0xFF25D366),
                                      size: 26,
                                    ),
                                  ),
                            )
                                : Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: const Color(0xFF25D366)
                                    .withOpacity(0.1),
                                borderRadius:
                                BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.business,
                                color: Color(0xFF25D366),
                                size: 26,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'سدد علي دفعات مع رحلتنا',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.grey,
                          ),
                        ],
                      ),
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

// ==================== شيمر ====================

class _PaymentShimmer extends StatelessWidget {
  final bool isDark;
  const _PaymentShimmer({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final base =
    isDark ? AppColors.shimmerBaseDark : AppColors.shimmerBase;
    final highlight = isDark
        ? AppColors.shimmerHighlightDark
        : AppColors.shimmerHighlight;
    final bg = isDark ? Colors.grey.shade900 : Colors.white;

    Widget box(double w, double h, {double r = 8}) => Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(r),
      ),
    );

    return Shimmer.fromColors(
      baseColor: base,
      highlightColor: highlight,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 90,
              decoration: BoxDecoration(
                color: bg,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  box(120, 18, r: 6),
                  const SizedBox(height: 10),
                  box(200, 14, r: 6),
                  const SizedBox(height: 6),
                  box(80, 12, r: 6),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: bg,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(16),
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  box(100, 14, r: 6),
                  const SizedBox(height: 12),
                  Container(
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 16),
                  box(double.infinity, 44, r: 8),
                  const SizedBox(height: 12),
                  box(double.infinity, 90, r: 12),
                  const SizedBox(height: 16),
                  box(double.infinity, 52, r: 12),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  box(double.infinity, 70, r: 12),
                ],
              ),
            ),
            const SizedBox(height: 24),
            box(double.infinity, 55, r: 14),
          ],
        ),
      ),
    );
  }
}