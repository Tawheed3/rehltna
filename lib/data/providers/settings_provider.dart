import 'dart:developer' as developer;
import '../models/settings_model.dart';
import 'base_provider.dart';

class SettingsProvider extends BaseProvider {
  SettingsModel? _settings;
  bool _hasLoadedOnce = false;

  SettingsModel? get settings => _settings;
  bool get hasLoadedOnce => _hasLoadedOnce;

  Future<void> fetchSettings() async {
    startLoading();

    final data = await getRequest('settings');

    if (data != null && data['code'] == 200 && data['data'] != null) {
      _settings = SettingsModel.fromJson(data['data']);
      developer.log('Settings loaded: ${_settings?.siteNameAr}', name: BaseProvider.logTag);
    }

    _hasLoadedOnce = true;
    stopLoading();
  }
}