import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import '../../data/models/item_model.dart';
import '../../data/models/review_model.dart';
import '../../data/providers/items_provider.dart';
import '../../data/providers/auth_provider.dart';
import '../../data/providers/reviews_provider.dart';
import '../../data/services/settings_service.dart';
import '../auth/login_screen.dart';
import '../auth/signup_screen.dart';
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
  // ==================== متغيرات الرحلة ====================
  ItemModel? _item;
  bool _isLoading = true;
  String? _errorMessage;
  int _currentImageIndex = 0;
  final PageController _pageController = PageController();
  final Map<int, int> _attendeesPerPrice = {};

  // ==================== متغيرات المراجعات ====================
  final Map<int, ScrollController> _reviewScrollControllers = {};
  bool _isReviewsSectionExpanded = false;
  bool _isReviewsLoaded = false;
  bool _isPricesSectionExpanded = false;
  // ==================== متغيرات الفيديو ====================
  final Map<int, VideoPlayerController?> _videoControllers = {};

  // ==================== دورة الحياة ====================

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadItemDetails();
      _loadTripReviews();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    for (var controller in _videoControllers.values) {
      controller?.dispose();
    }
    for (var controller in _reviewScrollControllers.values) {
      controller.dispose();
    }
    _reviewScrollControllers.clear();
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
  Future<void> _loadTripReviews() async {
    if (widget.itemId == 0) return;
    final reviewsProvider = context.read<ReviewsProvider>();
    await reviewsProvider.fetchTripReviews(widget.itemId);
    if (mounted) {
      setState(() {
        _isReviewsLoaded = true;
      });
    }
  }
  // ==================== معرض الوسائط ====================

  List<Map<String, String>> _getGalleryItems(SettingsService ss) {
    final List<Map<String, String>> items = [];

    final banner = _item!.getBanner(ss.languageCode);
    if (banner.isNotEmpty) {
      items.add({'url': banner, 'type': 'image'});
    }

    for (var url in _item!.galleries) {
      if (url.isNotEmpty) {
        final isVideo = url.toLowerCase().endsWith('.mp4') ||
            url.toLowerCase().endsWith('.mov') ||
            url.toLowerCase().endsWith('.avi') ||
            url.toLowerCase().endsWith('.webm') ||
            url.toLowerCase().endsWith('.mkv');

        final alreadyExists = items.any((item) => item['url'] == url);
        if (!alreadyExists) {
          items.add({
            'url': url,
            'type': isVideo ? 'video' : 'image',
          });
        }
      }
    }
    return items;
  }

  bool _isVideo(String type) => type == 'video';

  // ==================== حساب السعر ====================

  double get _totalPrice {
    if (_item == null) return 0;
    if (_item!.prices.isEmpty) {
      final attendees = _getTotalAttendees();
      if (attendees <= 0) return 0;
      return _item!.priceAfterDiscount * attendees;
    }
    double total = 0;
    bool hasSelection = false;
    for (var p in _item!.prices) {
      final a = _attendeesPerPrice[p.id] ?? 0;
      if (a > 0) {
        total += p.effectivePrice * a;
        hasSelection = true;
      }
    }
    if (!hasSelection) return 0;
    return total;
  }

  int _getTotalAttendees() {
    int t = 0;
    for (var e in _attendeesPerPrice.entries) {
      t += e.value;
    }
    return t;
  }

  String get _totalPriceDisplay {
    final price = _totalPrice;
    if (price <= 0) return '0 ريال';
    return '${price.toStringAsFixed(0)} ريال';
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
    if (_item!.season.isNotEmpty) message.writeln('📅 الموسم: ${_item!.season}');
    message.writeln('🗓 من ${_item!.startDate} إلى ${_item!.endDate}');
    if (_item!.itineraries.isNotEmpty) {
      message.writeln('─────────────────');
      final cities = _item!.itineraries.map((itin) => itin.city.getTitle('ar')).join(' - ');
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
                  child: CachedNetworkImage(
                    imageUrl: url,
                    fit: BoxFit.contain,
                    errorWidget: (c, url, e) => const Center(
                      child: Icon(Icons.broken_image, size: 80, color: Colors.grey),
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

  Future<void> _goPayment() async {
    if (_item == null) return;
    final attendees = _getTotalAttendees();
    if (attendees == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('الرجاء اختيار عدد الأفراد أولاً'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // إذا كان الزائر غير مسجل → نطلب منه الدخول أولاً
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (!authProvider.isLoggedIn) {
      final loggedIn = await _showGuestLoginDialog();
      if (!loggedIn || !mounted) return;
    }

    for (var controller in _videoControllers.values) {
      controller?.pause();
    }

    final selectedPrices =
    _item!.prices.isNotEmpty ? _buildSelectedPrices() : null;
    if (!mounted) return;
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

  /// يعرض نافذة تطلب من الزائر تسجيل الدخول أو إنشاء حساب.
  /// يعيد true إذا أتمّ المستخدم تسجيل الدخول بنجاح.
  Future<bool> _showGuestLoginDialog() async {
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.lock_outline, color: Colors.orange),
            SizedBox(width: 8),
            Text('يجب تسجيل الدخول أولاً'),
          ],
        ),
        content: const Text(
          'لإتمام الحجز يجب أن تكون مسجلاً.\nهل تريد تسجيل الدخول أو إنشاء حساب جديد؟',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          OutlinedButton(
            onPressed: () => Navigator.pop(ctx, 'register'),
            child: const Text('إنشاء حساب'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, 'login'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('تسجيل الدخول', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (result == null || !mounted) return false;

    if (result == 'login') {
      await Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen(returnOnLogin: true)));
    } else {
      await Navigator.push(context, MaterialPageRoute(builder: (_) => const SignupScreen(returnOnLogin: true)));
    }

    if (!mounted) return false;
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return authProvider.isLoggedIn;
  }

  // ==================== ألوان مساعدة ====================

  Color _bgColor(bool isDark) => isDark ? Colors.grey.shade900 : Colors.white;
  Color _bgLight(bool isDark) => isDark ? Colors.grey.shade800 : Colors.grey.shade50;
  Color _textColor(bool isDark) => isDark ? Colors.white : Colors.grey.shade900;
  Color _subColor(bool isDark) => isDark ? Colors.white70 : Colors.grey.shade700;

  // ==================== الواجهة الرئيسية ====================

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final ss = Provider.of<SettingsService>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildAppBar(ss),
      body: _buildBodyContent(ss, isDark),
      bottomNavigationBar: _item != null ? _buildBottomBar(ss, isDark) : null,
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
          icon: const Icon(Icons.arrow_back_ios, size: 18, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }

  Widget _buildBodyContent(SettingsService ss, bool isDark) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator(color: widget.categoryColor));
    }
    if (_errorMessage != null || _item == null) {
      return _buildErrorState();
    }
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
                const SizedBox(height: 12),
                _buildDateRow(isDark),
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
                const SizedBox(height: 16),
                _buildReviewsSection(ss, isDark),
                const SizedBox(height: 16),
                _buildPriceAndAttendeesCard(ss, isDark, _item!.isExpired),
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
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(isDark ? 0.2 : 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _item!.season,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.orange,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ],
    );
  }

  // ==================== الأسعار والأفراد ====================

  Widget _buildPriceAndAttendeesCard(
      SettingsService ss, bool isDark, bool isEnded) {
    List<PriceModel> sortedPrices = <PriceModel>[];
    if (_item!.prices.isNotEmpty) {
      sortedPrices = List<PriceModel>.from(_item!.prices);
      sortedPrices.sort((a, b) => b.effectivePrice.compareTo(a.effectivePrice));
    }
    return Container(
      decoration: BoxDecoration(
        color: _bgColor(isDark),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: widget.categoryColor.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => setState(() => _isPricesSectionExpanded = !_isPricesSectionExpanded),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey.shade800 : Colors.grey.shade50,
                borderRadius: _isPricesSectionExpanded
                    ? const BorderRadius.vertical(top: Radius.circular(16))
                    : BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [widget.categoryColor, widget.categoryColor.withOpacity(0.7)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.sell_outlined, color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isEnded ? 'الأسعار' : 'الأسعار وعدد المسافرين',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _textColor(isDark),
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: _isPricesSectionExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: Icon(Icons.keyboard_arrow_down, color: widget.categoryColor, size: 28),
                  ),
                ],
              ),
            ),
          ),
          if (_isPricesSectionExpanded) ...[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (sortedPrices.isNotEmpty)
                    ...sortedPrices.map(
                      (price) => _buildPriceItem(price, ss, isDark, isEnded),
                    )
                  else ...[
                    _buildSinglePriceRow(isDark),
                    if (!isEnded) ...[
                      const SizedBox(height: 12),
                      _buildAttendeesRow(0, isDark),
                    ],
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPriceItem(PriceModel price, SettingsService ss, bool isDark,
      bool isEnded) {
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
              if (!isEnded && att > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
          if (!isEnded) ...[
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: att > 0 ? () => _updateAttendees(price.id, -1) : null,
                  icon: Icon(
                    Icons.remove_circle_outline,
                    color: att > 0 ? widget.categoryColor : Colors.grey,
                  ),
                  iconSize: 28,
                ),
                const SizedBox(width: 20),
                Text(
                  '$att',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: att > 0 ? widget.categoryColor : Colors.grey,
                  ),
                ),
                const SizedBox(width: 20),
                IconButton(
                  onPressed: () => _updateAttendees(price.id, 1),
                  icon: Icon(Icons.add_circle_outline, color: widget.categoryColor),
                  iconSize: 28,
                ),
              ],
            ),
          ],
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
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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

  // ==================== التواريخ ====================

  String _formatDate(String date) {
    if (date.isEmpty) return '';
    try {
      final p = date.split('-');
      if (p.length == 3) {
        return '${p[2]} ${_getMonthName(int.tryParse(p[1]) ?? 0)} ${p[0]}';
      }
    } catch (_) {}
    return date;
  }

  String _getMonthName(int m) =>
      [
        '',
        'يناير',
        'فبراير',
        'مارس',
        'أبريل',
        'مايو',
        'يونيو',
        'يوليو',
        'أغسطس',
        'سبتمبر',
        'أكتوبر',
        'نوفمبر',
        'ديسمبر'
      ][m.clamp(0, 12)];

  String _formatHijriDate(String date) {
    if (date.isEmpty) return '';
    try {
      final p = date.split('-');
      if (p.length == 3) {
        return '${p[2]} ${_getHijriMonthName(int.tryParse(p[1]) ?? 0)} ${p[0]}';
      }
    } catch (_) {}
    return date;
  }

  String _getHijriMonthName(int m) =>
      [
        '',
        'محرم',
        'صفر',
        'ربيع الأول',
        'ربيع الثاني',
        'جمادى الأولى',
        'جمادى الآخرة',
        'رجب',
        'شعبان',
        'رمضان',
        'شوال',
        'ذو القعدة',
        'ذو الحجة'
      ][m.clamp(0, 12)];

  Widget _buildDateRow(bool isDark) {
    final hasHijri = _item!.startDateHijri.isNotEmpty || _item!.endDateHijri.isNotEmpty;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: widget.categoryColor.withOpacity(isDark ? 0.1 : 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: widget.categoryColor.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Dates info (right side in RTL)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_today_outlined, size: 14, color: widget.categoryColor),
                    const SizedBox(width: 6),
                    Text(
                      'التاريخ الميلادي',
                      style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _textColor(isDark)),
                    children: [
                      TextSpan(text: _formatDate(_item!.startDate)),
                      TextSpan(text: '  —  ', style: TextStyle(color: widget.categoryColor)),
                      TextSpan(text: _formatDate(_item!.endDate)),
                    ],
                  ),
                ),
                if (hasHijri) ...[
                  const SizedBox(height: 10),
                  Divider(height: 1, color: widget.categoryColor.withOpacity(0.15)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.mosque_outlined, size: 14, color: widget.categoryColor),
                      const SizedBox(width: 6),
                      Text(
                        'التاريخ الهجري',
                        style: TextStyle(fontSize: 12, color: widget.categoryColor, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _textColor(isDark)),
                      children: [
                        TextSpan(text: _formatHijriDate(_item!.startDateHijri)),
                        TextSpan(text: '  —  ', style: TextStyle(color: widget.categoryColor)),
                        TextSpan(text: _formatHijriDate(_item!.endDateHijri)),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Nights badge (left side in RTL)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(isDark ? 0.15 : 0.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.green.withOpacity(0.3)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.nightlight_round, size: 20, color: Colors.green.shade600),
                const SizedBox(height: 4),
                Text(
                  '${_item!.totalNights}',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green.shade700),
                ),
                Text(
                  'ليالي',
                  style: TextStyle(fontSize: 11, color: Colors.green.shade600, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==================== محطات الرحلة ====================

  Widget _buildItinerarySection(SettingsService ss, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        ..._item!.itineraries.map(
              (itin) => Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: _bgColor(isDark),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: widget.categoryColor.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: widget.categoryColor.withOpacity(isDark ? 0.15 : 0.1),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
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
                              style: TextStyle(fontSize: 13, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: widget.categoryColor.withOpacity(isDark ? 0.25 : 0.2),
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
                          children: itin.places.map(
                                (p) => Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: widget.categoryColor.withOpacity(isDark ? 0.08 : 0.05),
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: widget.categoryColor.withOpacity(0.15),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.place, size: 13, color: widget.categoryColor),
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
                            ),
                          ).toList(),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ==================== ما تشمله ====================

  Widget _buildRoutesSection(SettingsService ss, bool isDark) {
    if (_item!.routes.isEmpty) return const SizedBox.shrink();
    final sorted = List.from(_item!.routes)..sort((a, b) => a.order.compareTo(b.order));
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
          ...sorted.map(
                (r) => Padding(
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
                      child: CachedNetworkImage(
                        imageUrl: r.icon,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                        errorWidget: (c, url, e) => const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 18,
                        ),
                      ),
                    )
                        : const Icon(Icons.check_circle, color: Colors.green, size: 18),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      r.getTitle(ss.languageCode),
                      style: TextStyle(fontSize: 15, color: _subColor(isDark)),
                    ),
                  ),
                  const Icon(Icons.check, color: Colors.green, size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== ما لا تشمله ====================

  Widget _buildExcludesSection(SettingsService ss, bool isDark) {
    if (_item!.excludes.isEmpty) return const SizedBox.shrink();
    final sorted = List.from(_item!.excludes)..sort((a, b) => a.order.compareTo(b.order));
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
          ...sorted.map(
                (e) => Padding(
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
                      child: CachedNetworkImage(
                        imageUrl: e.icon,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                        errorWidget: (c, url, er) => const Icon(
                          Icons.cancel,
                          color: Colors.red,
                          size: 18,
                        ),
                      ),
                    )
                        : const Icon(Icons.cancel, color: Colors.red, size: 18),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      e.getTitle(ss.languageCode),
                      style: TextStyle(fontSize: 15, color: _subColor(isDark)),
                    ),
                  ),
                  const Icon(Icons.close, color: Colors.red, size: 16),
                ],
              ),
            ),
          ),
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
            _item!.getDescription(ss.languageCode).replaceAll(RegExp(r'<[^>]*>'), ''),
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

  // ==================== معرض الصور والفيديوهات ====================

  Widget _buildImageGallery(SettingsService ss) {
    final items = _getGalleryItems(ss);
    if (items.isEmpty) {
      return const SizedBox(
        height: 300,
        child: Center(
          child: Icon(Icons.image_not_supported, size: 60, color: Colors.grey),
        ),
      );
    }

    return Stack(
      children: [
        Container(
          height: 300,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (i) {
              setState(() {
                _currentImageIndex = i;
                for (var entry in _videoControllers.entries) {
                  if (entry.key != i && entry.value?.value.isPlaying == true) {
                    entry.value?.pause();
                  }
                }
              });
            },
            itemCount: items.length,
            itemBuilder: (c, i) {
              final item = items[i];
              final url = item['url'] ?? '';
              final type = item['type'] ?? 'image';
              if (_isVideo(type)) return _buildVideoItem(url, i);
              return GestureDetector(
                onTap: () => _showFullImg(c, url),
                child: CachedNetworkImage(
                  imageUrl: url,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  placeholder: (c, url) => Container(color: Colors.grey.shade300),
                  errorWidget: (c, u, e) => Container(
                    color: Colors.grey.shade300,
                    child: const Center(
                      child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              '${_currentImageIndex + 1}/${items.length}',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        if (items.length > 1)
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                items.length,
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

  Widget _buildVideoItem(String url, int index) {
    if (!_videoControllers.containsKey(index)) {
      final controller = VideoPlayerController.networkUrl(Uri.parse(url));
      _videoControllers[index] = controller;
      controller.initialize().then((_) {
        if (mounted) setState(() {});
      });
    }
    final controller = _videoControllers[index];
    if (controller == null || !controller.value.isInitialized) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }
    return GestureDetector(
      onTap: () {
        setState(() {
          controller.value.isPlaying ? controller.pause() : controller.play();
        });
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: VideoPlayer(controller),
          ),
          if (!controller.value.isPlaying)
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.play_arrow, color: Colors.white, size: 50),
              ),
            ),
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.videocam, color: Colors.white, size: 14),
                  SizedBox(width: 4),
                  Text('فيديو', style: TextStyle(color: Colors.white, fontSize: 11)),
                ],
              ),
            ),
          ),
        ],
      ),
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
                    borderRadius: BorderRadius.circular(12),
                  ),
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
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _waMsg(_item!.whatsapp, _item!.getTitle(ss.languageCode)),
            icon: const Icon(Icons.message, size: 18),
            label: const Text('استفسار اكثر عن الرحلة'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF128C7E),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ==================== شريط سفلي ====================

  Widget _buildBottomBar(SettingsService ss, bool isDark) {
    final hasSelection = _getTotalAttendees() > 0;
    final isEnded = _item?.isExpired ?? false;
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
            if (isEnded)
              Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.history, size: 18, color: Colors.grey),
                    SizedBox(width: 6),
                    Text(
                      'رحلة منتهية',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey),
                    ),
                  ],
                ),
              )
            else
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: hasSelection ? _goPayment : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: hasSelection ? widget.categoryColor : Colors.grey.shade400,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: hasSelection ? 2 : 0,
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.lock_clock, size: 18),
                      SizedBox(width: 6),
                      Text('احجز الآن', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
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
            child: const Icon(Icons.error_outline, size: 80, color: Colors.red),
          ),
          const SizedBox(height: 24),
          Text(
            _errorMessage ?? 'خطأ',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _loadItemDetails,
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.categoryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // ⭐⭐⭐ قسم التقييمات والمراجعات ⭐⭐⭐
  // ================================================================

  Widget _buildReviewsSection(SettingsService ss, bool isDark) {
    return Consumer<ReviewsProvider>(
      builder: (context, reviewsProvider, child) {
        final tripReviews = reviewsProvider.tripReviews;
        final avgRating = tripReviews.isNotEmpty
            ? reviewsProvider.getAverageRating()
            : 0.0;
        if (!_isReviewsLoaded && widget.itemId != 0) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _loadTripReviews();
          });
        }
        return Container(
          decoration: BoxDecoration(
            color: _bgColor(isDark),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? Colors.grey.shade700 : Colors.grey.shade200,
            ),
          ),
          child: Column(
            children: [
              // هيدر القسم (قابل للطي)
              GestureDetector(
                onTap: () => setState(() => _isReviewsSectionExpanded = !_isReviewsSectionExpanded),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey.shade800 : Colors.grey.shade50,
                    borderRadius: _isReviewsSectionExpanded
                        ? const BorderRadius.vertical(top: Radius.circular(16))
                        : BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Colors.amber, Colors.orange],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.star, color: Colors.white, size: 24),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'التقييمات والمراجعات',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: _textColor(isDark),
                              ),
                            ),
                            const SizedBox(height: 2),
                            _buildReviewsHeaderSubtitle(avgRating, tripReviews.length, isDark),
                          ],
                        ),
                      ),
                      AnimatedRotation(
                        turns: _isReviewsSectionExpanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        child: Icon(Icons.keyboard_arrow_down, color: Colors.amber, size: 28),
                      ),
                    ],
                  ),
                ),
              ),

              // المحتوى الموسع
              if (_isReviewsSectionExpanded) ...[
                const Divider(height: 1),

                if (tripReviews.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Icon(
                          Icons.rate_review_outlined,
                          size: 50,
                          color: isDark ? Colors.white24 : Colors.grey[300],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'لا توجد مراجعات بعد',
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark ? Colors.white54 : Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'كن أول من يضيف مراجعة',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.white38 : Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  SizedBox(
                    height: 240,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      physics: const BouncingScrollPhysics(),
                      itemCount: tripReviews.length,
                      itemBuilder: (context, index) {
                        final review = tripReviews[index];
                        return _buildReviewCard(
                          review: review,
                          ss: ss,
                          isDark: isDark,
                          cardIndex: index,
                        );
                      },
                    ),
                  ),

                const Divider(height: 24),

                // زر إضافة مراجعة
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: OutlinedButton.icon(
                      onPressed: () => _showAddReviewDialog(ss),
                      icon: const Icon(Icons.edit, size: 18),
                      label: const Text(
                        ' أضف مراجعة',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.amber.shade700,
                        side: BorderSide(color: Colors.amber.withOpacity(0.5)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ],
          ),
        );
      },
    );
  }

  // ==================== هيدر subtitle التقييمات ====================

  Widget _buildReviewsHeaderSubtitle(double avgRating, int totalReviews, bool isDark) {
    if (totalReviews == 0) {
      return Text(
        'لا توجد تقييمات بعد',
        style: TextStyle(
          fontSize: 12,
          color: isDark ? Colors.white54 : Colors.grey[600],
        ),
      );
    }
    return Row(
      children: [
        Row(
          children: List.generate(
            5,
                (i) => Icon(
              i < avgRating.round() ? Icons.star : Icons.star_border,
              color: Colors.amber,
              size: 14,
            ),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          avgRating.toStringAsFixed(1),
          style: TextStyle(
            fontSize: 13,
            color: Colors.amber.shade700,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '($totalReviews)',
          style: TextStyle(
            fontSize: 12,
            color: isDark ? Colors.white54 : Colors.grey[600],
          ),
        ),
      ],
    );
  }

  // ==================== كارد المراجعة الواحدة ====================

  Widget _buildReviewCard({
    required ReviewModel review,
    required SettingsService ss,
    required bool isDark,
    required int cardIndex,
  }) {
    if (!_reviewScrollControllers.containsKey(cardIndex)) {
      _reviewScrollControllers[cardIndex] = ScrollController();
    }
    final scrollController = _reviewScrollControllers[cardIndex]!;

    return Container(
      width: MediaQuery.of(context).size.width * 0.75,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade900 : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.3)
                : Colors.amber.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : Colors.amber.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // صف المستخدم والنجوم
            Row(
              children: [
                // الآڤاتار
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFC107), Color(0xFFFF9800)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.amber.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      review.reviewerName.isNotEmpty
                          ? review.reviewerName[0].toUpperCase()
                          : '?',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // الاسم والنجوم
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.reviewerName,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: List.generate(
                          5,
                              (index) => Icon(
                            index < review.rating ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // خط فاصل
            const SizedBox(height: 8),
            Container(
              height: 1,
              color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
            ),
            const SizedBox(height: 8),

            // التعليق (مع Scrollbar)
            if (review.comment.isNotEmpty)
              Expanded(
                child: Scrollbar(
                  controller: scrollController,
                  thumbVisibility: true,
                  trackVisibility: true,
                  thickness: 5,
                  radius: const Radius.circular(10),
                  interactive: true,
                  scrollbarOrientation: ScrollbarOrientation.left,
                  child: SingleChildScrollView(
                    controller: scrollController,
                    physics: const BouncingScrollPhysics(),
                    child: Text(
                      review.comment,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.4,
                        color: isDark ? Colors.white70 : Colors.grey[700],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ==================== تنسيق تاريخ المراجعة ====================

  String _formatReviewDate(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays == 0) return 'اليوم';
    if (diff.inDays == 1) return 'أمس';
    if (diff.inDays < 7) return '${diff.inDays} أيام';
    return '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';
  }

  // ==================== حوار إضافة مراجعة ====================

  void _showAddReviewDialog(SettingsService ss) {
    final authProvider = context.read<AuthProvider>();
    final reviewsProvider = context.read<ReviewsProvider>();
    final isLoggedIn = authProvider.isLoggedIn;

    final reviewNameController = TextEditingController(
      text: isLoggedIn ? (authProvider.currentUser?.name ?? '') : '',
    );
    int selectedRating = 5;
    final commentController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            final isDark = Theme.of(ctx).brightness == Brightness.dark;
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    '✏️ أضف مراجعة',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  if (!isLoggedIn)
                    TextField(
                      controller: reviewNameController,
                      decoration: InputDecoration(
                        labelText: 'اسمك',
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  if (!isLoggedIn) const SizedBox(height: 12),

                  Row(
                    children: [
                      const Text('تقييمك: '),
                      const SizedBox(width: 8),
                      ...List.generate(
                        5,
                            (index) => GestureDetector(
                          onTap: () => setModalState(() => selectedRating = index + 1),
                          child: Icon(
                            index < selectedRating ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                            size: 32,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  TextField(
                    controller: commentController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: 'تعليقك (اختياري)',
                      hintText: 'اكتب تجربتك مع الرحلة...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: reviewsProvider.isSubmitting
                          ? null
                          : () async {
                        if (!isLoggedIn && reviewNameController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(ctx).showSnackBar(
                            const SnackBar(
                              content: Text('الرجاء إدخال اسمك'),
                              backgroundColor: Colors.orange,
                            ),
                          );
                          return;
                        }

                        bool success;
                        if (isLoggedIn) {
                          success = await reviewsProvider.submitReviewLoggedIn(
                            rating: selectedRating,
                            comment: commentController.text.trim(),
                            itemId: widget.itemId,
                            token: authProvider.token!,
                          );
                        } else {
                          success = await reviewsProvider.submitReview(
                            reviewerName: reviewNameController.text.trim(),
                            rating: selectedRating,
                            comment: commentController.text.trim(),
                            itemId: widget.itemId,
                          );
                        }

                        if (success && ctx.mounted) {
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('تم إضافة المراجعة بنجاح 🎉'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } else if (ctx.mounted) {
                          ScaffoldMessenger.of(ctx).showSnackBar(
                            SnackBar(
                              content: Text(
                                reviewsProvider.errorMessage ?? 'فشل في إرسال المراجعة',
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                          reviewsProvider.clearError();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: reviewsProvider.isSubmitting
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                        'إرسال المراجعة',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }
}