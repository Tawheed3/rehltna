import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import '../models/item_model.dart';
import '../models/subcategory_item.dart';
import '../services/cache_service.dart';
import 'base_provider.dart';

class ItemsProvider extends BaseProvider {
  static const String _cacheKeyItems = 'items-v3';
  static const String _cacheKeyTypes = 'item-types-v3';
  static const Duration _ttl = Duration(minutes: 30);

  List<ItemModel> _items = [];
  List<ItemModel> _endedItems = [];
  List<SubcategoryItem> _itemTypes = [];
  bool _hasMoreData = true;
  int _currentPage = 1;
  bool _hasLoadedOnce = false;

  List<ItemModel> get items => _items;
  List<ItemModel> get endedItems => _endedItems;
  List<SubcategoryItem> get itemTypes => _itemTypes;
  bool get hasMoreData => _hasMoreData;
  bool get hasLoadedOnce => _hasLoadedOnce;

  bool _isTripExpired(ItemModel item) {
    try {
      if (item.endDate.isEmpty) return false;
      final endDate = DateTime.parse(item.endDate);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final endDateOnly = DateTime(endDate.year, endDate.month, endDate.day);
      return endDateOnly.isBefore(today);
    } catch (e) {
      return false;
    }
  }

  bool _isTripActive(ItemModel item) => !_isTripExpired(item);

  List<ItemModel> getActiveItems() => _items.where(_isTripActive).toList();

  // ==================== جلب البيانات ====================

  Future<void> fetchItems({int? limit, int page = 1}) async {
    startLoading();
    String endpoint = 'items?per_page=200';
    if (page > 1) endpoint += '&page=$page';
    final data = await getRequest(endpoint);
    if (data != null && data['code'] == 200 && data['data'] != null) {
      final itemsData = data['data']['items']['data'] as List;
      if (page == 1) {
        _items = itemsData.map((item) => ItemModel.fromJson(item)).toList();
      } else {
        _items.addAll(
            itemsData.map((item) => ItemModel.fromJson(item)).toList());
      }
      _currentPage = page;
      _hasMoreData = itemsData.length >= (limit ?? 20);
      developer.log('Loaded ${_items.length} items (page $page)', name: BaseProvider.logTag);
    }
    _hasLoadedOnce = true;
    stopLoading();
  }

  Future<void> fetchItemTypes() async {
    startLoading();
    final data = await getRequest('item-types');
    if (data != null && data['code'] == 200 && data['data'] != null) {
      final itemsData = data['data']['data'] as List;
      _itemTypes =
          itemsData.map((item) => SubcategoryItem.fromJson(item)).toList();
      _filterExpiredTripsFromSubcategories();
      _updateAllRecursiveCounts();
      developer.log('Loaded ${_itemTypes.length} item types', name: BaseProvider.logTag);
    }
    _hasLoadedOnce = true;
    stopLoading();
  }

  Future<void> loadAllItemsIntoCategories() async {
    final cache = CacheService();
    final cachedItems = cache.getAny(_cacheKeyItems);
    final cachedTypes = cache.getAny(_cacheKeyTypes);

    if (cachedItems != null && cachedTypes != null) {
      // Serve cache immediately — no shimmer
      _applyItemsData(cachedItems);
      _applyItemTypesData(cachedTypes);
      _distribute();
      _hasLoadedOnce = true;
      notifyListeners();

      final isFresh = !cache.isExpired(_cacheKeyItems, ttl: _ttl) &&
          !cache.isExpired(_cacheKeyTypes, ttl: _ttl);
      if (isFresh) return; // Fresh — skip network

      // Stale — refresh silently in background
      _silentRefreshAll();
      return;
    }

    // No cache — show shimmer and fetch
    startLoading();
    try {
      await _fetchAndCacheItems();
      await _fetchAndCacheTypes();
      _distribute();
      _hasLoadedOnce = true;
    } catch (e) {
      developer.log('Error in loadAllItemsIntoCategories: $e',
          name: BaseProvider.logTag, level: 1000);
    } finally {
      stopLoading();
    }
  }

  Future<void> _fetchAndCacheItems() async {
    final data = await getRequest('items?per_page=200');
    if (data != null && data['code'] == 200 && data['data'] != null) {
      _applyItemsData(data);
      CacheService().set(_cacheKeyItems, data);
    }
  }

