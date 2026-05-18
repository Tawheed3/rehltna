import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import 'auth_provider.dart';
import 'base_provider.dart';

class UserProvider extends BaseProvider {
  UserModel? _user;
  final AuthProvider authProvider;
  List<Map<String, dynamic>> _tripDocuments = [];

  UserModel? get user => _user;
  List<Map<String, dynamic>> get tripDocuments => _tripDocuments;

  UserProvider({required this.authProvider});

  // ==================== جلب البروفايل ====================

  Future<bool> fetchProfile() async {
    final token = authProvider.token;
    if (token == null) return false;

    startLoading();

    final data = await getRequest('profile', token: token);
    bool success = false;

    if (data != null && data['code'] == 200 && data['data'] != null) {
      _user = UserModel.fromJson(data['data']);
      developer.log('Profile loaded: ${_user?.name}', name: BaseProvider.logTag);
      success = true;
    }

    stopLoading();
    return success;
  }

  // ==================== وثائق الرحلات ====================

  Future<void> fetchTripDocuments() async {
    final token = authProvider.token;
    if (token == null) return;

    final data = await getRequest('profile/trip-documents', token: token);
    if (data != null && data['code'] == 200 && data['data'] != null) {
      _tripDocuments = List<Map<String, dynamic>>.from(data['data']);
      developer.log('Trip documents loaded: ${_tripDocuments.length}', name: BaseProvider.logTag);
      notifyListeners();
    }
  }

  // ==================== تحديث البروفايل ====================

  Future<bool> updateProfile(Map<String, dynamic> data) async {
    final token = authProvider.token;
    if (token == null) return false;

    startLoading();

    // ✅ نستخدم PUT بدل POST مع Raw Request
    final url = '${BaseProvider.baseUrl}/profile';

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'X-API-Key': BaseProvider.XApiKey,
          'X-Tenant-ID': BaseProvider.XTenantID.toString(),
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data),
      );

      developer.log(
        '[Profile Update PUT] Status: ${response.statusCode}',
        name: BaseProvider.logTag,
      );
      developer.log(
        '[Profile Update PUT] Body: ${response.body}',
        name: BaseProvider.logTag,
      );

      bool success = false;

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        if (result['code'] == 200) {
          success = await fetchProfile();
        } else {
          setError(result['message'] ?? 'فشل التحديث');
        }
      } else {
        try {
          final errorBody = jsonDecode(response.body);
          setError(errorBody['message'] ?? 'خطأ في الخادم: ${response.statusCode}');
        } catch (_) {
          setError('خطأ في الخادم: ${response.statusCode}');
        }
      }

      stopLoading();
      return success;
    } catch (e) {
      developer.log(
        '[Profile Update] Error: $e',
        name: BaseProvider.logTag,
        level: 1000,
      );
      setError('حدث خطأ: $e');
      stopLoading();
      return false;
    }
  }
}