import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/models/item_model.dart';
import '../../data/providers/items_provider.dart';
import '../../data/services/settings_service.dart';
import '../payment/payment_options_screen.dart';

class ItemDetailsScreen extends StatefulWidget {
  final int itemId;
  final Color categoryColor;

  const ItemDetailsScreen({
    Key? key,
    required this.itemId,
    required this.categoryColor,
  }) : super(key: key);

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  ItemModel? _item;
  bool _isLoading = true;
  String? _errorMessage;
  int _currentImageIndex = 0;
  final PageController _pageController = PageController();
  final Map<int, int> _attendeesPerPrice = {};

  // ==================== دورة الحياة ====================

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadItemDetails());
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // ==================== تحميل البيانات ====================

  Future<void> _loadItemDetails() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final ip = Provider.of<ItemsProvider>(context, listen: false);
      _item = ip.getItemById(widget.itemId);
      if (_item == null) _item = await ip.fetchItemDetails(widget.itemId);
      if (_item == null) {
        setState(() => _errorMessage = 'لم يتم العثور على الرحلة');
      }
    } catch (e) {
      setState(() => _errorMessage = 'حدث خطأ: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // ==================== حساب السعر ====================

  double get _totalPrice {
    if (_item == null) return 0;

    // ✅ لو مفيش أسعار متعددة (سعر واحد فقط)
    if (_item!.prices.isEmpty) {
      final attendees = _getTotalAttendees();
      // لو مفيش أفراد مختارين، رجع 0
      if (attendees <= 0) return 0;
      return _item!.priceAfterDiscount * attendees;
    }

    // ✅ لو فيه أسعار متعددة (غرف مختلفة)
    double total = 0;
    bool hasSelection = false;

    for (var p in _item!.prices) {
      final a = _attendeesPerPrice[p.id] ?? 0;
      if (a > 0) {
        total += p.effectivePrice * a;
        hasSelection = true;
      }
    }

    // ✅ لو مفيش أي اختيار، رجع 0
    if (!hasSelection) return 0;

    return total;
  }

  int _getTotalAttendees() {
    int t = 0;
    for (var e in _attendeesPerPrice.entries) {
      t += e.value;
    }
    // ✅ رجع 0 لو مفيش اختيار
    return t;
  }

  String get _totalPriceDisplay {
    final price = _totalPrice;
    if (price <= 0) return '0 ريال';
    return '${price.toStringAsFixed(0)} ريال';
  }

  PriceModel? _getMinPriceObject() {
    if (_item == null || _item!.prices.isEmpty) return null;
    return _item!.prices.reduce(
            (a, b) => a.effectivePrice < b.effectivePrice ? a : b);
  }

  void _updateAttendees(int priceId, int delta) {
    setState(() {
      final cur = _attendeesPerPrice[priceId] ?? 0;
      final nv = cur + delta;
      if (nv >= 0 && nv <= 50) _attendeesPerPrice[priceId] = nv;
    });
  }

  List<Map<String, dynamic>> _buildSelectedPrices() {
    return _attendeesPerPrice.entries
        .where((e) => e.value > 0 && e.key > 0)
        .map((e) => {"price_id": e.key, "attendees": e.value})
        .toList();
  }

  // ==================== دوال التواصل ====================

  String _formatPhone(String phone) {
    if (phone.isEmpty) return '';
    String c = phone.replaceAll(RegExp(r'[\s\-]'), '');
    if (c.startsWith('0') && c.length == 10) return '+966${c.substring(1)}';
    if (c.startsWith('966')) return '+$c';
    if (c.startsWith('+966')) return c;
    if (c.startsWith('05') && c.length == 10) return '+966${c.substring(1)}';
    if (c.startsWith('5') && c.length == 9) return '+966$c';
    return '+966$c';
  }

  Future<void> _call(String phone) async {
    final Uri u = Uri(scheme: 'tel', path: _formatPhone(phone));
    if (await canLaunchUrl(u)) await launchUrl(u);
  }

  Future<void> _wa(String phone) async {
    final p = _formatPhone(phone).replaceAll('+', '');
    final Uri u = Uri.parse('https://wa.me/$p');
    if (await canLaunchUrl(u)) {
      await launchUrl(u, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _waMsg(String phone, String title) async {
    final p = _formatPhone(phone).replaceAll('+', '');
    final StringBuffer message = StringBuffer();

    message.writeln('📌 استفسار بخصوص الرحلة:');
    message.writeln('─────────────────');
    message.writeln('✈️ ${_item!.getTitle('ar')}');

    if (_item!.season.isNotEmpty) {
      message.writeln('📅 الموسم: ${_item!.season}');
    }

    message.writeln('🗓 من ${_item!.startDate} إلى ${_item!.endDate}');

    if (_item!.itineraries.isNotEmpty) {
      message.writeln('─────────────────');
      // ✅ المدن جنب بعض بدون عدد الليالي
      final cities = _item!.itineraries
          .map((itin) => itin.city.getTitle('ar'))
          .join(' - ');
      message.writeln('📍 المدن: $cities');
    }

    final Uri u = Uri.parse(
        'https://wa.me/$p?text=${Uri.encodeComponent(message.toString())}');
    if (await canLaunchUrl(u)) {
      await launchUrl(u, mode: LaunchMode.externalApplication);
    }
  }
  void _showFullImg(BuildContext ctx, String url) {
    Navigator.push(
      ctx,
      MaterialPageRoute(
        builder: (c) => Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              Center(
                child: InteractiveViewer(
                  panEnabled: true,
                  minScale: 0.8,
                  maxScale: 4.0,
                  child: Image.network(
                    url,
                    fit: BoxFit.contain,
                    errorBuilder: (c, e, s) => Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.broken_image,
                              size: 80, color: Colors.grey),
                          const SizedBox(height: 16),
                          const Text('خطأ',
                              style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 40,
                right: 20,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==================== الانتقال للدفع ====================

  void _goPayment() {
    if (_item == null) return;

    final attendees = _getTotalAttendees();

    // ✅ لو مفيش أفراد، منعملش حاجة
    if (attendees == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('الرجاء اختيار عدد الأفراد أولاً'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final hasPrices = _item!.prices.isNotEmpty;
    final selectedPrices = hasPrices ? _buildSelectedPrices() : null;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (c) => PaymentOptionsScreen(
          item: _item!,
          price: _totalPrice,
          attendees: attendees,
          selectedPrices: selectedPrices,
        ),
      ),
    );
  }

  // ==================== ألوان ====================

  Color _bgColor(bool isDark) => isDark ? Colors.grey.shade900 : Colors.white;
  Color _bgLight(bool isDark) =>
      isDark ? Colors.grey.shade800 : Colors.grey.shade50;
  Color _textColor(bool isDark) =>
      isDark ? Colors.white : Colors.grey.shade900;
  Color _subColor(bool isDark) =>
      isDark ? Colors.white70 : Colors.grey.shade700;

  // ==================== الواجهة الرئيسية ====================

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final ss = Provider.of<SettingsService>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildAppBar(ss),
      body: _buildBodyContent(ss, isDark),
      bottomNavigationBar:
      _item != null ? _buildBottomBar(ss, isDark) : null,
    );
  }

  PreferredSizeWidget _buildAppBar(SettingsService ss) {
    return AppBar(
      title: Text(
        _item?.getTitle(ss.languageCode) ?? 'تفاصيل الرحلة',
        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
      backgroundColor: widget.categoryColor,
      elevation: 0,
      centerTitle: true,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon:
          const Icon(Icons.arrow_back_ios, size: 18, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }

  Widget _buildBodyContent(SettingsService ss, bool isDark) {
    if (_isLoading) {
      return Center(
          child: CircularProgressIndicator(color: widget.categoryColor));
    }
    if (_errorMessage != null || _item == null) return _buildErrorState();
    return _buildDetails(ss, isDark);
  }

  Widget _buildDetails(SettingsService ss, bool isDark) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImageGallery(ss),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitleAndSeason(ss, isDark),
                const SizedBox(height: 16),
                _buildPriceAndAttendeesCard(ss, isDark),
                const SizedBox(height: 16),
                if (_item!.itineraries.isNotEmpty) ...[
                  _buildItinerarySection(ss, isDark),
                  const SizedBox(height: 16),
                ],
                if (_item!.routes.isNotEmpty) ...[
                  _buildRoutesSection(ss, isDark),
                  const SizedBox(height: 16),
                ],
                if (_item!.excludes.isNotEmpty) ...[
                  _buildExcludesSection(ss, isDark),
                  const SizedBox(height: 16),
                ],
                const SizedBox(height: 8),
                _buildDescriptionSection(ss, isDark),
                const SizedBox(height: 24),
                _buildContactButtons(ss),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==================== اسم + موسم ====================

  Widget _buildTitleAndSeason(SettingsService ss, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _item!.getTitle(ss.languageCode),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: _textColor(isDark),
          ),
        ),
        if (_item!.season.isNotEmpty) ...[
          const SizedBox(height: 4),
          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(isDark ? 0.2 : 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [

                const SizedBox(width: 4),
                Text(
                  _item!.season,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.orange,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  // ==================== الأسعار + الأفراد + التاريخ ====================

  Widget _buildPriceAndAttendeesCard(SettingsService ss, bool isDark) {
    // ✅ ترتيب الأسعار تنازلياً (الأكبر سعراً فالأصغر)
    final List<PriceModel> sortedPrices;
    if (_item!.prices.isNotEmpty) {
      sortedPrices = List<PriceModel>.from(_item!.prices);
      sortedPrices.sort((a, b) => b.effectivePrice.compareTo(a.effectivePrice));
    } else {
      sortedPrices = <PriceModel>[];
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _bgLight(isDark),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: widget.categoryColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.sell_outlined,
                  size: 20, color: widget.categoryColor),
              const SizedBox(width: 8),
              Text(
                'الأسعار وعدد المسافرين',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: _textColor(isDark),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (sortedPrices.isNotEmpty) ...[
            ...sortedPrices.map((price) => _buildPriceItem(price, ss, isDark)),
          ] else ...[
            _buildSinglePriceRow(isDark),
            const SizedBox(height: 12),
            _buildAttendeesRow(0, isDark),
          ],
          const Divider(height: 24, color: Colors.grey),
          _buildDateRow(isDark),
        ],
      ),
    );
  }

  Widget _buildPriceItem(PriceModel price, SettingsService ss, bool isDark) {
    final att = _attendeesPerPrice[price.id] ?? 0;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _bgColor(isDark),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: widget.categoryColor.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      price.getTitle(ss.languageCode),
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: _textColor(isDark),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          '${price.effectivePrice.toStringAsFixed(0)} ريال / للفرد',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: widget.categoryColor,
                          ),
                        ),
                        if (price.hasDiscount) ...[
                          const SizedBox(width: 8),
                          Text(
                            '${price.price.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              if (att > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: widget.categoryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${price.effectivePrice * att} ريال',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: widget.categoryColor,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                // ✅ ينفع ينزل لـ 0
                onPressed: att > 0
                    ? () => _updateAttendees(price.id, -1)
                    : null,
                icon: Icon(
                  Icons.remove_circle_outline,
                  color: att > 0 ? widget.categoryColor : Colors.grey,
                ),
                iconSize: 28,
              ),
              const SizedBox(width: 20),
              Column(
                children: [
                  Text(
                    '$att',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: att > 0 ? widget.categoryColor : Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              IconButton(
                onPressed: () => _updateAttendees(price.id, 1),
                icon: Icon(
                  Icons.add_circle_outline,
                  color: widget.categoryColor,
                ),
                iconSize: 28,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSinglePriceRow(bool isDark) {
    return Row(
      children: [
        Text(
          '${_item!.priceAfterDiscount.toStringAsFixed(0)} ريال / للفرد',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.bold,
            color: widget.categoryColor,
          ),
        ),
        if (_item!.hasItemDiscount) ...[
          const SizedBox(width: 12),
          Text(
            '${_item!.price.toStringAsFixed(0)}',
            style: TextStyle(
              fontSize: 17,
              color: Colors.grey,
              decoration: TextDecoration.lineThrough,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'خصم ${_item!.discountPercent}%',
              style: const TextStyle(fontSize: 15, color: Colors.red),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildAttendeesRow(int priceId, bool isDark) {
    final att = priceId == 0
        ? _getTotalAttendees()
        : (_attendeesPerPrice[priceId] ?? 0);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          // ✅ ينفع ينزل لـ 0
          onPressed: att > 0 ? () => _updateAttendees(priceId, -1) : null,
          icon: Icon(
            Icons.remove_circle_outline,
            color: att > 0 ? widget.categoryColor : Colors.grey,
          ),
          iconSize: 28,
        ),
        const SizedBox(width: 20),
        Text(
          '$att فرد',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
            color: att > 0 ? widget.categoryColor : Colors.grey,
          ),
        ),
        const SizedBox(width: 20),
        IconButton(
          onPressed: () => _updateAttendees(priceId, 1),
          icon: Icon(Icons.add_circle_outline, color: widget.categoryColor),
          iconSize: 28,
        ),
      ],
    );
  }

  // ==================== صف التواريخ (ميلادي + هجري) ====================

  /// تنسيق التاريخ الميلادي
  String _formatDate(String date) {
    if (date.isEmpty) return '';

    try {
      // لو التاريخ بالصيغة دي: 2026-05-15
      final parts = date.split('-');
      if (parts.length == 3) {
        final year = parts[0];
        final month = _getMonthName(int.tryParse(parts[1]) ?? 0);
        final day = int.tryParse(parts[2]) ?? 0;
        return '$day $month $year';
      }

      // لو التاريخ بالصيغة دي: 15/05/2026
      final parts2 = date.split('/');
      if (parts2.length == 3) {
        final day = int.tryParse(parts2[0]) ?? 0;
        final month = _getMonthName(int.tryParse(parts2[1]) ?? 0);
        final year = parts2[2];
        return '$day $month $year';
      }

      // لو تاريخ تاني، رجعه كما هو
      return date;
    } catch (e) {
      return date;
    }
  }

  /// الحصول على اسم الشهر الميلادي بالعربي
  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'يناير';
      case 2:
        return 'فبراير';
      case 3:
        return 'مارس';
      case 4:
        return 'أبريل';
      case 5:
        return 'مايو';
      case 6:
        return 'يونيو';
      case 7:
        return 'يوليو';
      case 8:
        return 'أغسطس';
      case 9:
        return 'سبتمبر';
      case 10:
        return 'أكتوبر';
      case 11:
        return 'نوفمبر';
      case 12:
        return 'ديسمبر';
      default:
        return '';
    }
  }

  /// تنسيق التاريخ الهجري
  String _formatHijriDate(String date) {
    if (date.isEmpty) return '';

    try {
      // لو التاريخ بالصيغة دي: 1447-11-28
      final parts = date.split('-');
      if (parts.length == 3) {
        final year = parts[0];
        final month = _getHijriMonthName(int.tryParse(parts[1]) ?? 0);
        final day = int.tryParse(parts[2]) ?? 0;
        return '$day $month $year';
      }

      // لو التاريخ بالصيغة دي: 28/11/1447
      final parts2 = date.split('/');
      if (parts2.length == 3) {
        final day = int.tryParse(parts2[0]) ?? 0;
        final month = _getHijriMonthName(int.tryParse(parts2[1]) ?? 0);
        final year = parts2[2];
        return '$day $month $year';
      }

      // لو التاريخ جاهز (28 ذو القعدة 1447) رجعه كما هو
      return date;
    } catch (e) {
      return date;
    }
  }

  /// الحصول على اسم الشهر الهجري بالعربي
  String _getHijriMonthName(int month) {
    switch (month) {
      case 1:
        return 'محرم';
      case 2:
        return 'صفر';
      case 3:
        return 'ربيع الأول';
      case 4:
        return 'ربيع الثاني';
      case 5:
        return 'جمادى الأولى';
      case 6:
        return 'جمادى الآخرة';
      case 7:
        return 'رجب';
      case 8:
        return 'شعبان';
      case 9:
        return 'رمضان';
      case 10:
        return 'شوال';
      case 11:
        return 'ذو القعدة';
      case 12:
        return 'ذو الحجة';
      default:
        return '';
    }
  }

  Widget _buildDateRow(bool isDark) {
    return Column(
      children: [
        // 📅 Container التاريخ الميلادي
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: widget.categoryColor
                .withOpacity(isDark ? 0.1 : 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: widget.categoryColor.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 📅 صف التاريخ الميلادي
              Row(
                children: [
                  Icon(Icons.calendar_today,
                      size: 18, color: widget.categoryColor),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'التاريخ (ميلادي)',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: _textColor(isDark),
                            ),
                            children: [
                              TextSpan(
                                  text: _formatDate(_item!.startDate)),
                              TextSpan(
                                text: ' — ',
                                style: TextStyle(
                                    color: widget.categoryColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                  text: _formatDate(_item!.endDate)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // ✅ عدد الليالي تحت التاريخ الميلادي
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border:
                  Border.all(color: Colors.green.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.nightlight_round,
                        size: 14, color: Colors.green.shade700),
                    const SizedBox(width: 4),
                    Text(
                      '${_item!.totalNights} ليالي',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // ➖ فاصل بين الميلادي والهجري
        if (_item!.startDateHijri.isNotEmpty ||
            _item!.endDateHijri.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                Expanded(
                    child:
                    Divider(color: Colors.grey.withOpacity(0.3))),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Icon(Icons.more_horiz,
                      size: 16, color: Colors.grey),
                ),
                Expanded(
                    child:
                    Divider(color: Colors.grey.withOpacity(0.3))),
              ],
            ),
          ),

          // 📅 Container التاريخ الهجري
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: widget.categoryColor
                  .withOpacity(isDark ? 0.1 : 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: widget.categoryColor.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Icon(Icons.mosque,
                    size: 18, color: widget.categoryColor),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'التاريخ (هجري)',
                        style: TextStyle(
                          fontSize: 15,
                          color: widget.categoryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: _textColor(isDark),
                          ),
                          children: [
                            TextSpan(
                                text: _formatHijriDate(
                                    _item!.startDateHijri)),
                            TextSpan(
                              text: ' — ',
                              style: TextStyle(
                                  color: widget.categoryColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                                text: _formatHijriDate(
                                    _item!.endDateHijri)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  // ==================== محطات الرحلة (الإقامة) ====================

  Widget _buildItinerarySection(SettingsService ss, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ✅ عنوان معدل
        Row(
          children: [
            Container(
              width: 4,
              height: 20,
              decoration: BoxDecoration(
                color: widget.categoryColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'محطات الرحلة (الإقامة)',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _textColor(isDark),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ..._item!.itineraries.map((itin) => Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: _bgColor(isDark),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: widget.categoryColor.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🏙️ هيدر المدينة + التاريخ + عدد الليالي
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: widget.categoryColor
                      .withOpacity(isDark ? 0.15 : 0.1),
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            itin.city.getTitle(ss.languageCode),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: _textColor(isDark),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${itin.startDate} - ${itin.endDate}',
                            style: TextStyle(
                                fontSize: 13, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: widget.categoryColor
                            .withOpacity(isDark ? 0.25 : 0.2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        '${itin.nights} ليلة',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: widget.categoryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ✅ المناطق السياحية في المدينة
              if (itin.places.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'المناطق السياحية:',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: widget.categoryColor,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: itin.places
                            .map((p) => Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: widget.categoryColor
                                .withOpacity(isDark ? 0.08 : 0.05),
                            borderRadius:
                            BorderRadius.circular(15),
                            border: Border.all(
                                color: widget.categoryColor
                                    .withOpacity(0.15)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.place,
                                  size: 13,
                                  color: widget.categoryColor),
                              const SizedBox(width: 3),
                              Text(
                                p.getTitle(ss.languageCode),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: _subColor(isDark),
                                ),
                              ),
                            ],
                          ),
                        ))
                            .toList(),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        )),
      ],
    );
  }

  // ==================== ما تشمله ====================

  Widget _buildRoutesSection(SettingsService ss, bool isDark) {
    if (_item!.routes.isEmpty) return const SizedBox.shrink();
    final sorted = List.from(_item!.routes)
      ..sort((a, b) => a.order.compareTo(b.order));
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _bgColor(isDark),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'ما تشمله الرحلة',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _textColor(isDark),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...sorted.map((r) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(isDark ? 0.15 : 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: r.icon.isNotEmpty
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      r.icon,
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                      errorBuilder: (c, e, s) => const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 18),
                    ),
                  )
                      : const Icon(Icons.check_circle,
                      color: Colors.green, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    r.getTitle(ss.languageCode),
                    style: TextStyle(
                      fontSize: 15,
                      color: _subColor(isDark),
                    ),
                  ),
                ),
                const Icon(Icons.check, color: Colors.green, size: 16),
              ],
            ),
          )),
        ],
      ),
    );
  }

  // ==================== ما لا تشمله ====================

  Widget _buildExcludesSection(SettingsService ss, bool isDark) {
    if (_item!.excludes.isEmpty) return const SizedBox.shrink();
    final sorted = List.from(_item!.excludes)
      ..sort((a, b) => a.order.compareTo(b.order));
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _bgColor(isDark),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'ما لا تشمله الرحلة',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _textColor(isDark),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...sorted.map((e) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(isDark ? 0.15 : 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: e.icon.isNotEmpty
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      e.icon,
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                      errorBuilder: (c, er, s) => const Icon(
                          Icons.cancel,
                          color: Colors.red,
                          size: 18),
                    ),
                  )
                      : const Icon(Icons.cancel,
                      color: Colors.red, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    e.getTitle(ss.languageCode),
                    style: TextStyle(
                      fontSize: 15,
                      color: _subColor(isDark),
                    ),
                  ),
                ),
                const Icon(Icons.close, color: Colors.red, size: 16),
              ],
            ),
          )),
        ],
      ),
    );
  }

  // ==================== الوصف ====================

  Widget _buildDescriptionSection(SettingsService ss, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _bgColor(isDark),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: widget.categoryColor.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.star_border, size: 20, color: Colors.amber),
              const SizedBox(width: 8),
              Text(
                'أهم الزيارات والفعاليات',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _textColor(isDark),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _item!
                .getDescription(ss.languageCode)
                .replaceAll(RegExp(r'<[^>]*>'), ''),
            style: TextStyle(
              fontSize: 15,
              color: _subColor(isDark),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  // ==================== معرض الصور ====================

  Widget _buildImageGallery(SettingsService ss) {
    final imgs = _item!.galleries.isNotEmpty
        ? _item!.galleries
        : [_item!.getBanner(ss.languageCode)];
    return Stack(
      children: [
        Container(
          height: 300,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (i) => setState(() => _currentImageIndex = i),
            itemCount: imgs.length,
            itemBuilder: (c, i) => GestureDetector(
              onTap: () => _showFullImg(c, imgs[i]),
              child: Image.network(
                imgs[i],
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (c, e, s) => Container(
                  color: Colors.grey.shade300,
                  child: const Center(
                    child: Icon(Icons.broken_image,
                        size: 50, color: Colors.grey),
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              '${_currentImageIndex + 1}/${imgs.length}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        if (imgs.length > 1)
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                imgs.length,
                    (i) => Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentImageIndex == i
                        ? widget.categoryColor
                        : Colors.white.withOpacity(0.5),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  // ==================== تواصل ====================

  Widget _buildContactButtons(SettingsService ss) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _call(_item!.contactUs),
                icon: const Icon(Icons.phone, size: 18),
                label: const Text('اتصال'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _wa(_item!.whatsapp),
                icon: const Icon(Icons.chat, size: 18),
                label: const Text('واتساب'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF25D366),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _waMsg(
                _item!.whatsapp, _item!.getTitle(ss.languageCode)),
            icon: const Icon(Icons.message, size: 18),
            label: const Text('استفسار عن الرحلة'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF128C7E),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      ],
    );
  }

  // ==================== شريط سفلي ====================

  Widget _buildBottomBar(SettingsService ss, bool isDark) {
    final price = _totalPrice;
    final hasSelection = _getTotalAttendees() > 0; // ✅ لازم يختار أفراد

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade900 : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'الإجمالي',
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? Colors.white54 : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _totalPriceDisplay,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: hasSelection ? widget.categoryColor : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              height: 48,
              child: ElevatedButton(
                // ✅ الزر شغال بس لو فيه أفراد مختارين
                onPressed: hasSelection ? _goPayment : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: hasSelection ? widget.categoryColor : Colors.grey.shade400,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: hasSelection ? 2 : 0,
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.lock_clock, size: 18),
                    SizedBox(width: 6),
                    Text(
                      'احجز الآن',
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.error_outline,
                size: 80, color: Colors.red),
          ),
          const SizedBox(height: 24),
          Text(
            _errorMessage ?? 'خطأ',
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _loadItemDetails,
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.categoryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ),
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }
}