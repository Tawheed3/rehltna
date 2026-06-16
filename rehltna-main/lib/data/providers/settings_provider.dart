import 'dart:developer' as developer;
import '../models/settings_model.dart';
import '../services/cache_service.dart';
import 'base_provider.dart';

class SettingsProvider extends BaseProvider {
  SettingsModel? _settings;
  bool _hasLoadedOnce = false;

  SettingsModel? get settings => _settings;
  bool get hasLoadedOnce => _hasLoadedOnce;

  static const String _cacheKey = 'settings';
  static const Duration _ttl = Duration(hours: 24); // settings change rarely

  Future<void> fetchSettings() async {
    final cache = CacheService();

    // Stale-while-revalidate: serve any cached data instantly
    final stale = cache.getAny(_cacheKey);
    if (stale != null) {
      _applyData(stale);
      _hasLoadedOnce = true;
      notifyListeners();

      if (!cache.isExpired(_cacheKey, ttl: _ttl)) return; // fresh — done

      // Stale — refresh silently in background
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
    final data = await getRequest('settings');
    if (data != null && data['code'] == 200 && data['data'] != null) {
      _applyData(data);
      CacheService().set(_cacheKey, data);
    }
  }

  void _applyData(Map<String, dynamic> data) {
    _settings = SettingsModel.fromJson(data['data']);
    developer.log('Settings applied: ${_settings?.siteNameAr}', name: BaseProvider.logTag);
  }

  void _silentRefresh() {
    Future.microtask(() async {
      final data = await getRequest('settings');
      if (data != null && data['code'] == 200 && data['data'] != null) {
        _applyData(data);
        CacheService().set(_cacheKey, data);
        notifyListeners();
      }
    });
  }
}
