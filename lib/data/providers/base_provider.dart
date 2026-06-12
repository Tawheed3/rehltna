import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../core/constants/app_config.dart';

class _CacheEntry {
  final Map<String, dynamic> data;
  final DateTime expiresAt;
  const _CacheEntry({required this.data, required this.expiresAt});
  bool get isValid => DateTime.now().isBefore(expiresAt);
}

class BaseProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  static final Map<String, _CacheEntry> _responseCache = {};
  static const Duration defaultCacheTtl = Duration(minutes: 5);

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  static String get baseUrl => AppConfig.baseUrl;
  static String get XApiKey => AppConfig.apiKey;
  static int get XTenantID => AppConfig.tenantId;

  // ─── Logcat tag — filter by "Response-output" in Android Studio logcat ───
  static const String logTag = 'Response-output';

  void logRequest(String method, String url, {Object? body}) {
    developer.log(
      '[$method] --> $url'
      '${body != null ? '\n   Body: ${jsonEncode(body)}' : ''}',
      name: logTag,
    );
  }

  void logResponse(String method, String url, int statusCode, String responseBody) {
    String prettyBody;
    try {
      prettyBody = const JsonEncoder.withIndent('  ').convert(jsonDecode(responseBody));
    } catch (_) {
      prettyBody = responseBody;
    }
    developer.log(
      '[$method] <-- $statusCode $url\n$prettyBody',
      name: logTag,
    );
  }

  void logError(String method, String url, Object error) {
    developer.log(
      '[$method] ❌ ERROR $url\n   $error',
      name: logTag,
      level: 1000,
    );
  }

  Map<String, String> get _publicHeaders => {
    'Content-Type': 'application/json',
    'X-API-Key': XApiKey,
    'X-Tenant-ID': XTenantID.toString(),
  };

  Map<String, String> _authHeaders(String token) => {
    ..._publicHeaders,
    'Authorization': 'Bearer $token',
  };

  void setError(String message) {
    if (_errorMessage == message) return;
    _errorMessage = message;
    notifyListeners();
  }

  void startLoading() {
    if (_isLoading) return; // already loading — don't trigger a redundant rebuild
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
  }

  void stopLoading() {
    if (!_isLoading) return; // already stopped — don't trigger a redundant rebuild
    _isLoading = false;
    notifyListeners();
  }

  static const Duration _requestTimeout = Duration(seconds: 15);

  Future<Map<String, dynamic>?> getRequest(String endpoint,
      {String? token}) async {
    final url = '$baseUrl/$endpoint';
    try {
      logRequest('GET', url);

      final response = await http.get(
        Uri.parse(url),
        headers: token != null ? _authHeaders(token) : _publicHeaders,
      ).timeout(_requestTimeout, onTimeout: () {
        logError('GET', url, 'Request timed out after ${_requestTimeout.inSeconds}s');
        throw TimeoutException('Request timed out', _requestTimeout);
      });

      logResponse('GET', url, response.statusCode, response.body);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        try {
          return jsonDecode(response.body);
        } catch (e) {
          setError('خطأ في الاتصال بالخادم: ${response.statusCode}');
          return null;
        }
      }
    } on TimeoutException {
      setError('انتهت مهلة الاتصال، يرجى المحاولة مجدداً');
      return null;
    } catch (e) {
      logError('GET', url, e);
      setError('حدث خطأ: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> postRequest(String endpoint,
      Map<String, dynamic> body,
      {String? token}) async {
    final url = '$baseUrl/$endpoint';
    try {
      logRequest('POST', url, body: body);

      final response = await http.post(
        Uri.parse(url),
        headers: token != null ? _authHeaders(token) : _publicHeaders,
        body: jsonEncode(body),
      );

      logResponse('POST', url, response.statusCode, response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        try {
          return jsonDecode(response.body);
        } catch (e) {
          setError('خطأ في الاتصال بالخادم: ${response.statusCode}');
          return null;
        }
      }
    } catch (e) {
      logError('POST', url, e);
      setError('حدث خطأ: $e');
      return null;
    }
  }

  Future<http.Response?> postRequestRaw(String endpoint,
      Map<String, dynamic> body,
      {String? token}) async {
    final url = '$baseUrl/$endpoint';
    try {
      logRequest('POST-RAW', url, body: body);

      final response = await http.post(
        Uri.parse(url),
        headers: token != null ? _authHeaders(token) : _publicHeaders,
        body: jsonEncode(body),
      );

      logResponse('POST-RAW', url, response.statusCode, response.body);
      return response;
    } catch (e) {
      logError('POST-RAW', url, e);
      return null;
    }
  }

  Future<Map<String, dynamic>?> postFormRequest(String endpoint,
      Map<String, String> fields,
      {String? token}) async {
    final url = '$baseUrl/$endpoint';
    try {
      logRequest('POST-FORM', url, body: fields);

      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers
          .addAll(token != null ? _authHeaders(token) : _publicHeaders);

      fields.forEach((key, value) {
        request.fields[key] = value;
      });

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      logResponse('POST-FORM', url, response.statusCode, response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        try {
          return jsonDecode(response.body);
        } catch (e) {
          setError('خطأ في الاتصال بالخادم: ${response.statusCode}');
          return null;
        }
      }
    } catch (e) {
      logError('POST-FORM', url, e);
      setError('حدث خطأ: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getRequestWithQuery(
      String endpoint, Map<String, String> queryParams,
      {String? token}) async {
    final uri =
        Uri.parse('$baseUrl/$endpoint').replace(queryParameters: queryParams);
    try {
      logRequest('GET-QUERY', uri.toString());

      final response = await http.get(
        uri,
        headers: token != null ? _authHeaders(token) : _publicHeaders,
      ).timeout(_requestTimeout, onTimeout: () {
        logError('GET-QUERY', uri.toString(), 'Request timed out after ${_requestTimeout.inSeconds}s');
        throw TimeoutException('Request timed out', _requestTimeout);
      });

      logResponse('GET-QUERY', uri.toString(), response.statusCode, response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        try {
          return jsonDecode(response.body);
        } catch (e) {
          setError('خطأ في الاتصال بالخادم: ${response.statusCode}');
          return null;
        }
      }
    } on TimeoutException {
      setError('انتهت مهلة الاتصال، يرجى المحاولة مجدداً');
      return null;
    } catch (e) {
      logError('GET-QUERY', uri.toString(), e);
      setError('حدث خطأ: $e');
      return null;
    }
  }

  /// GET with in-memory TTL cache. Identical to [getRequest] but serves
  /// a cached copy until [ttl] expires, avoiding redundant API hits when
  /// the user navigates back to a screen.
  Future<Map<String, dynamic>?> getCachedRequest(
    String endpoint, {
    String? token,
    Duration ttl = defaultCacheTtl,
  }) async {
    final cacheKey = '$baseUrl/$endpoint';
    final entry = _responseCache[cacheKey];
    if (entry != null && entry.isValid) {
      developer.log('[GET-CACHE] HIT $cacheKey', name: logTag);
      return entry.data;
    }

    final data = await getRequest(endpoint, token: token);
    if (data != null) {
      _responseCache[cacheKey] = _CacheEntry(
        data: data,
        expiresAt: DateTime.now().add(ttl),
      );
    }
    return data;
  }

  static void invalidateCache(String endpoint) {
    final key = '$baseUrl/$endpoint';
    _responseCache.remove(key);
    developer.log('[CACHE] Invalidated: $key', name: logTag);
  }

  static void clearCache() {
    _responseCache.clear();
    developer.log('[CACHE] All entries cleared', name: logTag);
  }

  Future<http.Response?> postRequestWithTimeout(
      String endpoint, Map<String, dynamic> body,
      {String? token}) async {
    final url = '$baseUrl/$endpoint';
    try {
      logRequest('POST-TIMEOUT', url, body: body);

      final response = await http
          .post(
            Uri.parse(url),
            headers: token != null ? _authHeaders(token) : _publicHeaders,
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 5), onTimeout: () {
        developer.log('[POST-TIMEOUT] ⏱️ Request timed out: $url', name: logTag);
        return http.Response('Timeout', 408);
      });

      logResponse('POST-TIMEOUT', url, response.statusCode, response.body);
      return response;
    } catch (e) {
      logError('POST-TIMEOUT', url, e);
      return null;
    }
  }
}