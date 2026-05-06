import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import 'auth_provider.dart';
import 'base_provider.dart';

class UserProvider extends BaseProvider {
  UserModel? _user;
  final AuthProvider authProvider;

  UserModel? get user => _user;

  UserProvider({required this.authProvider});

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

  Future<bool> updateProfile(Map<String, dynamic> data) async {
    final token = authProvider.token;
    if (token == null) return false;

    startLoading();

    final result = await postRequest('profile/update', data, token: token);
    bool success = false;

    if (result != null && result['code'] == 200) {
      success = await fetchProfile();
    }

    stopLoading();
    return success;
  }

  Future<Map<String, dynamic>?> getRequest(String endpoint, {String? token}) async {
    final useToken = token ?? authProvider.token;
    if (useToken == null) return null;
    return super.getRequest(endpoint, token: useToken);
  }
}