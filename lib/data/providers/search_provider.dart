import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import '../models/item_model.dart';
import 'items_provider.dart';
import 'features_provider.dart';
import 'base_provider.dart';

class SearchProvider extends BaseProvider {
  // استخدام ItemModel بدلاً من PostModel
  List<ItemModel> _allItems = [];
  List<ItemModel> _searchResults = [];

  // للإقتراحات
  List<String> _suggestedTitles = [];
  List<String> _suggestedCities = [];
  List<String> _suggestedSeasons = [];

  String _lastSearchQuery = '';
  String _selectedFilter = 'الكل';

  // Getters
  List<ItemModel> get searchResults => _searchResults;
  List<String> get suggestedTitles => _suggestedTitles;
  List<String> get suggestedCities => _suggestedCities;
  List<String> get suggestedSeasons => _suggestedSeasons;
  String get selectedFilter => _selectedFilter;

  static const List<String> predefinedSeasons = [
    'عيد الفطر',
    'إجازة الحج 1',
    'إجازة الحج 2',
    'الصيف',
    'الشتاء',
    'الربيع',
    'الخريف',
    'رأس السنة',
    'الإجازة المدرسية',
  ];

  // تحميل جميع العناصر من API
  Future<void> loadAllItems() async {
    startLoading();

    try {
      // نجيب البيانات من ItemsProvider
      final itemsProvider = ItemsProvider();
      await itemsProvider.fetchItems();
      _allItems = itemsProvider.items;

      // نجيب البيانات من FeaturesProvider
      final featuresProvider = FeaturesProvider();
      await featuresProvider.fetchFeatures();
      _allItems.addAll(featuresProvider.features);

      _extractSuggestions();
      developer.log('Search index ready: ${_allItems.length} items', name: BaseProvider.logTag);
    } catch (e) {
      developer.log('Error loading items for search: $e', name: BaseProvider.logTag, level: 1000);
      setError('حدث خطأ في تحميل البيانات');
    } finally {
      stopLoading();
    }
  }

  // استخراج الإقتراحات من العناصر
  void _extractSuggestions() {
    final Set<String> titles = {};
    final Set<String> cities = {};
    final Set<String> seasons = {};

    for (var item in _allItems) {
      if (item.getTitle('ar').isNotEmpty) titles.add(item.getTitle('ar'));
      if (item.getTitle('en').isNotEmpty) titles.add(item.getTitle('en'));

      // نضيف اسم القسم كمدينة (لأنه ممكن يكون مقصد)
      cities.add(item.itemType.getTitle('ar'));
      cities.add(item.itemType.getTitle('en'));

      if (item.season.isNotEmpty) seasons.add(item.season);
    }

    seasons.addAll(predefinedSeasons);

    _suggestedTitles = titles.toList()..sort();
    _suggestedCities = cities.toList()..sort();
    _suggestedSeasons = seasons.toList()..sort();
  }

  // دالة البحث
  void search(String query, BuildContext context) {
    _lastSearchQuery = query;

    if (query.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }

    final lowercaseQuery = query.toLowerCase();

    _searchResults = _allItems.where((item) {
      switch (_selectedFilter) {
        case 'الرحلات':
          return _matchesTitle(item, lowercaseQuery) ||
              _matchesDescription(item, lowercaseQuery, context);
        case 'المدن':
          return _matchesCity(item, lowercaseQuery, context);
        case 'المواسم':
          return _matchesSeason(item, lowercaseQuery, context);
        case 'التواريخ':
          return _matchesDate(item, lowercaseQuery);
        default: // الكل
          return _matchesTitle(item, lowercaseQuery) ||
              _matchesDescription(item, lowercaseQuery, context) ||
              _matchesCity(item, lowercaseQuery, context) ||
              _matchesSeason(item, lowercaseQuery, context) ||
              _matchesDate(item, lowercaseQuery);
      }
    }).toList();

    notifyListeners();
  }

  bool _matchesTitle(ItemModel item, String query) {
    return item.getTitle('ar').toLowerCase().contains(query) ||
        item.getTitle('en').toLowerCase().contains(query);
  }

  bool _matchesDescription(ItemModel item, String query, BuildContext context) {
    return item.getDescription('ar').toLowerCase().contains(query) ||
        item.getDescription('en').toLowerCase().contains(query) ||
        item.getShortDescription('ar').toLowerCase().contains(query) ||
        item.getShortDescription('en').toLowerCase().contains(query);
  }

  bool _matchesCity(ItemModel item, String query, BuildContext context) {
    return item.itemType.getTitle('ar').toLowerCase().contains(query) ||
        item.itemType.getTitle('en').toLowerCase().contains(query);
  }

  bool _matchesSeason(ItemModel item, String query, BuildContext context) {
    return item.season.toLowerCase().contains(query);
  }

  bool _matchesDate(ItemModel item, String query) {
    return item.startDate.toLowerCase().contains(query) ||
        item.endDate.toLowerCase().contains(query);
  }

  void setFilter(String filter, BuildContext context) {
    _selectedFilter = filter;
    if (_lastSearchQuery.isNotEmpty) {
      search(_lastSearchQuery, context);
    }
  }

  List<String> getSuggestionsForCurrentFilter(String query, BuildContext context) {
    if (query.isEmpty) return [];

    final lowercaseQuery = query.toLowerCase();

    switch (_selectedFilter) {
      case 'الرحلات':
        return _suggestedTitles
            .where((title) => title.toLowerCase().contains(lowercaseQuery))
            .take(5)
            .toList();
      case 'المدن':
        return _suggestedCities
            .where((city) => city.toLowerCase().contains(lowercaseQuery))
            .take(5)
            .toList();
      case 'المواسم':
        final suggestions = <String>{};
        suggestions.addAll(
            _suggestedSeasons
                .where((season) => season.toLowerCase().contains(lowercaseQuery))
                .take(3));
        suggestions.addAll(
            predefinedSeasons
                .where((season) => season.toLowerCase().contains(lowercaseQuery))
                .take(2));
        return suggestions.toList().take(5).toList();
      case 'التواريخ':
        return [];
      default: // الكل
        final suggestions = <String>{};
        suggestions.addAll(
            _suggestedTitles
                .where((title) => title.toLowerCase().contains(lowercaseQuery))
                .take(3));
        suggestions.addAll(
            _suggestedCities
                .where((city) => city.toLowerCase().contains(lowercaseQuery))
                .take(3));
        suggestions.addAll(
            _suggestedSeasons
                .where((season) => season.toLowerCase().contains(lowercaseQuery))
                .take(2));
        return suggestions.toList().take(5).toList();
    }
  }
}