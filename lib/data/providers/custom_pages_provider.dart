import 'dart:developer' as developer;
import '../models/custom_page_model.dart';
import 'base_provider.dart';

class CustomPagesProvider extends BaseProvider {
  List<CustomPageModel> _pages = [];
  bool _hasLoadedOnce = false;

  List<CustomPageModel> get pages => _pages;
  bool get hasLoadedOnce => _hasLoadedOnce;

  Future<void> fetchCustomPages() async {
    if (_hasLoadedOnce && _pages.isNotEmpty) {
      developer.log('📋 Custom pages already loaded (${_pages.length})', name: BaseProvider.logTag);
      return;
    }

    startLoading();

    final data = await getRequest('custom-pages');

    if (data != null && data['code'] == 200 && data['data'] != null) {
      _pages = (data['data'] as List)
          .map((item) => CustomPageModel.fromJson(item))
          .toList();
      _hasLoadedOnce = true;
      developer.log('✅ Loaded ${_pages.length} custom pages', name: BaseProvider.logTag);
    }

    stopLoading();
  }

  CustomPageModel? getPageBySlug(String slug) {
    try {
      return _pages.firstWhere((p) => p.slug == slug);
    } catch (e) {
      return null;
    }
  }

  CustomPageModel? getPrivacyPolicy() => getPageBySlug('Privacy');
  CustomPageModel? getTermsAndConditions() => getPageBySlug('terms-conditions');
}