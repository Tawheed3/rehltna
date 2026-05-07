import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/localization/app_localizations.dart';
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

class _SearchScreenState extends State<SearchScreen> with SingleTickerProviderStateMixin {
  late final TextEditingController _searchController;
  late final FocusNode _focusNode;
  late final TabController _tabController;

  final List<String> _filters = ['الكل', 'الرحلات', 'المدن', 'المواسم', 'التواريخ'];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _focusNode = FocusNode();
    _tabController = TabController(length: 2, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final searchProvider = context.read<SearchProvider>();
        searchProvider.loadAllItems().then((_) {
          if (mounted) {
            _focusNode.requestFocus();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final settingsService = Provider.of<SettingsService>(context);

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
                    hintText: 'ابحث عن رحلة...',
                    hintStyle: TextStyle(
                      color: isDark ? Colors.white38 : Colors.grey[400],
                    ),
                    border: InputBorder.none,
                  ),
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  onChanged: (value) {
                    context.read<SearchProvider>().search(value, context);
                  },
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
          preferredSize: const Size.fromHeight(100),
          child: Column(
            children: [
              // أزرار التصفية
              SizedBox(
                height: 50,
                child: Consumer<SearchProvider>(
                  builder: (context, provider, child) {
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _filters.length,
                      itemBuilder: (context, index) {
                        final filter = _filters[index];
                        final isSelected = provider.selectedFilter == filter;

                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(filter),
                            selected: isSelected,
                            onSelected: (_) {
                              provider.setFilter(filter, context);
                            },
                            backgroundColor: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
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

              // Tabs للنتائج والاقتراحات
              TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'النتائج'),
                  Tab(text: 'الاقتراحات'),
                ],
                labelColor: AppColors.primary,
                unselectedLabelColor: isDark ? Colors.white54 : Colors.grey[600],
                indicatorColor: AppColors.primary,
              ),
            ],
          ),
        ),
      ),
      body:
      SafeArea(child:  Consumer<SearchProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.searchResults.isEmpty) {
            return const SearchShimmer();
          }

          if (provider.errorMessage != null && provider.searchResults.isEmpty) {
            return AppErrorWidget.network(
              onRetry: () => provider.loadAllItems(),
            );
          }

          return TabBarView(
            controller: _tabController,
            children: [
              // صفحة النتائج
              _buildResultsView(provider, isDark, settingsService, context),

              // صفحة الاقتراحات
              _buildSuggestionsView(provider, isDark, settingsService, context),
            ],
          );
        },
      ),
      )
    );
  }

  Widget _buildResultsView(SearchProvider provider, bool isDark, SettingsService settingsService, BuildContext context) {
    if (_searchController.text.isEmpty) {
      return _buildEmptyState(
        icon: Icons.search,
        message: 'ابحث عن رحلاتك المفضلة',
        isDark: isDark,
      );
    }

    if (provider.searchResults.isEmpty) {
      return _buildEmptyState(
        icon: Icons.sentiment_dissatisfied,
        message: 'لا توجد نتائج للبحث',
        subtitle: 'جرب كلمات بحث مختلفة',
        isDark: isDark,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: provider.searchResults.length,
      itemBuilder: (context, index) {
        final item = provider.searchResults[index];
        return _buildSearchResultCard(
          item: item,
          settingsService: settingsService,
          isDark: isDark,
          query: _searchController.text,
        );
      },
    );
  }

  Widget _buildSuggestionsView(SearchProvider provider, bool isDark, SettingsService settingsService, BuildContext context) {
    if (_searchController.text.isEmpty) {
      return _buildPopularSearches(provider, isDark, settingsService, context);
    }

    final suggestions = provider.getSuggestionsForCurrentFilter(_searchController.text, context);

    if (suggestions.isEmpty) {
      return _buildEmptyState(
        icon: Icons.lightbulb_outline,
        message: 'لا توجد اقتراحات',
        subtitle: 'اكمل الكتابة أو جرب فلتر آخر',
        isDark: isDark,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = suggestions[index];
        return ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getIconForSuggestion(suggestion),
              color: AppColors.primary,
              size: 20,
            ),
          ),
          title: Text(
            suggestion,
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          onTap: () {
            _searchController.text = suggestion;
            context.read<SearchProvider>().search(suggestion, context);
            _tabController.animateTo(0);
          },
        );
      },
    );
  }

  Widget _buildSearchResultCard({
    required ItemModel item,
    required SettingsService settingsService,
    required bool isDark,
    required String query,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ItemDetailsScreen(
              itemId: item.id,
              categoryColor: AppColors.primary,
            ),
          ),
        );
      },
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
            // الصورة
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(item.getBanner(settingsService.languageCode)),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // المعلومات
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
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 14, color: AppColors.primary),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            item.itemType.getTitle(settingsService.languageCode),
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
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${item.price.toStringAsFixed(0)} SAR',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
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

  Widget _buildPopularSearches(SearchProvider provider, bool isDark, SettingsService settingsService, BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'عمليات البحث الشائعة',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
          ),

          // المواسم الشائعة
          _buildSuggestionChips(
            title: 'المواسم',
            items: SearchProvider.predefinedSeasons,
            provider: provider,
            isDark: isDark,
            context: context,
            settingsService: settingsService,
          ),

          // المدن الشائعة (الأقسام)
          _buildSuggestionChips(
            title: 'الأقسام',
            items: provider.suggestedCities.take(8).toList(),
            provider: provider,
            isDark: isDark,
            context: context,
            settingsService: settingsService,
          ),

          // الرحلات الشائعة
          _buildSuggestionChips(
            title: 'الرحلات',
            items: provider.suggestedTitles.take(8).toList(),
            provider: provider,
            isDark: isDark,
            context: context,
            settingsService: settingsService,
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionChips({
    required String title,
    required List<String> items,
    required SearchProvider provider,
    required bool isDark,
    required BuildContext context,
    required SettingsService settingsService,
  }) {
    if (items.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white70 : Colors.grey[600],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: items.map((item) {
              return ActionChip(
                label: Text(item),
                onPressed: () {
                  _searchController.text = item;
                  provider.search(item, context);
                  _tabController.animateTo(0);
                },
                backgroundColor: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                labelStyle: TextStyle(
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String message,
    String? subtitle,
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
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white54 : Colors.grey[500],
              ),
            ),
          ],
        ],
      ),
    );
  }

  IconData _getIconForSuggestion(String suggestion) {
    if (SearchProvider.predefinedSeasons.contains(suggestion)) {
      return Icons.wb_sunny;
    }
    if (suggestion.contains('الحج') || suggestion.contains('Hajj')) {
      return Icons.mosque;
    }
    if (suggestion.contains('الفطر') || suggestion.contains('Eid')) {
      return Icons.celebration;
    }
    if (suggestion.contains('شنغن') || suggestion.contains('Visa')) {
      return Icons.credit_card;
    }
    if (suggestion.contains('كروز') || suggestion.contains('Cruise')) {
      return Icons.directions_boat;
    }
    return Icons.search;
  }
}