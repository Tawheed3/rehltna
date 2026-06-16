import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/item_model.dart';
import '../../data/providers/features_provider.dart';
import '../../data/services/settings_service.dart';
import 'search_screen.dart';
import '../posts/item_details_screen.dart';

class SpecialOffersScreen extends StatefulWidget {
  const SpecialOffersScreen({Key? key}) : super(key: key);

  @override
  State<SpecialOffersScreen> createState() => _SpecialOffersScreenState();
}

class _SpecialOffersScreenState extends State<SpecialOffersScreen> {
  final Color specialColor = Colors.orange;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final featuresProvider =
      Provider.of<FeaturesProvider>(context, listen: false);
      if (featuresProvider.features.isEmpty) {
        featuresProvider.fetchFeatures();
      }
    });
  }

  // ==================== الحصول على السعر المناسب للعرض ====================

  String _getDisplayPrice(ItemModel item) {
    if (item.prices.isEmpty) {
      return '${item.priceAfterDiscount.toStringAsFixed(0)} ريال';
    }

    final sortedPrices = List<PriceModel>.from(item.prices)
      ..sort((a, b) => b.effectivePrice.compareTo(a.effectivePrice));

    if (sortedPrices.length == 1) {
      return '${sortedPrices[0].effectivePrice.toStringAsFixed(0)} ريال';
    }

    return '${sortedPrices[1].effectivePrice.toStringAsFixed(0)} ريال';
  }

  // ==================== الواجهة الرئيسية ====================

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final settingsService = Provider.of<SettingsService>(context);
    final featuresProvider = Provider.of<FeaturesProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'عروض خاصة',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: specialColor,
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
        actions: [
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchScreen(),
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: () => featuresProvider.fetchFeatures(),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: featuresProvider.isLoading && featuresProvider.features.isEmpty
            ? _buildLoadingShimmer()
            : featuresProvider.errorMessage != null &&
            featuresProvider.features.isEmpty
            ? _buildErrorState(featuresProvider.errorMessage!)
            : featuresProvider.features.isEmpty
            ? _buildEmptyState(isDark)
            : RefreshIndicator(
          onRefresh: () => featuresProvider.fetchFeatures(),
          color: specialColor,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: featuresProvider.features.length,
            itemBuilder: (context, index) => _buildItemCard(
              featuresProvider.features[index],
              settingsService,
              isDark,
            ),
          ),
        ),
      ),
    );
  }

  // ==================== كارد الرحلة (نفس تنسيق subcategory بالظبط) ====================

  Widget _buildItemCard(
      ItemModel item,
      SettingsService settingsService,
      bool isDark,
      ) {
    final banner = item.getBanner(settingsService.languageCode);

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (c) => ItemDetailsScreen(
            itemId: item.id,
            categoryColor: specialColor,
          ),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey.shade900 : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: specialColor.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // 🖼️ صورة الرحلة
            ClipRRect(
              borderRadius:
              const BorderRadius.horizontal(left: Radius.circular(16)),
              child: Container(
                width: 100,
                height: 100,
                color: Colors.grey.shade200,
                child: banner.isNotEmpty
                    ? Image.network(
                  banner,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => Container(
                    color: Colors.grey.shade200,
                    child: const Icon(
                      Icons.broken_image,
                      color: Colors.grey,
                      size: 40,
                    ),
                  ),
                )
                    : Container(
                  color: Colors.grey.shade200,
                  child: const Icon(
                    Icons.image_not_supported,
                    color: Colors.grey,
                    size: 40,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // 📝 معلومات الرحلة
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 📛 اسم الرحلة + الموسم
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            item.getTitle(settingsService.languageCode),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // ✅ الموسم جنب اسم الرحلة
                        if (item.season.isNotEmpty) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.orange.withOpacity(0.3),
                              ),
                            ),
                            child: Text(
                              item.season,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Colors.orange,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),

                    // 📍 القسم
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 14, color: specialColor),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            item.itemType
                                .getTitle(settingsService.languageCode),
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark
                                  ? Colors.white70
                                  : Colors.grey[600],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // 💰 السعر + 🌙 عدد الليالي
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        // السعر
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: specialColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _getDisplayPrice(item),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: specialColor,
                            ),
                          ),
                        ),
                        // عدد الليالي
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${item.totalNights} ليالي',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
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
  }

  // ==================== شاشة تحميل ====================

  Widget _buildLoadingShimmer() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          height: 100,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(16),
          ),
        );
      },
    );
  }

  // ==================== مفيش عروض ====================

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: specialColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.local_offer, size: 80, color: Colors.orange),
          ),
          const SizedBox(height: 24),
          Text(
            'لا توجد عروض خاصة حالياً',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'ترقبوا العروض الجديدة قريباً',
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white54 : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Provider.of<FeaturesProvider>(context, listen: false)
                  .fetchFeatures();
            },
            icon: const Icon(Icons.refresh),
            label: const Text('تحديث'),
            style: ElevatedButton.styleFrom(
              backgroundColor: specialColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== خطأ ====================

  Widget _buildErrorState(String error) {
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
            child:
            const Icon(Icons.error_outline, size: 80, color: Colors.red),
          ),
          const SizedBox(height: 24),
          const Text(
            'حدث خطأ في تحميل العروض',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              error,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Provider.of<FeaturesProvider>(context, listen: false)
                  .fetchFeatures();
            },
            icon: const Icon(Icons.refresh),
            label: const Text('إعادة المحاولة'),
            style: ElevatedButton.styleFrom(
              backgroundColor: specialColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ),
          ),
        ],
      ),
    );
  }
}