  Future<void> _fetchAndCacheTypes() async {
    final data = await getRequest('item-types');
    if (data != null && data['code'] == 200 && data['data'] != null) {
      _applyItemTypesData(data);
      CacheService().set(_cacheKeyTypes, data);
    }
  }

  void _applyItemsData(Map<String, dynamic> data) {
    final itemsData = data['data']['items']['data'] as List;
    _items = itemsData.map((item) => ItemModel.fromJson(item)).toList();
    _hasMoreData = _items.length >= 200;
    _currentPage = 1;
    developer.log('Items applied: ${_items.length}', name: BaseProvider.logTag);
  }

  void _applyItemTypesData(Map<String, dynamic> data) {
    final typesData = data['data']['data'] as List;
    _itemTypes = typesData.map((item) => SubcategoryItem.fromJson(item)).toList();
    _filterExpiredTripsFromSubcategories();
    _updateAllRecursiveCounts();
    developer.log('Item types applied: ${_itemTypes.length}', name: BaseProvider.logTag);
  }

  void _distribute() {
    for (var type in _itemTypes) {
      type.items.clear();
      type.items.addAll(
          _items.where((i) => i.itemTypeId == type.id && _isTripActive(i)));
      for (var child in type.children) {
        child.items.clear();
        child.items.addAll(
            _items.where((i) => i.itemTypeId == child.id && _isTripActive(i)));
      }
    }
    _updateAllRecursiveCounts();
    developer.log('Distributed ${_items.length} items into categories',
        name: BaseProvider.logTag);
  }

  void _silentRefreshAll() {
    Future.microtask(() async {
      await _fetchAndCacheItems();
      await _fetchAndCacheTypes();
      _distribute();
      notifyListeners();
    });
  }

  Future<List<ItemModel>> fetchItemsByCategory(int categoryId) async {
    startLoading();
    final List<ItemModel> result = [];
    try {
      final data = await getRequest('item-type-items/$categoryId');
      if (data != null && data['code'] == 200 && data['data'] != null) {
        final itemsData = data['data']['items']['data'] as List;
        final fetchedItems =
            itemsData.map((item) => ItemModel.fromJson(item)).toList();
        final filteredItems = fetchedItems.where(_isTripActive).toList();
        result.addAll(filteredItems);
        for (var item in fetchedItems) {
          final idx = _items.indexWhere((i) => i.id == item.id);
          if (idx >= 0) _items[idx] = item;
          else _items.add(item);
        }
        for (var type in _itemTypes) {
          if (type.id == categoryId) {
            type.items.clear();
            type.items.addAll(filteredItems);
          }
          for (var child in type.children) {
            if (child.id == categoryId) {
              child.items.clear();
              child.items.addAll(filteredItems);
            }
          }
        }
        _updateAllRecursiveCounts();
        developer.log('Fetched ${filteredItems.length} items for category $categoryId', name: BaseProvider.logTag);
      }
    } catch (e) {
      developer.log('Error in fetchItemsByCategory: $e', name: BaseProvider.logTag, level: 1000);
    } finally {
      stopLoading();
    }
    return result;
  }

  void _updateAllRecursiveCounts() {
    for (var type in _itemTypes) {
      _updateRecursiveCount(type);
    }
  }

  void _updateRecursiveCount(SubcategoryItem category) {
    for (var child in category.children) {
      _updateRecursiveCount(child);
    }
    int total = category.items.length;
    for (var child in category.children) {
      total += child.totalItemsRecursive;
    }
    category.totalItemsRecursive = total;
  }

  void _filterExpiredTripsFromSubcategories() {
    for (var type in _itemTypes) {
      type.items.removeWhere(_isTripExpired);
      for (var child in type.children) {
        child.items.removeWhere(_isTripExpired);
      }
    }
  }

  // ==================== الأقسام ====================

  List<SubcategoryItem> getMainCategories() {
    final mainCats = _itemTypes.where((cat) => cat.parentId == null).toList();
    mainCats.sort((a, b) => a.order.compareTo(b.order));
    return mainCats;
  }

  List<SubcategoryItem> getSubcategoriesByParent(int parentId) {
    final parent = _itemTypes.firstWhere(
          (cat) => cat.id == parentId,
      orElse: () => SubcategoryItem(id: 0, titleAr: '', titleEn: ''),
    );
    final children = List<SubcategoryItem>.from(parent.children);
    children.sort((a, b) => a.order.compareTo(b.order));
    return children;
  }

