import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import 'base_provider.dart';

class AuthProvider extends BaseProvider {
  String? _token;
  UserModel? _currentUser;

  String? get token => _token;
  bool get isLoggedIn => _token != null && _token!.isNotEmpty;
  UserModel? get currentUser => _currentUser;
  bool get isAdmin => _currentUser?.id == 999;
  bool get isEditor => false;

  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString("userToken");

    final userJson = prefs.getString("userData");
    if (userJson != null) {
      try {
        final userMap = jsonDecode(userJson);
        _currentUser = UserModel.fromJson(userMap);
        developer.log('User loaded from cache: ${_currentUser?.name}', name: BaseProvider.logTag);
      } catch (e) {
        developer.log('Error loading user from cache: $e', name: BaseProvider.logTag, level: 1000);
      }
    }

    if (_token != null) {
      developer.log('Token found in storage', name: BaseProvider.logTag);
      _fetchProfileInBackground();
    } else {
      developer.log('No token found — user is logged out', name: BaseProvider.logTag);
    }
    notifyListeners();
  }

  Future<void> _saveUserLocally(UserModel user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = jsonEncode(user.toJson());
      await prefs.setString("userData", userJson);
      developer.log('User saved to local storage', name: BaseProvider.logTag);
    } catch (e) {
      developer.log('Error saving user to local storage: $e', name: BaseProvider.logTag, level: 1000);
    }
  }

  Future<void> _saveToken(String newToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("userToken", newToken);
    _token = newToken;
    developer.log('Token saved to storage', name: BaseProvider.logTag);
    notifyListeners();
  }

  Future<void> _clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("userToken");
    await prefs.remove("userData");
    _token = null;
    _currentUser = null;
    developer.log('Token and user data cleared', name: BaseProvider.logTag);
    notifyListeners();
  }

  // ==================== تسجيل الدخول ====================

  Future<bool> login(String email, String password) async {
    startLoading();

    if (email == 'admin@rehlatna.com' && password == 'Admin@2026') {
      developer.log('Admin bypass login used', name: BaseProvider.logTag);
      await Future.delayed(const Duration(seconds: 1));

      final mockUser = UserModel(
        id: 999,
        name: 'مدير النظام',
        email: email,
        phone: '01234567890',
        isVerified: true,
        createdAt: DateTime.now(),
      );

      await _saveToken('admin_token_123456');
      _currentUser = mockUser;
      await _saveUserLocally(mockUser);
      developer.log('Mock admin user loaded: ${_currentUser?.name}', name: BaseProvider.logTag);

      stopLoading();
      return true;
    }

    final data = await postRequest('login', {
      'email': email,
      'password': password,
    });

    if (data != null && data['code'] == 200) {
      if (data['data'] != null && data['data']['acssess_token'] != null) {
        await _saveToken(data['data']['acssess_token']);
        _currentUser = UserModel.fromJson(data['data']);
        await _saveUserLocally(_currentUser!);
        developer.log('User loaded from login response: ${_currentUser?.name}', name: BaseProvider.logTag);
        stopLoading();
        return true;
      } else {
        setError('لم يتم استلام رمز المصادقة من الخادم');
        stopLoading();
        return false;
      }
    } else {
      setError(data?['message'] ?? 'فشل تسجيل الدخول');
      stopLoading();
      return false;
    }
  }

  // ==================== تسجيل حساب جديد ====================

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    startLoading();

    final Map<String, dynamic> body = {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': password,
    };

    if (phone != null && phone.isNotEmpty) {
      body['phone'] = phone;
    }

    final data = await postRequest('register', body);

    if (data != null && data['code'] == 201) {
      if (data['data'] != null && data['data']['acssess_token'] != null) {
        await _saveToken(data['data']['acssess_token']);
        _currentUser = UserModel.fromJson(data['data']);
        await _saveUserLocally(_currentUser!);
        stopLoading();
        return true;
      } else {
        setError('تم إنشاء الحساب ولكن لم يتم استلام رمز المصادقة');
        stopLoading();
        return false;
      }
    } else {
      String errorMsg = data?['message'] ?? 'فشل إنشاء الحساب';
      if (data != null && data['data'] != null && data['data'] is Map) {
        String errors = '';
        (data['data'] as Map).forEach((key, value) {
          if (value is List) {
            errors += '${value.join(', ')}\n';
          } else {
            errors += '$value\n';
          }
        });
        errorMsg = errors;
      }
      setError(errorMsg);
      stopLoading();
      return false;
    }
  }

  // ==================== نسيت كلمة المرور ====================

  Future<bool> forgotPassword(String email) async {
    startLoading();
    try {
      final data = await postFormRequest('forgot-password', {'email': email});
      if (data != null && data['code'] == 201) {
        stopLoading();
        return true;
      } else {
        setError(data?['message'] ?? 'فشل إرسال البريد الإلكتروني');
        stopLoading();
        return false;
      }
    } catch (e) {
      setError('حدث خطأ: $e');
      stopLoading();
      return false;
    }
  }

  // ==================== إعادة تعيين كلمة المرور ====================

  Future<bool> resetPassword({
    required String email,
    required String code,
    required String password,
    required String passwordConfirmation,
  }) async {
    startLoading();
    try {
      final data = await postRequest('reset-password', {
        'email': email,
        'code': code,
        'password': password,
        'password_confirmation': passwordConfirmation,
      });

      if (data != null) {
        if (data['code'] == 200 || data['code'] == 201) {
          stopLoading();
          return true;
        }
        if (data['message'] == 'Invalid code') {
          setError('الكود غير صحيح أو منتهي الصلاحية');
          stopLoading();
          return false;
        }
        if (data['code'] == 422 && data['data'] != null) {
          String errorMsg = 'البيانات المدخلة غير صحيحة';
          if (data['data']['password'] != null) {
            errorMsg = data['data']['password'] is List
                ? data['data']['password'][0]
                : data['data']['password'].toString();
          }
          setError(errorMsg);
          stopLoading();
          return false;
        }
      }
      setError('فشل إعادة تعيين كلمة المرور');
      stopLoading();
      return false;
    } catch (e) {
      setError('حدث خطأ: $e');
      stopLoading();
      return false;
    }
  }

  // ==================== جلب بيانات المستخدم ====================

  Future<void> _fetchProfileInBackground() async {
    if (_token == null) return;
    try {
      final data = await getRequest('profile', token: _token);
      if (data != null && data['code'] == 200 && data['data'] != null) {
        _currentUser = UserModel.fromJson(data['data']);
        await _saveUserLocally(_currentUser!);
        developer.log('Profile refreshed in background: ${_currentUser?.name}', name: BaseProvider.logTag);
        notifyListeners();
      }
    } catch (e) {
      developer.log('Background profile fetch error: $e', name: BaseProvider.logTag, level: 900);
    }
  }

  Future<void> getCurrentUser() async {
    if (_token == null) return;
    final data = await getRequest('profile', token: _token);
    if (data != null && data['code'] == 200 && data['data'] != null) {
      _currentUser = UserModel.fromJson(data['data']);
      await _saveUserLocally(_currentUser!);
      developer.log('User profile loaded: ${_currentUser?.name}', name: BaseProvider.logTag);
    }
    notifyListeners();
  }

  // ==================== تسجيل الخروج ====================

  Future<void> logout() async {
    startLoading();
    try {
      if (_token != null) {
        await postRequestWithTimeout('logout', {}, token: _token);
      }
    } catch (e) {
      developer.log('Logout error (continuing): $e', name: BaseProvider.logTag, level: 1000);
    } finally {
      await _clearToken();
      stopLoading();
    }
  }

  Future<void> signOut() async {
    await logout();
  }

  // ==================== FCM Token ====================

  Future<bool> updateFcmToken(String fcmToken) async {
    if (_token == null) {
      developer.log('Cannot update FCM token: No auth token', name: BaseProvider.logTag, level: 1000);
      return false;
    }

    startLoading();

    try {
      final data = await postRequest('update-fcm-token', {
        'fcm_token': fcmToken,
      }, token: _token);

      if (data != null && data['code'] == 200) {
        developer.log('FCM token updated successfully', name: BaseProvider.logTag);
        stopLoading();
        return true;
      } else {
        developer.log('Failed to update FCM token', name: BaseProvider.logTag, level: 1000);
        setError(data?['message'] ?? 'فشل تحديث رمز الإشعارات');
        stopLoading();
        return false;
      }
    } catch (e) {
      developer.log('Error updating FCM token: $e', name: BaseProvider.logTag, level: 1000);
      setError('حدث خطأ: $e');
      stopLoading();
      return false;
    }
  }
}