import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:rehlaty/screens/home/search_screen.dart';
import 'package:rehlaty/screens/home/special_offers_screen.dart';
import 'package:rehlaty/screens/dashboard/admin_dashboard_screen.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/app_localizations.dart';
import '../../data/models/slider_model.dart';
import '../../data/models/item_model.dart';
import '../../data/models/subcategory_item.dart';
import '../../data/providers/items_provider.dart';
import '../../data/providers/slider_provider.dart';
import '../../data/providers/settings_provider.dart';
import '../../data/providers/auth_provider.dart';
import '../../data/providers/features_provider.dart';
import '../../data/services/settings_service.dart';
import '../../widgets/animations/pulse_animation.dart';
import '../../widgets/app_error_widget.dart';
import '../../widgets/shimmer/home_shimmer.dart';
import '../category/category_screen.dart';
import '../posts/item_details_screen.dart';

// ==================== HomeScreen ====================

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
  }

  // ==================== دوال مساعدة ====================

  Future<void> _launchURL(String url) async {
    if (url.isEmpty) return;
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
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

  // ==================== بناء الواجهة الرئيسية ====================

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final itemsProvider = context.watch<ItemsProvider>();
    final sliderProvider = context.watch<SliderProvider>();
    final settingsProvider = context.watch<SettingsProvider>();
    final settingsService = context.watch<SettingsService>();
    final authProvider = context.watch<AuthProvider>();
    final featuresProvider = context.watch<FeaturesProvider>();

    final isDark = settingsService.isDarkMode;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final mainCategories = itemsProvider.getMainCategories();
    final specialOffers = _getActiveSpecialOffers(featuresProvider.features);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildAppBar(
        settingsProvider, settingsService, isDark, localizations, authProvider,
      ),
      body: SafeArea(
        child: _buildBody(
          itemsProvider, sliderProvider, settingsProvider, settingsService,
          isDark, screenHeight, screenWidth, localizations, mainCategories, specialOffers,
        ),
      ),
    );
  }

  // ==================== App Bar ====================

  PreferredSizeWidget _buildAppBar(
      SettingsProvider sp, SettingsService ss, bool isDark,
      AppLocalizations loc, AuthProvider ap,
      ) {
    return AppBar(
      title: sp.settings != null
          ? Image.network(
        sp.settings!.getLogo(isDark), height: 40,
        errorBuilder: (c, e, s) => Text(
          sp.settings!.getSiteName(ss.languageCode),
          style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black),
        ),
      )
          : Text(
        loc.translate('home_title'),
        style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black),
      actions: [
        // ✅ أيقونة البروفايل
        Container(
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.person_outline, color: AppColors.primary),
            onPressed: () => context.push('/profile'),
          ),
        ),

        // 🔍 زر البحث
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
              MaterialPageRoute(builder: (c) => const SearchScreen()),
            ),
          ),
        ),

        // 📊 زر لوحة تحكم الأدمن
        if (ap.isAdmin)
          Container(
            margin: const EdgeInsets.only(right: 4),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.dashboard, color: Colors.red),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (c) => const AdminDashboardScreen()),
              ),
            ),
          ),

        // ⚙️ زر الإعدادات
        Container(
          margin: const EdgeInsets.only(right: 4),
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
      ItemsProvider ip, SliderProvider slp, SettingsProvider sp,
      SettingsService ss, bool isDark, double sh, double sw,
      AppLocalizations loc, List<SubcategoryItem> mainCategories,
      List<ItemModel> specialOffers,
      ) {
    if ((ip.isLoading && ip.itemTypes.isEmpty) ||
        (slp.isLoading && slp.sliders.isEmpty) ||
        (sp.isLoading && sp.settings == null)) {
      return const HomeShimmer();
    }
    if (ip.errorMessage != null && ip.itemTypes.isEmpty) {
      return AppErrorWidget.server(
        message: ip.errorMessage,
        onRetry: () {
          ip.loadAllItemsIntoCategories();
          slp.fetchSliders();
          sp.fetchSettings();
        },
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ip.loadAllItemsIntoCategories();
        await slp.fetchSliders();
        await sp.fetchSettings();
        await Provider.of<FeaturesProvider>(context, listen: false).fetchFeatures();
      },
      color: AppColors.primary,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildTickerBar(isDark),
          const SizedBox(height: 8),
          if (slp.sliders.isNotEmpty) _buildSliderRow(slp.sliders, ss, sh),
          const SizedBox(height: 8),
          if (specialOffers.isNotEmpty)
            _buildSection(
              context: context, title: loc.translate('special_offers'),
              items: specialOffers, settingsService: ss,
              screenHeight: sh, screenWidth: sw, localizations: loc,
              sectionId: 'special_offers', isSpecial: true,
              specialHeight: sh * 0.16, specialWidth: sw * 0.75,
            ),
          const SizedBox(height: 8),
          ...mainCategories.map((cat) {
            final catColor = _getColorForCategory(cat.id);
            final totalItems = ip.getTotalItemsForCategory(cat.id);
            return _buildCategoryBanner(
              context: context, title: cat.getTitle(ss.languageCode),
              categoryId: cat.id.toString(), secColor: catColor,
              totalItems: totalItems, isDark: isDark,
              bannerUrl: cat.banner,
            );
          }),
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
      color: isDark ? Colors.grey.shade900 : AppColors.primary.withOpacity(0.02),
      child: Row(
        children: [

          const SizedBox(width: 8),
          Expanded(child: _TickerText(items: tickerItems, isDark: isDark)),
        ],
      ),
    );
  }

  // ==================== السلايدر ====================

  Widget _buildSliderRow(List<SliderModel> sliders, SettingsService ss, double sh) {
    return SizedBox(
      height: sh * 0.22,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: sliders.length,
        itemBuilder: (context, index) {
          final slider = sliders[index];
          return GestureDetector(
            onTap: () {
              if (slider.link.isNotEmpty) _launchURL(slider.link);
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.85,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
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
                    Image.network(
                      slider.getBanner(ss.languageCode),
                      fit: BoxFit.cover,
                      errorBuilder: (c, e, s) => Container(
                        color: Colors.grey.shade300,
                        child: const Center(
                          child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black.withOpacity(0.6)],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 16, left: 16, right: 50,
                      child: Text(
                        slider.getTitle(ss.languageCode),
                        style: const TextStyle(
                          color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold,
                          shadows: [Shadow(color: Colors.black45, blurRadius: 8, offset: Offset(0, 2))],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Positioned(
                      bottom: 16, right: 16,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.arrow_forward, color: Colors.white, size: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
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
          Padding(
            padding: const EdgeInsets.only(bottom: 8, right: 4),
            child: Row(
              children: [
                Container(
                  width: 4, height: 22,
                  decoration: BoxDecoration(color: secColor, borderRadius: BorderRadius.circular(4)),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (c) => CategoryScreen(sectionId: categoryId, title: title, color: secColor),
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: secColor.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('عرض الكل', style: TextStyle(fontSize: 12, color: secColor, fontWeight: FontWeight.w600)),
                        const SizedBox(width: 4),
                        Icon(Icons.arrow_forward_ios, size: 10, color: secColor),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (c) => CategoryScreen(sectionId: categoryId, title: title, color: secColor),
              ),
            ),
            child: Container(
              width: double.infinity, height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: secColor.withOpacity(0.15), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (bannerUrl != null && bannerUrl.isNotEmpty)
                      Image.network(
                        bannerUrl, fit: BoxFit.cover,
                        errorBuilder: (c, e, s) => Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [secColor.withOpacity(0.3), secColor.withOpacity(0.1)],
                              begin: Alignment.topLeft, end: Alignment.bottomRight,
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              _getIconForCategory(int.tryParse(categoryId) ?? 0),
                              size: 60, color: secColor.withOpacity(0.5),
                            ),
                          ),
                        ),
                      )
                    else
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [secColor.withOpacity(0.3), secColor.withOpacity(0.1)],
                            begin: Alignment.topLeft, end: Alignment.bottomRight,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            _getIconForCategory(int.tryParse(categoryId) ?? 0),
                            size: 60, color: secColor.withOpacity(0.5),
                          ),
                        ),
                      ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter, end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0, left: 0, right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '$totalItems رحلة متاحة',
                                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.arrow_forward, color: Colors.white, size: 18),
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

  // ==================== قسم الرحلات ====================

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
    Color? sectionColor,
    int? totalItems,
  }) {
    final Color secColor = sectionColor ?? (isSpecial ? Colors.orange : AppColors.primary);
    final isDark = settingsService.isDarkMode;
    final containerHeight = isSpecial ? (specialHeight ?? screenHeight * 0.16) : screenHeight * 0.22;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Container(
                width: 6, height: 28,
                decoration: BoxDecoration(
                  color: secColor, borderRadius: BorderRadius.circular(8),
                  boxShadow: [BoxShadow(color: secColor.withOpacity(0.3), blurRadius: 8, spreadRadius: 1)],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: isSpecial
                    ? PulseAnimation(child: Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: secColor)))
                    : Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
              ),
              Container(
                decoration: BoxDecoration(color: secColor.withOpacity(0.1), borderRadius: BorderRadius.circular(30)),
                child: TextButton(
                  onPressed: isSpecial
                      ? () => Navigator.push(context, MaterialPageRoute(builder: (c) => const SpecialOffersScreen()))
                      : () => Navigator.push(context, MaterialPageRoute(builder: (c) => CategoryScreen(sectionId: sectionId, title: title, color: secColor))),
                  style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                  child: Row(
                    children: [
                      Text(localizations.translate('view_all'), style: TextStyle(color: secColor, fontSize: 14, fontWeight: FontWeight.w600)),
                      const SizedBox(width: 4),
                      Icon(Icons.arrow_forward_ios, color: secColor, size: 12),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: containerHeight,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: items.length,
            itemBuilder: (c, i) {
              final item = items[i];
              final Color cardColor = isSpecial ? Colors.orange : AppColors.primary;
              final itemHeight = isSpecial ? (specialHeight ?? screenHeight * 0.16) : screenHeight * 0.22;
              final itemWidth = isSpecial ? screenWidth * 0.75 : screenWidth * 0.9;

              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (c) => ItemDetailsScreen(itemId: item.id, categoryColor: cardColor)),
                ),
                child: Container(
                  width: itemWidth, margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: isDark ? Colors.grey.shade900 : Colors.white,
                    boxShadow: [BoxShadow(color: cardColor.withOpacity(0.1), blurRadius: 15, offset: const Offset(0, 5), spreadRadius: 2)],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.horizontal(left: Radius.circular(20)),
                        child: Container(
                          width: isSpecial ? itemWidth * 0.4 : screenWidth * 0.4,
                          height: itemHeight,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(item.getBanner(settingsService.languageCode)),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter, end: Alignment.bottomCenter,
                                colors: [Colors.transparent, Colors.black.withOpacity(0.3)],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                item.getTitle(settingsService.languageCode),
                                style: TextStyle(fontSize: isSpecial ? 14 : 16, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87),
                                maxLines: isSpecial ? 1 : 2, overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.location_on, size: isSpecial ? 12 : 14, color: cardColor),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      item.itemType.getTitle(settingsService.languageCode),
                                      style: TextStyle(fontSize: isSpecial ? 10 : 12, color: isDark ? Colors.white70 : Colors.grey.shade700),
                                      maxLines: 1, overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Wrap(
                                spacing: 6, runSpacing: 2,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                    decoration: BoxDecoration(color: cardColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                                    child: Text(item.getPriceDisplay(settingsService.languageCode), style: TextStyle(fontSize: isSpecial ? 10 : 12, fontWeight: FontWeight.bold, color: cardColor)),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                    decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.nightlight_round, size: isSpecial ? 10 : 12, color: Colors.green.shade700),
                                        const SizedBox(width: 2),
                                        Text('${item.totalNights} ليالي', style: TextStyle(fontSize: isSpecial ? 10 : 12, fontWeight: FontWeight.w500, color: Colors.green.shade700)),
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

  // ==================== الرحلات السابقة ====================

  Widget _buildPastTripsCard(BuildContext context, double sh, double sw, AppLocalizations loc) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GestureDetector(
        onTap: () => context.push('/past-trips'),
        child: Container(
          height: sh * 0.12, width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark ? [const Color(0xFF1a2634), const Color(0xFF2c3e50)] : [const Color(0xFF2C3E50), const Color(0xFF3498DB)],
              begin: Alignment.topLeft, end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: isDark ? Colors.black.withOpacity(0.3) : const Color(0xFF2C3E50).withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 5))],
          ),
          child: Row(
            children: [
              Container(
                width: sw * 0.2,
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: const BorderRadius.horizontal(left: Radius.circular(20))),
                child: const Icon(Icons.history_toggle_off, size: 40, color: Colors.white),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('الرحلات السابقة', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('استعرض الرحلات التي انتهت', style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 12)),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
                  child: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
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
  const _TickerText({Key? key, required this.items, required this.isDark}) : super(key: key);

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
    if (maxExtent <= 0) { _isScrolling = false; return; }
    _scrollController.animateTo(maxExtent, duration: const Duration(seconds: 25), curve: Curves.linear).then((_) {
      if (!mounted) return;
      _scrollController.jumpTo(0);
      _isScrolling = false;
      _startScroll();
    }).catchError((e) { _isScrolling = false; });
  }

  @override
  void dispose() { _isScrolling = false; _scrollController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal, controller: _scrollController, physics: const NeverScrollableScrollPhysics(),
      child: Row(children: [
        ...widget.items.map((item) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Text(item['icon'], style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 6),
            Text(item['text'], style: TextStyle(color: widget.isDark ? Colors.white : Colors.black87, fontSize: 13, fontWeight: FontWeight.w500)),
          ]),
        )),
        ...widget.items.map((item) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Text(item['icon'], style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 6),
            Text(item['text'], style: TextStyle(color: widget.isDark ? Colors.white : Colors.black87, fontSize: 13, fontWeight: FontWeight.w500)),
          ]),
        )),
      ]),
    );
  }
}