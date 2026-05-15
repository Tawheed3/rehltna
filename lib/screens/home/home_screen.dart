import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/app_localizations.dart';
import '../../data/models/slider_model.dart';
import '../../data/models/item_model.dart';
import '../../data/models/subcategory_item.dart';
import '../../data/models/review_model.dart';
import '../../data/providers/items_provider.dart';
import '../../data/providers/search_provider.dart';
import '../../data/providers/settings_provider.dart';
import '../../data/providers/auth_provider.dart';
import '../../data/providers/features_provider.dart';
import '../../data/providers/reviews_provider.dart';
import '../../data/services/settings_service.dart';
import '../../widgets/animations/pulse_animation.dart';
import '../../widgets/app_error_widget.dart';
import '../../widgets/shimmer/home_shimmer.dart';
import '../category/category_screen.dart';
import '../posts/item_details_screen.dart';
import 'search_screen.dart';
import 'special_offers_screen.dart';
import '../dashboard/admin_dashboard_screen.dart';

// ==================== HomeScreen ====================

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  // ==================== دورة الحياة ====================

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  // ==================== تحميل البيانات الأولية ====================

  Future<void> _loadInitialData() async {
    final itemsProvider = context.read<ItemsProvider>();
    final settingsProvider = context.read<SettingsProvider>();
    final featuresProvider = context.read<FeaturesProvider>();
    final reviewsProvider = context.read<ReviewsProvider>();
    final searchProvider = context.read<SearchProvider>();

    await Future.wait([
      itemsProvider.loadAllItemsIntoCategories(),
      settingsProvider.fetchSettings(),
      featuresProvider.fetchFeatures(),
      reviewsProvider.fetchAllReviews()
    ]);

    searchProvider.loadAllItems();
  }

  // ==================== دوال مساعدة ====================
  /// ✅ لو فيه أكتر من سعر → يعرض السعر التاني (أعلى سعر بعد الأكبر)
  /// ✅ لو فيه سعر واحد → يعرضه
  /// ✅ لو مفيش أسعار متعددة → يعرض السعر العادي
  String _getSecondPrice(ItemModel item) {
    if (item.prices.isEmpty) {
      return '${item.priceAfterDiscount.toStringAsFixed(0)} ريال';
    }

    final sortedPrices = List<PriceModel>.from(item.prices)
      ..sort((a, b) => b.effectivePrice.compareTo(a.effectivePrice));

    if (sortedPrices.length == 1) {
      return '${sortedPrices[0].effectivePrice.toStringAsFixed(0)} ريال';
    }

    // السعر التاني (index = 1)
    return '${sortedPrices[1].effectivePrice.toStringAsFixed(0)} ريال';
  }
  IconData _getIconForCategory(int id) {
    switch (id) {
      case 2: return Icons.credit_card;
      case 3: return Icons.school;
      case 4: return Icons.directions_boat;
      case 5: return Icons.people;
      default: return Icons.travel_explore;
    }
  }

  Color _getColorForCategory(int id) {
    switch (id) {
      case 2: return Colors.indigo;
      case 3: return Colors.purple;
      case 4: return Colors.teal;
      case 5: return Colors.blue;
      default: return AppColors.primary;
    }
  }

  List<ItemModel> _getActiveSpecialOffers(List<ItemModel> features) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return features.where((f) {
      try {
        if (f.endDate.isEmpty) return false;
        final end = DateTime.parse(f.endDate);
        return !DateTime(end.year, end.month, end.day).isBefore(today);
      } catch (e) {
        return true;
      }
    }).take(3).toList();
  }

  // ==================== الواجهة الرئيسية ====================

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final itemsProvider = context.watch<ItemsProvider>();
    final settingsProvider = context.watch<SettingsProvider>();
    final settingsService = context.watch<SettingsService>();

    final isDark = settingsService.isDarkMode;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final mainCategories = itemsProvider.getMainCategories();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildAppBar(
        settingsProvider,
        settingsService,
        isDark,
        localizations,
      ),
      body: SafeArea(
        child: _buildBody(
          itemsProvider,
          settingsProvider,
          settingsService,
          isDark,
          screenHeight,
          screenWidth,
          localizations,
          mainCategories,
        ),
      ),
    );
  }

  // ==================== App Bar ====================

  PreferredSizeWidget _buildAppBar(
      SettingsProvider sp,
      SettingsService ss,
      bool isDark,
      AppLocalizations loc,
      ) {
    return AppBar(
      title: sp.settings != null
          ? Image.network(
        sp.settings!.getLogo(isDark),
        height: 40,
        errorBuilder: (c, e, s) => Text(
          sp.settings!.getSiteName(ss.languageCode),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
      )
          : Text(
        loc.translate('home_title'),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white : Colors.black,
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(
        color: isDark ? Colors.white : Colors.black,
      ),

      // أيقونة البروفايل على اليسار
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: const Icon(Icons.person_outline, color: AppColors.primary),
          onPressed: () => context.push('/profile'),
        ),
      ),

      // الأيقونات على اليمين
      actions: [
        // لوحة تحكم الأدمن — Selector: only rebuilds this button when isAdmin changes
        Selector<AuthProvider, bool>(
          selector: (_, ap) => ap.isAdmin,
          builder: (_, isAdmin, __) {
            if (!isAdmin) return const SizedBox.shrink();
            return Container(
              margin: const EdgeInsets.only(right: 4),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.dashboard, color: Colors.red),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (c) => const AdminDashboardScreen(),
                  ),
                ),
              ),
            );
          },
        ),
        // زر البحث
        Container(
          margin: const EdgeInsets.only(right: 4),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.search, color: AppColors.primary),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (c) => const SearchScreen(),
              ),
            ),
          ),
        ),
        // زر الإعدادات
        Container(
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.settings_outlined, color: AppColors.primary),
            onPressed: () => context.push('/settings'),
          ),
        ),
      ],
    );
  }

  // ==================== محتوى الصفحة ====================

  Widget _buildBody(
      ItemsProvider ip,
      SettingsProvider sp,
      SettingsService ss,
      bool isDark,
      double sh,
      double sw,
      AppLocalizations loc,
      List<SubcategoryItem> mainCategories,
      ) {
    // عرض shimmer أثناء التحميل
    if ((ip.isLoading && ip.itemTypes.isEmpty) ||
        (sp.isLoading && sp.settings == null)) {
      return const HomeShimmer();
    }

    // عرض خطأ لو فيه مشكلة
    if (ip.errorMessage != null && ip.itemTypes.isEmpty) {
      return AppErrorWidget.server(
        message: ip.errorMessage,
        onRetry: () {
          ip.loadAllItemsIntoCategories();
          sp.fetchSettings();
        },
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ip.loadAllItemsIntoCategories();
        await sp.fetchSettings();
        await context.read<FeaturesProvider>().fetchFeatures();
        await context.read<ReviewsProvider>().fetchAllReviews();
      },
      color: AppColors.primary,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // الشريط المتحرك
          _buildTickerBar(isDark),
          const SizedBox(height: 8),

          // العروض الخاصة — Selector: only this section rebuilds when features load
          Selector<FeaturesProvider, List<ItemModel>>(
            selector: (_, fp) => _getActiveSpecialOffers(fp.features),
            builder: (_, specialOffers, __) {
              if (specialOffers.isEmpty) return const SizedBox.shrink();
              return _buildSection(
                context: context,
                title: loc.translate('special_offers'),
                items: specialOffers,
                settingsService: ss,
                screenHeight: sh,
                screenWidth: sw,
                localizations: loc,
                sectionId: 'special_offers',
                isSpecial: true,
                specialHeight: sh * 0.16,
                specialWidth: sw * 0.75,
              );
            },
          ),
          const SizedBox(height: 8),

          // الأقسام الرئيسية
          ...mainCategories.map((cat) {
            final catColor = _getColorForCategory(cat.id);
            final totalItems = ip.getTotalItemsForCategory(cat.id);
            return _buildCategoryBanner(
              context: context,
              title: cat.getTitle(ss.languageCode),
              categoryId: cat.id.toString(),
              secColor: catColor,
              totalItems: totalItems,
              isDark: isDark,
              bannerUrl: cat.banner,
            );
          }),

          // ⭐ آراء المسافرين
          _buildTravelerReviewsSection(
            ss: ss,
            isDark: isDark,
            sh: sh,
            sw: sw,
          ),

          // الرحلات السابقة
          _buildPastTripsCard(context, sh, sw, loc),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ==================== الشريط المتحرك ====================

  Widget _buildTickerBar(bool isDark) {
    final List<Map<String, dynamic>> tickerItems = [
      {'icon': '🏢', 'text': 'ترخيص وزارة السياحة : 73104015'},
      {'icon': '💍', 'text': 'عروض شهر العسل'},
      {'icon': '👨‍👩‍👧‍👦', 'text': 'برامج عائلية'},
      {'icon': '🏨', 'text': 'فنادق ومنتجعات'},
      {'icon': '🗺️', 'text': 'جولات سياحية'},
      {'icon': '✈️', 'text': 'رحلات سياحية'},
    ];

    return Container(
      height: 40,
      color: isDark
          ? Colors.grey.shade900
          : AppColors.primary.withOpacity(0.02),
      child: Row(
        children: [
          const SizedBox(width: 8),
          Expanded(
            child: _TickerText(
              items: tickerItems,
              isDark: isDark,
            ),
          ),
        ],
      ),
    );
  }

  // ==================== بانر القسم ====================

  Widget _buildCategoryBanner({
    required BuildContext context,
    required String title,
    required String categoryId,
    required Color secColor,
    required int totalItems,
    required bool isDark,
    String? bannerUrl,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // عنوان القسم + زر عرض الكل
          Padding(
            padding: const EdgeInsets.only(bottom: 8, right: 4),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 22,
                  decoration: BoxDecoration(
                    color: secColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (c) => CategoryScreen(
                        sectionId: categoryId,
                        title: title,
                        color: secColor,
                      ),
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: secColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'عرض الكل',
                          style: TextStyle(
                            fontSize: 12,
                            color: secColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 10,
                          color: secColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // صورة بانر القسم
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (c) => CategoryScreen(
                  sectionId: categoryId,
                  title: title,
                  color: secColor,
                ),
              ),
            ),
            child: Container(
              width: double.infinity,
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: secColor.withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // صورة البانر
                    if (bannerUrl != null && bannerUrl.isNotEmpty)
                      Image.network(
                        bannerUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) => Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                secColor.withOpacity(0.3),
                                secColor.withOpacity(0.1),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              _getIconForCategory(
                                int.tryParse(categoryId) ?? 0,
                              ),
                              size: 60,
                              color: secColor.withOpacity(0.5),
                            ),
                          ),
                        ),
                      )
                    else
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              secColor.withOpacity(0.3),
                              secColor.withOpacity(0.1),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            _getIconForCategory(
                              int.tryParse(categoryId) ?? 0,
                            ),
                            size: 60,
                            color: secColor.withOpacity(0.5),
                          ),
                        ),
                      ),

                    // تدرج داكن
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),

                    // عدد الرحلات + السهم
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '$totalItems رحلة متاحة',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== قسم الرحلات (عروض خاصة / أفقي) ====================

  Widget _buildSection({
    required BuildContext context,
    required String title,
    required List<ItemModel> items,
    required SettingsService settingsService,
    required double screenHeight,
    required double screenWidth,
    required AppLocalizations localizations,
    required String sectionId,
    bool isSpecial = false,
    double? specialHeight,
    double? specialWidth,
  }) {
    final Color secColor = isSpecial ? Colors.orange : AppColors.primary;
    final isDark = settingsService.isDarkMode;
    final containerHeight = isSpecial
        ? (specialHeight ?? screenHeight * 0.16)
        : screenHeight * 0.22;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // عنوان القسم
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Container(
                width: 6,
                height: 28,
                decoration: BoxDecoration(
                  color: secColor,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: secColor.withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: isSpecial
                    ? PulseAnimation(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: secColor,
                    ),
                  ),
                )
                    : Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ),
              // زر عرض الكل
              Container(
                decoration: BoxDecoration(
                  color: secColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextButton(
                  onPressed: isSpecial
                      ? () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (c) => const SpecialOffersScreen(),
                    ),
                  )
                      : () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (c) => CategoryScreen(
                        sectionId: sectionId,
                        title: title,
                        color: secColor,
                      ),
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Row(
                    children: [
                      Text(
                        localizations.translate('view_all'),
                        style: TextStyle(
                          color: secColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: secColor,
                        size: 12,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // قائمة أفقية
        SizedBox(
          height: containerHeight,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: items.length,
            itemBuilder: (c, i) {
              final item = items[i];
              final Color cardColor =
              isSpecial ? Colors.orange : AppColors.primary;

              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (c) => ItemDetailsScreen(
                      itemId: item.id,
                      categoryColor: cardColor,
                    ),
                  ),
                ),
                child: Container(
                  width: isSpecial ? screenWidth * 0.75 : screenWidth * 0.9,
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: isDark ? Colors.grey.shade900 : Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: cardColor.withOpacity(0.1),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // صورة الرحلة
                      ClipRRect(
                        borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(20),
                        ),
                        child: Container(
                          width: screenWidth * 0.4,
                          height: containerHeight,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                item.getBanner(
                                  settingsService.languageCode,
                                ),
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.3),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      // معلومات الرحلة
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // اسم الرحلة
                              Text(
                                item.getTitle(
                                  settingsService.languageCode,
                                ),
                                style: TextStyle(
                                  fontSize: isSpecial ? 14 : 16,
                                  fontWeight: FontWeight.bold,
                                  color: isDark
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                                maxLines: isSpecial ? 1 : 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),

                              // المدينة
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    size: isSpecial ? 12 : 14,
                                    color: cardColor,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      item.itemType.getTitle(
                                        settingsService.languageCode,
                                      ),
                                      style: TextStyle(
                                        fontSize: isSpecial ? 10 : 12,
                                        color: isDark
                                            ? Colors.white70
                                            : Colors.grey.shade700,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),

                              // السعر + عدد الليالي
                              Wrap(
                                spacing: 6,
                                runSpacing: 2,
                                children: [
                                  // السعر
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: cardColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      // ✅ السعر التاني (أعلى سعر بعد ترتيب تنازلي)
                                      _getSecondPrice(item),
                                      style: TextStyle(
                                        fontSize: isSpecial ? 10 : 12,
                                        fontWeight: FontWeight.bold,
                                        color: cardColor,
                                      ),
                                    ),
                                  ),
                                  // عدد الليالي
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.green.withOpacity(0.1),
                                      borderRadius:
                                      BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.nightlight_round,
                                          size: isSpecial ? 10 : 12,
                                          color: Colors.green.shade700,
                                        ),
                                        const SizedBox(width: 2),
                                        Text(
                                          '${item.totalNights} ليالي',
                                          style: TextStyle(
                                            fontSize: isSpecial ? 10 : 12,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.green.shade700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  // ================================================================
  // ⭐⭐⭐ قسم آراء المسافرين ⭐⭐⭐
  // ================================================================

  Widget _buildTravelerReviewsSection({
    required SettingsService ss,
    required bool isDark,
    required double sh,
    required double sw,
  }) {
    return Consumer<ReviewsProvider>(
      builder: (context, reviewsProvider, child) {
        final reviews = reviewsProvider.allReviews;
        final avgRating = reviews.isNotEmpty
            ? reviewsProvider.getAllReviewsAverageRating()
            : 0.0;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),

            // هيدر القسم
            _buildReviewsHeader(
              totalReviews: reviews.length,
              avgRating: avgRating,
              isDark: isDark,
            ),
            const SizedBox(height: 14),

            // لو مفيش مراجعات
            if (reviews.isEmpty)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey.shade900 : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark
                        ? Colors.grey.shade700
                        : Colors.amber.withOpacity(0.3),
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.rate_review_outlined,
                      size: 50,
                      color: isDark ? Colors.white24 : Colors.grey[300],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'لا توجد تقييمات بعد',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white70 : Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'كن أول من يشاركنا تقييمه',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? Colors.white54 : Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              )
            else
            // ✅ كل المراجعات في Horizontal Scroll
              SizedBox(
                height: sh * 0.18,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: reviews.length,
                  itemBuilder: (context, index) {
                    final review = reviews[index];
                    return _buildReviewCard(
                      review: review,
                      ss: ss,
                      isDark: isDark,
                      sw: sw,
                    );
                  },
                ),
              ),

            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  // ==================== هيدر قسم المراجعات ====================

  Widget _buildReviewsHeader({
    required int totalReviews,
    required double avgRating,
    required bool isDark,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // شريط التدرج
          Container(
            width: 6,
            height: 28,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.amber, Colors.orange],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.amber.withOpacity(0.3),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // العنوان + التقييم
          Expanded(
            child: Row(
              children: [
                Text(
                  '⭐ آراء المسافرين',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                if (totalReviews > 0) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.amber, Colors.orange],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.amber.withOpacity(0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.white,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          avgRating.toStringAsFixed(1),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          ' ($totalReviews)',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          // زر إضافة تقييم
          Consumer<ReviewsProvider>(
            builder: (context, provider, child) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  onPressed: provider.isSubmitting
                      ? null
                      : () => _showAddReviewFromHome(),
                  icon: provider.isSubmitting
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.amber,
                    ),
                  )
                      : const Icon(
                    Icons.add_comment_rounded,
                    color: Colors.amber,
                    size: 22,
                  ),
                  tooltip: 'أضف تقييمك',
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ==================== كارد المراجعة الواحدة ====================

  Widget _buildReviewCard({
    required ReviewModel review,
    required SettingsService ss,
    required bool isDark,
    required double sw,
  }) {
    return Container(
      width: sw * 0.62,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade900 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.2)
                : Colors.amber.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: isDark
              ? Colors.grey.shade700
              : Colors.amber.withOpacity(0.2),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // الآڤاتار + الاسم + النجوم
            Row(
              children: [
                // آڤاتار
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.amber.shade400,
                        Colors.orange.shade400,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      review.reviewerName.isNotEmpty
                          ? review.reviewerName[0].toUpperCase()
                          : '?',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                // الاسم + النجوم
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
                      const SizedBox(height: 2),
                      Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            index < review.rating
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                            size: 14,
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // التعليق (لو موجود)
            if (review.comment.isNotEmpty) ...[
              const SizedBox(height: 10),
              Expanded(
                child: Text(
                  review.comment,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white70 : Colors.grey[700],
                    height: 1.4,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],

            // اسم الرحلة (لو فيه رحلة مرتبطة)
            if (review.item != null)
              Container(
                margin: const EdgeInsets.only(top: 6),
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  review.item!.getTitle(ss.languageCode),
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ==================== حوار إضافة مراجعة ====================

  void _showAddReviewFromHome() {
    final authProvider = context.read<AuthProvider>();
    final reviewsProvider = context.read<ReviewsProvider>();
    final itemsProvider = context.read<ItemsProvider>();
    final ss = context.read<SettingsService>();
    final isLoggedIn = authProvider.isLoggedIn;

    final reviewNameController = TextEditingController(
      text: isLoggedIn ? (authProvider.currentUser?.name ?? '') : '',
    );
    int selectedRating = 5;
    final commentController = TextEditingController();

    final allItems = itemsProvider.getActiveItems();
    int? selectedItemId = null; // null = تقييم عام

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
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
                  // مقبض
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

                  // عنوان
                  const Text(
                    '✏️ أضف تقييمك',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // اختيار الرحلة (اختياري)
                  if (allItems.isNotEmpty) ...[
                    Text(
                      'اختر الرحلة (اختياري):',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white70 : Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<int?>(
                          value: selectedItemId,
                          isExpanded: true,
                          hint: Text(
                            'تقييم عام (بدون رحلة)',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 14,
                            ),
                          ),
                          items: [
                            const DropdownMenuItem<int?>(
                              value: null,
                              child: Text(
                                '⭐ تقييم عام (بدون رحلة)',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.amber,
                                ),
                              ),
                            ),
                            ...allItems.map((item) {
                              return DropdownMenuItem<int?>(
                                value: item.id,
                                child: Text(
                                  item.getTitle(ss.languageCode),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isDark
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }),
                          ],
                          onChanged: (value) {
                            setModalState(() {
                              selectedItemId = value;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // اسم المستخدم (لغير المسجلين)
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

                  // التقييم بالنجوم
                  Row(
                    children: [
                      const Text('تقييمك: '),
                      const SizedBox(width: 8),
                      ...List.generate(5, (index) {
                        return GestureDetector(
                          onTap: () {
                            setModalState(
                                  () => selectedRating = index + 1,
                            );
                          },
                          child: Icon(
                            index < selectedRating
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                            size: 32,
                          ),
                        );
                      }),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // التعليق (اختياري)
                  TextField(
                    controller: commentController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: 'تعليقك (اختياري)',
                      hintText: 'اكتب تجربتك معنا...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // زر الإرسال
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: reviewsProvider.isSubmitting
                          ? null
                          : () async {
                        // التحقق من الاسم لغير المسجلين
                        if (!isLoggedIn &&
                            reviewNameController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(ctx).showSnackBar(
                            const SnackBar(
                              content:
                              Text('الرجاء إدخال اسمك'),
                              backgroundColor: Colors.orange,
                            ),
                          );
                          return;
                        }

                        bool success;
                        if (isLoggedIn) {
                          success = await reviewsProvider
                              .submitReviewLoggedIn(
                            rating: selectedRating,
                            comment:
                            commentController.text.trim(),
                            itemId: selectedItemId,
                            token: authProvider.token!,
                          );
                        } else {
                          success =
                          await reviewsProvider.submitReview(
                            reviewerName: reviewNameController
                                .text
                                .trim(),
                            rating: selectedRating,
                            comment:
                            commentController.text.trim(),
                            itemId: selectedItemId,
                          );
                        }

                        if (success && ctx.mounted) {
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'تم إضافة التقييم بنجاح 🎉',
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } else if (ctx.mounted) {
                          ScaffoldMessenger.of(ctx).showSnackBar(
                            SnackBar(
                              content: Text(
                                reviewsProvider.errorMessage ??
                                    'فشل في إرسال التقييم',
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
                          ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                          : const Text(
                        'إرسال التقييم',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ==================== الرحلات السابقة ====================

  Widget _buildPastTripsCard(
      BuildContext context,
      double sh,
      double sw,
      AppLocalizations loc,
      ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GestureDetector(
        onTap: () => context.push('/past-trips'),
        child: Container(
          height: sh * 0.12,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [
                const Color(0xFF1a2634),
                const Color(0xFF2c3e50),
              ]
                  : [
                const Color(0xFF2C3E50),
                const Color(0xFF3498DB),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withOpacity(0.3)
                    : const Color(0xFF2C3E50).withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              // أيقونة
              Container(
                width: sw * 0.2,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(20),
                  ),
                ),
                child: const Icon(
                  Icons.history_toggle_off,
                  size: 40,
                  color: Colors.white,
                ),
              ),

              // النص
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'الرحلات السابقة',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'استعرض الرحلات التي انتهت',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // سهم
              Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== الشريط المتحرك ====================

class _TickerText extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  final bool isDark;

  const _TickerText({
    Key? key,
    required this.items,
    required this.isDark,
  }) : super(key: key);

  @override
  State<_TickerText> createState() => _TickerTextState();
}

class _TickerTextState extends State<_TickerText> {
  late ScrollController _scrollController;
  bool _isScrolling = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startScroll());
  }

  void _startScroll() {
    if (_isScrolling || !mounted) return;
    if (!_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) _startScroll();
      });
      return;
    }
    _isScrolling = true;
    final maxExtent = _scrollController.position.maxScrollExtent;
    if (maxExtent <= 0) {
      _isScrolling = false;
      return;
    }
    _scrollController
        .animateTo(
      maxExtent,
      duration: const Duration(seconds: 25),
      curve: Curves.linear,
    )
        .then((_) {
      if (!mounted) return;
      _scrollController.jumpTo(0);
      _isScrolling = false;
      _startScroll();
    }).catchError((e) {
      _isScrolling = false;
    });
  }

  @override
  void dispose() {
    _isScrolling = false;
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: _scrollController,
      physics: const NeverScrollableScrollPhysics(),
      child: Row(
        children: [
          ...widget.items.map((item) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  item['icon'],
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(width: 6),
                Text(
                  item['text'],
                  style: TextStyle(
                    color: widget.isDark
                        ? Colors.white
                        : Colors.black87,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          )),
          ...widget.items.map((item) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  item['icon'],
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(width: 6),
                Text(
                  item['text'],
                  style: TextStyle(
                    color: widget.isDark
                        ? Colors.white
                        : Colors.black87,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}