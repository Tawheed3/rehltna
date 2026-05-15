import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/app_error_widget.dart';
import '../../widgets/shimmer/item_card_shimmer.dart';
import '../../core/localization/app_localizations.dart';
import '../../data/models/item_model.dart';
import '../../data/models/subcategory_item.dart';
import '../../data/providers/items_provider.dart';
import '../../data/services/settings_service.dart';
import 'subcategory_screen.dart';
import '../posts/item_details_screen.dart';

class CategoryScreen extends StatefulWidget {
  final String sectionId;
  final String title;
  final Color color;

  const CategoryScreen({
    Key? key,
    required this.sectionId,
    required this.title,
    required this.color,
  }) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  SubcategoryItem? _currentCategory;
  List<SubcategoryItem> _subcategories = [];
  List<ItemModel> _directItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _loadData());
  }

  // ==================== تحميل البيانات ====================

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    try {
      final itemsProvider = Provider.of<ItemsProvider>(context, listen: false);

      // ✅ لو البيانات موجودة، نستخدمها. لو مش موجودة، نعمل refresh
      if (itemsProvider.itemTypes.isEmpty) {
        await itemsProvider.fetchItemTypes();
      }

      final parentId = int.tryParse(widget.sectionId) ?? 0;
      _currentCategory = itemsProvider.getSubcategoryById(parentId);

      // ✅ جلب الأقسام الفرعية مرتبة حسب order
      _subcategories = itemsProvider.getSubcategoriesByParent(parentId);

      final allItems = itemsProvider.getItemsByType(parentId);

      Set<int> itemsInSubcategories = {};
      for (var subcat in _subcategories) {
        for (var item in subcat.items) {
          itemsInSubcategories.add(item.id);
        }
        for (var child in subcat.children) {
          for (var item in child.items) {
            itemsInSubcategories.add(item.id);
          }
        }
      }

      _directItems = allItems
          .where((item) => !itemsInSubcategories.contains(item.id))
          .toList();
    } catch (e) {
      developer.log('[CategoryScreen] Error: $e', name: 'Response-output', level: 1000);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // ==================== دوال مساعدة ====================

  int _getActualTotalItems() {
    if (_currentCategory == null) return 0;

    int total = _directItems.length;
    for (var subcat in _subcategories) {
      total += subcat.items.length;
      for (var child in subcat.children) {
        total += child.items.length;
      }
    }
    return total;
  }

  // ==================== بناء الواجهة ====================

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final settingsService = Provider.of<SettingsService>(context);
    final totalItemsCount = _getActualTotalItems();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: widget.color,
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
      ),
      body: SafeArea(
        child: _isLoading
            ? const ItemListShimmer()
            : (_subcategories.isEmpty && _directItems.isEmpty)
            ? AppErrorWidget.empty(message: 'لا توجد رحلات في هذا القسم')
            : RefreshIndicator(
          onRefresh: _loadData,
          color: widget.color,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // 📁 الأقسام الفرعية (مرتبة حسب order)
                if (_subcategories.isNotEmpty) ...[
                  _buildSectionTitle('الأقسام الفرعية', isDark),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: _subcategories.length,
                    itemBuilder: (context, index) {
                      final subcat = _subcategories[index];
                      return _buildSubcategoryCard(
                        subcat,
                        settingsService,
                        isDark,
                        index,
                      );
                    },
                  ),
                ],

                // 📋 الرحلات المباشرة
                if (_directItems.isNotEmpty) ...[
                  if (_subcategories.isNotEmpty)
                    _buildSectionTitle('رحلات مباشرة', isDark),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    itemCount: _directItems.length,
                    itemBuilder: (context, index) {
                      final item = _directItems[index];
                      return _buildDirectItemCard(
                        item,
                        settingsService,
                        isDark,
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }



  // ==================== عنوان القسم ====================

  Widget _buildSectionTitle(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              color: widget.color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: widget.color,
            ),
          ),
        ],
      ),
    );
  }

  // ==================== كارد القسم الفرعي ====================

  Widget _buildSubcategoryCard(
      SubcategoryItem subcat,
      SettingsService settingsService,
      bool isDark,
      int index,
      ) {
    final itemCount = subcat.items.length;
    final banner = subcat.banner ?? '';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SubcategoryScreen(
              categoryId: subcat.id,
              title: subcat.getTitle(settingsService.languageCode),
              color: widget.color,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? Colors.grey.shade900 : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: widget.color.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: widget.color.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🖼️ صورة القسم الفرعي
            ClipRRect(
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(16)),
              child: Container(
                height: 120,
                width: double.infinity,
                color: Colors.grey.shade200,
                child: banner.isNotEmpty
                    ? Image.network(
                  banner,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.broken_image,
                          color: Colors.grey, size: 40),
                    );
                  },
                )
                    : Container(
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.image_not_supported,
                      color: Colors.grey, size: 40),
                ),
              ),
            ),
            // 📝 معلومات القسم الفرعي
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 📛 اسم القسم الفرعي
                  Text(
                    subcat.getTitle(settingsService.languageCode),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // ✅ ترتيب القسم الفرعي
                  Row(
                    children: [
                      Icon(Icons.flight_takeoff,
                          size: 12, color: widget.color),
                      const SizedBox(width: 4),
                      Text(
                        '$itemCount رحلة',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.white70 : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== كارد الرحلة المباشرة ====================

  Widget _buildDirectItemCard(
      ItemModel item,
      SettingsService settingsService,
      bool isDark,
      ) {
    final banner = item.getBanner(settingsService.languageCode);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ItemDetailsScreen(
              itemId: item.id,
              categoryColor: widget.color,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey.shade900 : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: widget.color.withOpacity(0.1),
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
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.broken_image,
                          color: Colors.grey, size: 40),
                    );
                  },
                )
                    : Container(
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.image_not_supported,
                      color: Colors.grey, size: 40),
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
                    Text(
                      item.getTitle(settingsService.languageCode),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.location_on,
                            size: 14, color: widget.color),
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
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        // 💰 السعر
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: widget.color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${item.priceAfterDiscount.toStringAsFixed(0)} ريال',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: widget.color,
                            ),
                          ),
                        ),
                        // 🌙 عدد الليالي
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

}