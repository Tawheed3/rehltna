import 'dart:developer' as developer;
import '../models/pixel_model.dart';
import 'base_provider.dart';

class PixelProvider extends BaseProvider {
  List<PixelModel> _pixels = [];

  List<PixelModel> get pixels => _pixels;

  // جلب pixels scripts
  Future<void> fetchPixels() async {
    startLoading();

    final data = await getRequest('pixels-scripts');

    if (data != null && data['code'] == 200 && data['data'] != null) {
      final pixelsData = data['data'] as List;
      _pixels = pixelsData.map((item) => PixelModel.fromJson(item)).toList();
      developer.log('Loaded ${_pixels.length} pixel scripts', name: BaseProvider.logTag);
    }

    stopLoading();
  }

  // الحصول على جميع الأكواد النشطة
  String getAllActiveScripts() {
    String scripts = '';
    for (var pixel in _pixels) {
      if (pixel.isActive) {
        scripts += pixel.getAllScripts();
      }
    }
    return scripts;
  }
}