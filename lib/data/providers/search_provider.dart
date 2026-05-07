import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import '../models/item_model.dart';
import 'items_provider.dart';
import 'features_provider.dart';
import 'base_provider.dart';

class SearchProvider extends BaseProvider {
  final ItemsProvider _itemsProvider;
  final FeaturesProvider _featuresProvider;

  SearchProvider({
    required ItemsProvider itemsProvider,
    required FeaturesProvider featuresProvider,
  })  : _itemsProvider = itemsProvider,
        _featuresProvider = featuresProvider;

  List<ItemModel> _allItems = [];
  List<ItemModel> _searchResults = [];

  List<String> _suggestedTitles = [];
  List<String> _suggestedCities = [];
  List<String> _suggestedSeasons = [];

  String _lastSearchQuery = '';
  String _selectedFilter = 'الكل';

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

  /// Uses already-loaded provider data — no duplicate API calls.
  Future<void> loadAllItems() async {
    startLoading();
    try {
      // Use cached items; fetch only if empty
      if (_itemsProvider.items.isNotEmpty) {
        _allItems = List.from(_itemsProvider.items);
      } else {
        await _itemsProvider.fetchItems();
        _allItems = List.from(_itemsProvider.items);
      }

      // Same for features
      if (_featuresProvider.features.isNotEmpty) {
        _allItems.addAll(_featuresProvider.features);
      } else {
        await _featuresProvider.fetchFeatures();
        _allItems.addAll(_featuresProvider.features);
      }

      _extractSuggestions();
      developer.log('Search index ready: ${_allItems.length} items', name: BaseProvider.logTag);
    } catch (e) {
      developer.log('Error loading items for search: $e', name: BaseProvider.logTag, level: 1000);
      setError('حدث خطأ في تحميل البيانات');
    } finally {
      stopLoading();
    }
  }

  void _extractSuggestions() {
    final Set<String> titles = {};
    final Set<String> cities = {};
    final Set<String> seasons = {};

    for (var item in _allItems) {
      if (item.getTitle('ar').isNotEmpty) titles.add(item.getTitle('ar'));
      if (item.getTitle('en').isNotEmpty) titles.add(item.getTitle('en'));
      cities.add(item.itemType.getTitle('ar'));
      cities.add(item.itemType.getTitle('en'));
      if (item.season.isNotEmpty) seasons.add(item.season);
    }

    seasons.addAll(predefinedSeasons);

    _suggestedTitles = titles.toList()..sort();
    _suggestedCities = cities.toList()..sort();
    _suggestedSeasons = seasons.toList()..sort();
  }

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
          return _matchesTitle(item, lowercaseQuery) || _matchesDescription(item, lowercaseQuery);
        case 'المدن':
          return _matchesCity(item, lowercaseQuery);
        case 'المواسم':
          return _matchesSeason(item, lowercaseQuery);
        case 'التواريخ':
          return _matchesDate(item, lowercaseQuery);
        default:
          return _matchesTitle(item, lowercaseQuery) ||
              _matchesDescription(item, lowercaseQuery) ||
              _matchesCity(item, lowercaseQuery) ||
              _matchesSeason(item, lowercaseQuery) ||
              _matchesDate(item, lowercaseQuery);
      }
    }).toList();

    notifyListeners();
  }

  bool _matchesTitle(ItemModel item, String query) =>
      item.getTitle('ar').toLowerCase().contains(query) ||
      item.getTitle('en').toLowerCase().contains(query);

  bool _matchesDescription(ItemModel item, String query) =>
      item.getDescription('ar').toLowerCase().contains(query) ||
      item.getDescription('en').toLowerCase().contains(query) ||
      item.getShortDescription('ar').toLowerCase().contains(query) ||
      item.getShortDescription('en').toLowerCase().contains(query);

  bool _matchesCity(ItemModel item, String query) =>
      item.itemType.getTitle('ar').toLowerCase().contains(query) ||
      item.itemType.getTitle('en').toLowerCase().contains(query);

  bool _matchesSeason(ItemModel item, String query) =>
      item.season.toLowerCase().contains(query);

  bool _matchesDate(ItemModel item, String query) =>
      item.startDate.toLowerCase().contains(query) ||
      item.endDate.toLowerCase().contains(query);

  void setFilter(String filter, BuildContext context) {
    _selectedFilter = filter;
    if (_lastSearchQuery.isNotEmpty) search(_lastSearchQuery, context);
  }

  List<String> getSuggestionsForCurrentFilter(String query, BuildContext context) {
    if (query.isEmpty) return [];
    final lq = query.toLowerCase();

    switch (_selectedFilter) {
      case 'الرحلات':
        return _suggestedTitles.where((t) => t.toLowerCase().contains(lq)).take(5).toList();
      case 'المدن':
        return _suggestedCities.where((c) => c.toLowerCase().contains(lq)).take(5).toList();
      case 'المواسم':
        final s = <String>{
          ..._suggestedSeasons.where((s) => s.toLowerCase().contains(lq)).take(3),
          ...predefinedSeasons.where((s) => s.toLowerCase().contains(lq)).take(2),
        };
        return s.take(5).toList();
      case 'التواريخ':
        return [];
      default:
        final all = <String>{
          ..._suggestedTitles.where((t) => t.toLowerCase().contains(lq)).take(3),
          ..._suggestedCities.where((c) => c.toLowerCase().contains(lq)).take(3),
          ..._suggestedSeasons.where((s) => s.toLowerCase().contains(lq)).take(2),
        };
        return all.take(5).toList();
    }
  }
}
