import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/item_model.dart';
import '../../data/providers/items_provider.dart';
import '../../data/services/settings_service.dart';
import '../../widgets/app_error_widget.dart';
import '../../widgets/shimmer/item_card_shimmer.dart';
import '../posts/item_details_screen.dart';

class SubcategoryScreen extends StatefulWidget {
  final int categoryId;
  final String title;
  final Color color;

  const SubcategoryScreen({
    Key? key,
    required this.categoryId,
    required this.title,
    required this.color,
  }) : super(key: key);

  @override
  State<SubcategoryScreen> createState() => _SubcategoryScreenState();
}

class _SubcategoryScreenState extends State<SubcategoryScreen> {
  List<ItemModel> _items = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _loadFromCache());
  }

  void _loadFromCache() {
    if (!mounted) return;

    final itemsProvider = Provider.of<ItemsProvider>(context, listen: false);
    _items = itemsProvider.getItemsForSubcategory(widget.categoryId);

    developer.log('[SubcategoryScreen] Cache: ${_items.length} items for ${widget.title}', name: 'Response-output');

    if (mounted) {
      setState(() {
        _initialized = true;
        if (_items.isEmpty) {
          Future.microtask(() => _loadItemsFromAPI());
        }
      });
    }
  }

  Future<void> _loadItemsFromAPI() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final itemsProvider = Provider.of<ItemsProvider>(context, listen: false);
      _items = await itemsProvider.fetchItemsByCategory(widget.categoryId);
      developer.log('[SubcategoryScreen] API: ${_items.length} items for ${widget.title}', name: 'Response-output');
    } catch (e) {
      developer.log('[SubcategoryScreen] Error: $e', name: 'Response-output', level: 1000);
      if (mounted) setState(() => _errorMessage = 'حدث خطأ: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _refreshItems() async {
    await _loadItemsFromAPI();
  }

  // ==================== الحصول على السعر المناسب للعرض ====================

  /// ✅ لو فيه أكتر من سعر → يعرض السعر التاني
  /// ✅ لو فيه سعر واحد فقط → يعرضه عادي
  String _getDisplayPrice(ItemModel item) {
    if (item.prices.isEmpty) {
      // مفيش أسعار متعددة - نعرض السعر العادي
      return '${item.priceAfterDiscount.toStringAsFixed(0)} ريال';
    }

    // ترتيب الأسعار تنازلياً (من الأعلى للأقل)
    final sortedPrices = List<PriceModel>.from(item.prices)
      ..sort((a, b) => b.effectivePrice.compareTo(a.effectivePrice));

    if (sortedPrices.length == 1) {
      // سعر واحد فقط - نعرضه
      return '${sortedPrices[0].effectivePrice.toStringAsFixed(0)} ريال';
    }

    // فيه أكتر من سعر - نعرض السعر التاني (index = 1)
    return '${sortedPrices[1].effectivePrice.toStringAsFixed(0)} ريال';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final settingsService = Provider.of<SettingsService>(context);

    final appBar = AppBar(
      title: Text(widget.title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      backgroundColor: widget.color,
      elevation: 0,
      centerTitle: true,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
        child: IconButton(icon: const Icon(Icons.arrow_back_ios, size: 18, color: Colors.white), onPressed: () => Navigator.pop(context)),
      ),
    );

    if (!_initialized || _isLoading) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: appBar,
        body: const ItemListShimmer(),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: appBar,
      body: SafeArea(
        child: _errorMessage != null
            ? AppErrorWidget.server(
          message: _errorMessage,
          onRetry: _loadItemsFromAPI,
        )
            : _items.isEmpty
            ? AppErrorWidget.empty(message: 'لا توجد رحلات في هذا القسم')
            : RefreshIndicator(
          onRefresh: _refreshItems,
          color: widget.color,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _items.length,
            itemBuilder: (context, index) =>
                _buildItemCard(_items[index], settingsService, isDark),
          ),
        ),
      ),
    );
  }

  Widget _buildItemCard(ItemModel item, SettingsService settingsService, bool isDark) {
    final banner = item.getBanner(settingsService.languageCode);

    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => ItemDetailsScreen(itemId: item.id, categoryColor: widget.color))),
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
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
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
                    child: const Icon(Icons.broken_image, color: Colors.grey, size: 40),
                  ),
                )
                    : Container(
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.image_not_supported, color: Colors.grey, size: 40),
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
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 14, color: widget.color),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            item.itineraries.isNotEmpty
                                ? item.itineraries
                                    .map((it) => it.city.getTitle(settingsService.languageCode))
                                    .where((c) => c.isNotEmpty)
                                    .join(' - ')
                                : item.itemType.getTitle(settingsService.languageCode),
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? Colors.white70 : Colors.grey[600],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    if (item.startDate.isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Icon(Icons.calendar_today_outlined, size: 12, color: Colors.teal.shade400),
                          const SizedBox(width: 4),
                          Text(
                            _formatStartDate(item.startDate),
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? Colors.teal.shade200 : Colors.teal.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        // 💰 السعر (التاني لو فيه أكتر من سعر، أو السعر الوحيد)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: widget.color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _getDisplayPrice(item),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: widget.color,
                            ),
                          ),
                        ),
                        // 🌙 عدد الليالي
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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

  String _formatStartDate(String date) {
    try {
      final p = date.split('-');
      if (p.length == 3) {
        const months = ['', 'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو', 'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'];
        final m = int.tryParse(p[1]) ?? 0;
        return '${p[2]} ${months[m.clamp(0, 12)]}';
      }
    } catch (_) {}
    return date;
  }
}