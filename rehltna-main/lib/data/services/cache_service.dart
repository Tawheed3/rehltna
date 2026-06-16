import 'dart:convert';
import 'dart:developer' as developer;
import 'package:hive_flutter/hive_flutter.dart';

/// Hive-backed response cache with TTL support.
///
/// Usage pattern (stale-while-revalidate):
///   final stale = CacheService().getAny('items');
///   if (stale != null) {
///     _applyData(stale);           // show instantly
///     notifyListeners();
///     if (!CacheService().isExpired('items')) return; // fresh — skip network
///     _silentRefresh();            // stale — refresh in background
///     return;
///   }
///   startLoading();
///   await _fetchAndCache();        // no cache — show shimmer
///   stopLoading();
class CacheService {
  static final CacheService _instance = CacheService._internal();
  factory CacheService() => _instance;
  CacheService._internal();

  static const String _boxName = 'api_cache';
  static const String _logTag  = 'CacheService';

  Box? _box;

  Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox(_boxName);
    developer.log('Cache ready — ${_box!.length} entries', name: _logTag);
  }

  // ── Write ────────────────────────────────────────────────────────────────

  void set(String key, Map<String, dynamic> data) {
    _box?.put(key, {
      'data': jsonEncode(data),
      'ts': DateTime.now().millisecondsSinceEpoch,
    });
  }

  // ── Read ─────────────────────────────────────────────────────────────────

  /// Returns data only if it exists AND is younger than [ttl].
  Map<String, dynamic>? get(String key,
      {Duration ttl = const Duration(hours: 2)}) {
    if (isExpired(key, ttl: ttl)) return null;
    return _decode(key);
  }

  /// Returns data regardless of age (used for stale-while-revalidate).
  Map<String, dynamic>? getAny(String key) => _decode(key);

  /// True if the entry is missing or older than [ttl].
  bool isExpired(String key,
      {Duration ttl = const Duration(hours: 2)}) {
    final raw = _box?.get(key);
    if (raw == null) return true;
    final ts  = (raw['ts'] as int?) ?? 0;
    final age = DateTime.now().millisecondsSinceEpoch - ts;
    return age > ttl.inMilliseconds;
  }

  // ── Delete ───────────────────────────────────────────────────────────────

  Future<void> delete(String key) async => _box?.delete(key);

  Future<void> clearAll() async {
    await _box?.clear();
    developer.log('Cache cleared', name: _logTag);
  }

  // ── Internal ─────────────────────────────────────────────────────────────

  Map<String, dynamic>? _decode(String key) {
    final raw = _box?.get(key);
    if (raw == null) return null;
    try {
      return jsonDecode(raw['data'] as String) as Map<String, dynamic>;
    } catch (e) {
      developer.log('Decode error for "$key": $e', name: _logTag, level: 1000);
      _box?.delete(key);
      return null;
    }
  }
}