  List<ItemModel> getItemsForSubcategory(int subcategoryId) {
    for (var type in _itemTypes) {
      if (type.id == subcategoryId) {
        return type.items.where(_isTripActive).toList();
      }
      for (var child in type.children) {
        if (child.id == subcategoryId) {
          return child.items.where(_isTripActive).toList();
        }
      }
    }
    return [];
  }

  SubcategoryItem? getSubcategoryById(int id) {
    for (var type in _itemTypes) {
      if (type.id == id) return type;
      for (var child in type.children) {
        if (child.id == id) return child;
      }
    }
    return null;
  }

  int getTotalItemsForCategory(int categoryId) {
    for (var type in _itemTypes) {
      if (type.id == categoryId) return type.totalItemsRecursive;
      for (var child in type.children) {
        if (child.id == categoryId) return child.totalItemsRecursive;
      }
    }
    return 0;
  }

  List<ItemModel> getAllItemsForMainCategory(int categoryId) {
    final List<ItemModel> allItems = [];
    allItems.addAll(getItemsByType(categoryId));
    final subcategories = getSubcategoriesByParent(categoryId);
    for (var subcat in subcategories) {
      allItems.addAll(subcat.items.where(_isTripActive));
      for (var child in subcat.children) {
        allItems.addAll(child.items.where(_isTripActive));
      }
    }
    final uniqueIds = <int>{};
    return allItems.where((item) => uniqueIds.add(item.id)).toList();
  }

  // ==================== رحلات ====================

  List<ItemModel> getExpiredItems() => _endedItems;

  Future<void> fetchEndedItems() async {
    startLoading();
    final data = await getRequest('items?ended=1&limit=100');
    if (data != null && data['code'] == 200 && data['data'] != null) {
      final itemsData = data['data']['items']['data'] as List? ?? [];
      _endedItems = itemsData.map((item) => ItemModel.fromJson(item)).toList();
      developer.log('Loaded ${_endedItems.length} ended items', name: BaseProvider.logTag);
    }
    stopLoading();
  }
  List<ItemModel> getItemsByType(int typeId) =>
      _items.where((item) => item.itemTypeId == typeId && _isTripActive(item)).toList();
  List<ItemModel> getGroupTours() => getItemsByType(5);
  List<ItemModel> getCruises() => getItemsByType(4);
  List<ItemModel> getEducationalTours() => getItemsByType(3);
  List<ItemModel> getVisas() => getItemsByType(2);
  List<ItemModel> getSpecialOffers() => getActiveItems().take(3).toList();

  Future<void> loadMoreItems() async {
    if (!_hasMoreData || isLoading) return;
    await fetchItems(page: _currentPage + 1);
  }

  Future<ItemModel?> fetchItemDetails(int itemId) async {
    startLoading();
    final data = await getRequest('items/$itemId');
    ItemModel? item;
    if (data != null && data['code'] == 200 && data['data'] != null) {
      item = ItemModel.fromJson(data['data']);
    }
    stopLoading();
    return item;
  }

  ItemModel? getItemById(int id) {
    try {
      return _items.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Map<String, dynamic>> getMainSections() {
    return getMainCategories()
        .map((cat) => {
      'id': cat.id.toString(),
      'title': cat.getTitle('ar'),
      'titleEn': cat.getTitle('en'),
      'icon': _getIconForCategory(cat.id),
      'color': _getColorForCategory(cat.id),
      'totalItems': cat.totalItemsRecursive,
      'whatsapp': cat.whatsapp,
      'banner': cat.banner,
    })
        .toList();
  }

  IconData _getIconForCategory(int id) {
    switch (id) {
      case 1:
        return Icons.local_fire_department;
      case 2:
        return Icons.credit_card;
      case 3:
        return Icons.school;
      case 4:
        return Icons.directions_boat;
      case 5:
        return Icons.people;
      default:
        return Icons.travel_explore;
    }
  }

  Color _getColorForCategory(int id) {
    switch (id) {
      case 1:
        return Colors.orange;
      case 2:
        return Colors.indigo;
      case 3:
        return Colors.purple;
      case 4:
        return Colors.teal;
      case 5:
        return Colors.blue;
      default:
        return Colors.blue;
    }
  }
}