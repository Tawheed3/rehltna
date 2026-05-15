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

  List<String> _filteredList = [];
  String _listTitle = '';
  bool _showFilteredList = false;

  List<String> _suggestedTitlesAr = [];
  List<String> _suggestedTitlesEn = [];
  List<String> _suggestedCitiesAr = [];
  List<String> _suggestedCitiesEn = [];
  List<String> _suggestedSeasons = [];
  List<String> _suggestedMonthsAr = [];
  List<String> _suggestedHijriMonthsAr = [];
  List<String> _suggestedYears = [];

  String _lastSearchQuery = '';
  String _selectedFilter = 'الكل';

  // ==================== Getters ====================

  List<ItemModel> get searchResults => _searchResults;
  List<String> get filteredList => _filteredList;
  String get listTitle => _listTitle;
  bool get showFilteredList => _showFilteredList;

  List<String> get suggestedTitlesAr => _suggestedTitlesAr;
  List<String> get suggestedTitlesEn => _suggestedTitlesEn;
  List<String> get suggestedCitiesAr => _suggestedCitiesAr;
  List<String> get suggestedCitiesEn => _suggestedCitiesEn;
  List<String> get suggestedSeasons => _suggestedSeasons;
  List<String> get suggestedMonthsAr => _suggestedMonthsAr;
  List<String> get suggestedHijriMonthsAr => _suggestedHijriMonthsAr;
  List<String> get suggestedYears => _suggestedYears;
  String get selectedFilter => _selectedFilter;

  List<String> getSuggestedTitles(String langCode) =>
      langCode == 'ar' ? _suggestedTitlesAr : _suggestedTitlesEn;

  List<String> getSuggestedCities(String langCode) =>
      langCode == 'ar' ? _suggestedCitiesAr : _suggestedCitiesEn;

  List<String> get suggestedDates {
    final all = <String>[
      ..._suggestedMonthsAr,
      ..._suggestedHijriMonthsAr,
      ..._suggestedYears,
    ];
    all.sort();
    return all;
  }

  static const List<String> monthNamesAr = [
    'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
    'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر',
  ];

  static const List<String> hijriMonthNamesAr = [
    'محرم', 'صفر', 'ربيع الأول', 'ربيع الثاني',
    'جمادى الأولى', 'جمادى الآخرة', 'رجب', 'شعبان',
    'رمضان', 'شوال', 'ذو القعدة', 'ذو الحجة',
  ];

  // ==================== تطبيع النص ====================

  /// ✅ توحيد الحروف المتشابهة في العربية + تجاهل حالة الأحرف في الإنجليزية
  String _normalizeText(String text) {
    if (text.isEmpty) return '';
    return text
    // الألفات
        .replaceAll('أ', 'ا')
        .replaceAll('إ', 'ا')
        .replaceAll('آ', 'ا')
    // الياءات
        .replaceAll('ى', 'ي')
        .replaceAll('ئ', 'ي')
    // التاء المربوطة
        .replaceAll('ة', 'ه')
    // الواو والهمزة
        .replaceAll('ؤ', 'و')
    // تجاهل حالة الأحرف الإنجليزية
        .toLowerCase()
        .trim();
  }

  // ==================== تحميل البيانات ====================

  Future<void> loadAllItems() async {
    if (_allItems.isNotEmpty) {
      developer.log('📋 Search data already loaded (${_allItems.length})', name: BaseProvider.logTag);
      return;
    }

    startLoading();
    try {
      // ✅ استخدم Map عشان نضمن إن مفيش تكرار بالـ ID
      final Map<int, ItemModel> uniqueItems = {};

      // أضف الرحلات العادية
      if (_itemsProvider.items.isNotEmpty) {
        for (var item in _itemsProvider.items) {
          uniqueItems[item.id] = item;
        }
      } else {
        await _itemsProvider.fetchItems();
        for (var item in _itemsProvider.items) {
          uniqueItems[item.id] = item;
        }
      }

      // أضف العروض الخاصة (من غير تكرار)
      if (_featuresProvider.features.isNotEmpty) {
        for (var feature in _featuresProvider.features) {
          // ✅ لو الرحلة مش موجودة، نضيفها
          if (!uniqueItems.containsKey(feature.id)) {
            uniqueItems[feature.id] = feature;
          }
        }
      } else {
        await _featuresProvider.fetchFeatures();
        for (var feature in _featuresProvider.features) {
          if (!uniqueItems.containsKey(feature.id)) {
            uniqueItems[feature.id] = feature;
          }
        }
      }

      _allItems = uniqueItems.values.toList();
      _extractSuggestions();
      developer.log('✅ Search index ready: ${_allItems.length} items (deduplicated)', name: BaseProvider.logTag);
    } catch (e) {
      developer.log('❌ Error loading items: $e', name: BaseProvider.logTag, level: 1000);
      setError('حدث خطأ في تحميل البيانات');
    } finally {
      stopLoading();
    }
  }

  void _extractSuggestions() {
    final Set<String> titlesAr = {};
    final Set<String> titlesEn = {};
    final Set<String> citiesAr = {};
    final Set<String> citiesEn = {};
    final Set<String> seasons = {};
    final Set<String> months = {};
    final Set<String> hijriMonths = {};
    final Set<String> years = {};

    for (var item in _allItems) {
      if (item.getTitle('ar').isNotEmpty) titlesAr.add(item.getTitle('ar'));
      if (item.getTitle('en').isNotEmpty) titlesEn.add(item.getTitle('en'));

      citiesAr.add(item.itemType.getTitle('ar'));
      citiesEn.add(item.itemType.getTitle('en'));

      for (var itinerary in item.itineraries) {
        final cityAr = itinerary.city.getTitle('ar');
        if (cityAr.isNotEmpty) citiesAr.add(cityAr);
        final cityEn = itinerary.city.getTitle('en');
        if (cityEn.isNotEmpty) citiesEn.add(cityEn);
      }

      if (item.season.isNotEmpty) seasons.add(item.season);

      _extractMonthFromDate(item.startDate, months);
      _extractMonthFromDate(item.endDate, months);
      _extractHijriMonthFromDate(item.startDateHijri, hijriMonths);
      _extractHijriMonthFromDate(item.endDateHijri, hijriMonths);
      _extractYearFromDate(item.startDate, years);
      _extractYearFromDate(item.endDate, years);
      _extractYearFromDate(item.startDateHijri, years);
      _extractYearFromDate(item.endDateHijri, years);
    }

    _suggestedTitlesAr = titlesAr.toList()..sort();
    _suggestedTitlesEn = titlesEn.toList()..sort();
    _suggestedCitiesAr = citiesAr.toList()..sort();
    _suggestedCitiesEn = citiesEn.toList()..sort();
    _suggestedSeasons = seasons.toList()..sort();
    _suggestedMonthsAr = months.toList()..sort();
    _suggestedHijriMonthsAr = hijriMonths.toList()..sort();
    _suggestedYears = years.toList()..sort();
  }

  void _extractMonthFromDate(String date, Set<String> months) {
    if (date.isEmpty) return;
    try {
      final parts = date.split('-');
      if (parts.length >= 2) {
        final monthNum = int.tryParse(parts[1]);
        if (monthNum != null && monthNum >= 1 && monthNum <= 12) {
          months.add(monthNamesAr[monthNum - 1]);
        }
      }
    } catch (_) {}
  }

  void _extractHijriMonthFromDate(String date, Set<String> hijriMonths) {
    if (date.isEmpty) return;
    try {
      final parts = date.split('-');
      if (parts.length >= 2) {
        final monthNum = int.tryParse(parts[1]);
        if (monthNum != null && monthNum >= 1 && monthNum <= 12) {
          hijriMonths.add(hijriMonthNamesAr[monthNum - 1]);
        }
      }
    } catch (_) {}
  }

  void _extractYearFromDate(String date, Set<String> years) {
    if (date.isEmpty) return;
    try {
      final parts = date.split('-');
      if (parts.isNotEmpty && parts[0].length == 4) {
        years.add(parts[0]);
      }
    } catch (_) {}
  }

  // ==================== البحث ====================

  void search(String query, BuildContext context) {
    _lastSearchQuery = query;

    if (query.isEmpty) {
      _searchResults = [];
      _showFilteredList = false;
      notifyListeners();
      return;
    }

    _showFilteredList = false;
    final q = _normalizeText(query.trim()); // ✅ تطبيع النص

    _searchResults = _allItems.where((item) {
      switch (_selectedFilter) {
        case 'الرحلات':
          return _matchesTitle(item, q);
        case 'المدن':
          return _matchesCity(item, q) || _matchesItineraryCity(item, q);
        case 'المواسم':
          return _matchesSeason(item, q);
        case 'التواريخ':
          return _matchesMonth(item, q) || _matchesHijriMonth(item, q) || _matchesYear(item, q) || _matchesDate(item, q);
        default:
          return _matchesTitle(item, q) ||
              _matchesDescription(item, q) ||
              _matchesCity(item, q) ||
              _matchesItineraryCity(item, q) ||
              _matchesSeason(item, q) ||
              _matchesMonth(item, q) ||
              _matchesHijriMonth(item, q) ||
              _matchesYear(item, q) ||
              _matchesDate(item, q);
      }
    }).toList();

    notifyListeners();
  }

  // ==================== دوال المطابقة ====================

  bool _matchesTitle(ItemModel item, String q) =>
      _normalizeText(item.getTitle('ar')).contains(q) ||
          _normalizeText(item.getTitle('en')).contains(q);

  bool _matchesDescription(ItemModel item, String q) =>
      _normalizeText(item.getDescription('ar')).contains(q) ||
          _normalizeText(item.getDescription('en')).contains(q) ||
          _normalizeText(item.getShortDescription('ar')).contains(q) ||
          _normalizeText(item.getShortDescription('en')).contains(q);

  bool _matchesCity(ItemModel item, String q) =>
      _normalizeText(item.itemType.getTitle('ar')).contains(q) ||
          _normalizeText(item.itemType.getTitle('en')).contains(q);

  bool _matchesItineraryCity(ItemModel item, String q) {
    for (var it in item.itineraries) {
      if (_normalizeText(it.city.getTitle('ar')).contains(q) ||
          _normalizeText(it.city.getTitle('en')).contains(q)) return true;
    }
    return false;
  }

  bool _matchesSeason(ItemModel item, String q) =>
      _normalizeText(item.season).contains(q);

  bool _matchesDate(ItemModel item, String q) =>
      item.startDate.toLowerCase().contains(q) ||
          item.endDate.toLowerCase().contains(q) ||
          item.startDateHijri.toLowerCase().contains(q) ||
          item.endDateHijri.toLowerCase().contains(q);

  bool _matchesYear(ItemModel item, String q) {
    try {
      if (item.startDate.isNotEmpty && item.startDate.split('-').first == q) return true;
      if (item.endDate.isNotEmpty && item.endDate.split('-').first == q) return true;
      if (item.startDateHijri.isNotEmpty && item.startDateHijri.split('-').first == q) return true;
      if (item.endDateHijri.isNotEmpty && item.endDateHijri.split('-').first == q) return true;
    } catch (_) {}
    return false;
  }

  bool _matchesMonth(ItemModel item, String q) {
    int? targetMonth;
    for (int i = 0; i < monthNamesAr.length; i++) {
      if (_normalizeText(monthNamesAr[i]).contains(q) || q.contains(_normalizeText(monthNamesAr[i]))) {
        targetMonth = i + 1;
        break;
      }
    }
    if (targetMonth != null) {
      return _dateHasMonth(item.startDate, targetMonth) || _dateHasMonth(item.endDate, targetMonth);
    }
    return item.startDate.toLowerCase().contains(q) || item.endDate.toLowerCase().contains(q);
  }

  bool _matchesHijriMonth(ItemModel item, String q) {
    int? targetMonth;
    for (int i = 0; i < hijriMonthNamesAr.length; i++) {
      if (_normalizeText(hijriMonthNamesAr[i]).contains(q) || q.contains(_normalizeText(hijriMonthNamesAr[i]))) {
        targetMonth = i + 1;
        break;
      }
    }
    if (targetMonth != null) {
      return _dateHasMonth(item.startDateHijri, targetMonth) || _dateHasMonth(item.endDateHijri, targetMonth);
    }
    return item.startDateHijri.toLowerCase().contains(q) || item.endDateHijri.toLowerCase().contains(q);
  }

  bool _dateHasMonth(String date, int month) {
    if (date.isEmpty) return false;
    try {
      final parts = date.split('-');
      if (parts.length >= 2) {
        final dateMonth = int.tryParse(parts[1]);
        return dateMonth == month;
      }
    } catch (_) {}
    return false;
  }

  // ==================== فلتر ====================

  void setFilter(String filter, BuildContext context) {
    _selectedFilter = filter;
    if (_lastSearchQuery.isNotEmpty) search(_lastSearchQuery, context);
  }

  void showAllForFilter(String filter, String langCode) {
    _selectedFilter = filter;
    _lastSearchQuery = '';
    _searchResults = [];
    _showFilteredList = true;

    switch (filter) {
      case 'الرحلات':
        _filteredList = getSuggestedTitles(langCode);
        _listTitle = langCode == 'ar' ? 'جميع الرحلات' : 'All Trips';
        break;
      case 'المدن':
        _filteredList = getSuggestedCities(langCode);
        _listTitle = langCode == 'ar' ? 'جميع المدن والأقسام' : 'All Cities';
        break;
      case 'المواسم':
        _filteredList = _suggestedSeasons;
        _listTitle = langCode == 'ar' ? 'جميع المواسم' : 'All Seasons';
        break;
      case 'التواريخ':
        _filteredList = [
          ..._suggestedMonthsAr.map((m) => '📅 $m'),
          ..._suggestedHijriMonthsAr.map((m) => '🕌 $m'),
          ..._suggestedYears.map((y) => '📆 $y'),
        ];
        _listTitle = langCode == 'ar' ? 'الشهور والسنوات' : 'Months & Years';
        break;
      default:
        _filteredList = [];
        _listTitle = '';
        _showFilteredList = false;
    }

    notifyListeners();
  }

  List<String> getSuggestionsForCurrentFilter(String query, String langCode) {
    if (query.isEmpty) return [];
    final lq = _normalizeText(query); // ✅ تطبيع النص

    final titles = getSuggestedTitles(langCode);
    final cities = getSuggestedCities(langCode);

    switch (_selectedFilter) {
      case 'الرحلات':
        return titles.where((t) => _normalizeText(t).contains(lq)).take(5).toList();
      case 'المدن':
        return cities.where((c) => _normalizeText(c).contains(lq)).take(5).toList();
      case 'المواسم':
        return _suggestedSeasons.where((s) => _normalizeText(s).contains(lq)).take(5).toList();
      case 'التواريخ':
        return suggestedDates.where((d) => _normalizeText(d).contains(lq)).take(5).toList();
      default:
        final all = <String>{
          ...titles.where((t) => _normalizeText(t).contains(lq)).take(2),
          ...cities.where((c) => _normalizeText(c).contains(lq)).take(2),
          ..._suggestedSeasons.where((s) => _normalizeText(s).contains(lq)).take(2),
          ...suggestedDates.where((d) => _normalizeText(d).contains(lq)).take(2),
        };
        return all.take(5).toList();
    }
  }
}