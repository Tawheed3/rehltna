import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../data/models/item_model.dart';
import '../../data/providers/search_provider.dart';
import '../../data/services/settings_service.dart';
import '../../widgets/app_error_widget.dart';
import '../../widgets/shimmer/search_shimmer.dart';
import '../posts/item_details_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final TextEditingController _searchController;
  late final FocusNode _focusNode;

  final List<String> _filters = [
    'الكل',
    'الرحلات',
    'المدن',
    'المواسم',
    'شهر و سنة'  // ✅ تغيير الاسم
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _focusNode = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final searchProvider = context.read<SearchProvider>();
        if (searchProvider.suggestedTitlesAr.isEmpty) {
          searchProvider.loadAllItems().then((_) {
            if (mounted) _focusNode.requestFocus();
          });
        } else {
          _focusNode.requestFocus();
        }
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _selectFilterAndShowAll(String filter) {
    final searchProvider = context.read<SearchProvider>();
    final langCode = context.read<SettingsService>().languageCode;

    // ✅ تحويل "شهر و سنة" إلى "التواريخ" عشان الـ provider يفهمها
    final providerFilter = filter == 'شهر و سنة' ? 'التواريخ' : filter;

    searchProvider.setFilter(providerFilter, context);
    searchProvider.showAllForFilter(providerFilter, langCode);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final settingsService = Provider.of<SettingsService>(context);
    final langCode = settingsService.languageCode;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: isDark ? Colors.white : AppColors.primary,
              size: 18,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Container(
          height: 50,
          decoration: BoxDecoration(
            color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
            ),
          ),
          child: Row(
            children: [
              const SizedBox(width: 16),
              Icon(
                Icons.search,
                color: isDark ? Colors.white54 : AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  focusNode: _focusNode,
                  decoration: InputDecoration(
                    hintText: langCode == 'ar'
                        ? 'ابحث عن رحلة، مدينة، موسم...'
                        : 'Search...',
                    hintStyle: TextStyle(
                      color: isDark ? Colors.white38 : Colors.grey[400],
                    ),
                    border: InputBorder.none,
                  ),
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  onChanged: (value) =>
                      context.read<SearchProvider>().search(value, context),
                ),
              ),
              if (_searchController.text.isNotEmpty)
                IconButton(
                  icon: Icon(
                    Icons.clear,
                    size: 20,
                    color: isDark ? Colors.white54 : Colors.grey[600],
                  ),
                  onPressed: () {
                    _searchController.clear();
                    context.read<SearchProvider>().search('', context);
                  },
                ),
            ],
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: SizedBox(
            height: 50,
            child: Consumer<SearchProvider>(
              builder: (context, provider, child) {
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _filters.length,
                  itemBuilder: (context, index) {
                    final filter = _filters[index];
                    // ✅ مقارنة الفلتر المعروض مع المختار
                    final providerFilter =
                    filter == 'شهر و سنة' ? 'التواريخ' : filter;
                    final isSelected =
                        provider.selectedFilter == providerFilter;

                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(filter),
                        selected: isSelected,
                        onSelected: (_) => _selectFilterAndShowAll(filter),
                        backgroundColor: isDark
                            ? Colors.grey.shade800
                            : Colors.grey.shade100,
                        selectedColor: AppColors.primary,
                        labelStyle: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : (isDark ? Colors.white70 : Colors.black87),
                        ),
                        checkmarkColor: Colors.white,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Consumer<SearchProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) return const SearchShimmer();

            return _buildResultsView(
              provider,
              isDark,
              settingsService,
              langCode,
              context,
            );
          },
        ),
      ),
    );
  }

  // ==================== النتائج ====================

  Widget _buildResultsView(
      SearchProvider provider,
      bool isDark,
      SettingsService ss,
      String langCode,
      BuildContext context,
      ) {
    // ✅ لو عارض قائمة فلتر
    if (provider.showFilteredList) {
      return _buildFilteredListView(provider, isDark, langCode, context);
    }

    // ✅ لو مفيش نص والفلتر "الكل"
    if (_searchController.text.isEmpty &&
        provider.selectedFilter == 'الكل') {
      return _buildAllFiltersView(provider, isDark, langCode, context);
    }

    // ✅ لو مفيش نتائج
    if (provider.searchResults.isEmpty) {
      return _buildEmptyState(
        icon: Icons.sentiment_dissatisfied,
        message: langCode == 'ar' ? 'لا توجد نتائج' : 'No results',
        isDark: isDark,
      );
    }

    // ✅ عرض نتائج البحث (رحلات)
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Text(
            langCode == 'ar'
                ? '${provider.searchResults.length} نتيجة'
                : '${provider.searchResults.length} results',
            style: TextStyle(
              fontSize: 13,
              color: isDark ? Colors.white54 : Colors.grey[600],
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: provider.searchResults.length,
            itemBuilder: (context, index) => _buildSearchResultCard(
              item: provider.searchResults[index],
              settingsService: ss,
              isDark: isDark,
            ),
          ),
        ),
      ],
    );
  }

  // ==================== عرض كل الفلاتر ====================

  Widget _buildAllFiltersView(
      SearchProvider provider,
      bool isDark,
      String langCode,
      BuildContext context,
      ) {
    final titles = provider.getSuggestedTitles(langCode);
    final cities = provider.getSuggestedCities(langCode);
    final dates = provider.suggestedDates;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ المواسم
          if (provider.suggestedSeasons.isNotEmpty)
            _buildFilterSection(
              title: langCode == 'ar' ? 'المواسم' : 'Seasons',
              items: provider.suggestedSeasons,
              icon: Icons.wb_sunny,
              iconColor: Colors.orange,
              isDark: isDark,
              onTap: (s) {
                _searchController.text = s;
                provider.search(s, context);
              },
            ),

          // ✅ المدن والأقسام
          if (cities.isNotEmpty)
            _buildFilterSection(
              title:
              langCode == 'ar' ? 'المدن والأقسام' : 'Cities & Sections',
              items: cities,
              icon: Icons.location_city,
              iconColor: AppColors.primary,
              isDark: isDark,
              onTap: (s) {
                _searchController.text = s;
                provider.search(s, context);
              },
            ),

          // ✅ شهر و سنة
          if (dates.isNotEmpty)
            _buildFilterSection(
              title: langCode == 'ar' ? 'شهر و سنة' : 'Month & Year',
              items: dates,
              icon: Icons.calendar_month,
              iconColor: Colors.teal,
              isDark: isDark,
              onTap: (s) {
                _searchController.text = s;
                provider.search(s, context);
              },
            ),

          // ✅ الرحلات
          if (titles.isNotEmpty)
            _buildFilterSection(
              title: langCode == 'ar' ? 'الرحلات' : 'Trips',
              items: titles,
              icon: Icons.flight_takeoff,
              iconColor: Colors.green,
              isDark: isDark,
              onTap: (s) {
                _searchController.text = s;
                provider.search(s, context);
              },
            ),
        ],
      ),
    );
  }

  // ==================== قسم فلتر واحد ====================

  Widget _buildFilterSection({
    required String title,
    required List<String> items,
    required IconData icon,
    required Color iconColor,
    required bool isDark,
    required Function(String) onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 22,
                decoration: BoxDecoration(
                  color: iconColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '$title (${items.length})',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: items.map((item) {
              return ActionChip(
                avatar: Icon(icon, size: 16, color: iconColor),
                label: Text(
                  item,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),
                onPressed: () => onTap(item),
                backgroundColor:
                isDark ? Colors.grey.shade800 : Colors.grey.shade100,
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  // ==================== قائمة الفلتر ====================

  Widget _buildFilteredListView(
      SearchProvider provider,
      bool isDark,
      String langCode,
      BuildContext context,
      ) {
    final items = provider.filteredList;
    final title = provider.listTitle;

    IconData icon;
    switch (provider.selectedFilter) {
      case 'الرحلات':
        icon = Icons.flight_takeoff;
        break;
      case 'المدن':
        icon = Icons.location_city;
        break;
      case 'المواسم':
        icon = Icons.wb_sunny;
        break;
      case 'التواريخ':
        icon = Icons.calendar_month;
        break;
      default:
        icon = Icons.search;
    }

    if (items.isEmpty)
      return _buildEmptyState(
          icon: icon, message: 'لا توجد عناصر', isDark: isDark);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Row(
            children: [
              Icon(icon, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                '$title (${items.length})',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              IconData itemIcon = icon;
              if (item.startsWith('📅')) itemIcon = Icons.calendar_today;
              if (item.startsWith('🕌')) itemIcon = Icons.mosque;
              if (item.startsWith('📆')) itemIcon = Icons.date_range;
              final searchText =
              item.replaceAll(RegExp(r'[📅🕌📆]\s*'), '');

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey.shade800 : Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isDark
                        ? Colors.grey.shade700
                        : Colors.grey.shade200,
                  ),
                ),
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(itemIcon, color: AppColors.primary, size: 22),
                  ),
                  title: Text(
                    item,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: isDark ? Colors.white38 : Colors.grey[400],
                  ),
                  onTap: () {
                    _searchController.text = searchText;
                    context
                        .read<SearchProvider>()
                        .search(searchText, context);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ==================== كارد نتيجة البحث ====================

  Widget _buildSearchResultCard({
    required ItemModel item,
    required SettingsService settingsService,
    required bool isDark,
  }) {
    final banner = item.getBanner(settingsService.languageCode);
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ItemDetailsScreen(
            itemId: item.id,
            categoryColor: AppColors.primary,
          ),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey.shade900 : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isDark
              ? [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ]
              : AppDimensions.cardShadow,
        ),
        child: Row(
          children: [
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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 14,
                          color: AppColors.primary,
                        ),
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
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${item.priceAfterDiscount.toStringAsFixed(0)} ريال',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
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

  // ==================== حالة فاضية ====================

  Widget _buildEmptyState({
    required IconData icon,
    required String message,
    required bool isDark,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 60,
              color: isDark ? Colors.white24 : Colors.grey[400],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white70 : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}