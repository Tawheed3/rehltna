import 'dart:developer' as developer;
import '../models/item_model.dart';
import '../services/cache_service.dart';
import 'base_provider.dart';

class FeaturesProvider extends BaseProvider {
  List<ItemModel> _features = [];
  bool _hasLoadedOnce = false;

  List<ItemModel> get features => _features;
  bool get hasLoadedOnce => _hasLoadedOnce;

  static const String _cacheKey = 'features';
  static const Duration _ttl = Duration(hours: 2);

  Future<void> fetchFeatures() async {
    final cache = CacheService();

    // Stale-while-revalidate: serve any cached data instantly
    final stale = cache.getAny(_cacheKey);
    if (stale != null) {
      _applyData(stale);
      _hasLoadedOnce = true;
      notifyListeners();

      if (!cache.isExpired(_cacheKey, ttl: _ttl)) return; // fresh — done

      // Stale cache — refresh in background without showing loading spinner
      _silentRefresh();
      return;
    }

    // No cache — show shimmer and wait for network
    startLoading();
    await _fetchAndCache();
    _hasLoadedOnce = true;
    stopLoading();
  }

  Future<void> _fetchAndCache() async {
    final data = await getRequest('items-features?number=');
    if (data != null && data['code'] == 200 && data['data'] != null) {
      _applyData(data);
      CacheService().set(_cacheKey, data);
    }
  }

  void _applyData(Map<String, dynamic> data) {
    final list = data['data'] as List;
    _features = list.map((item) => ItemModel.fromFeatureJson(item)).toList();
    developer.log('Features applied: ${_features.length}', name: BaseProvider.logTag);
  }

  void _silentRefresh() {
    Future.microtask(() async {
      final data = await getRequest('items-features?number=');
      if (data != null && data['code'] == 200 && data['data'] != null) {
        _applyData(data);
        CacheService().set(_cacheKey, data);
        notifyListeners();
      }
    });
  }
}
