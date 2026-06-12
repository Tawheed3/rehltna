import 'dart:developer' as developer;
import '../models/slider_model.dart';
import 'base_provider.dart';

class SliderProvider extends BaseProvider {
  List<SliderModel> _sliders = [];
  bool _hasLoadedOnce = false;

  List<SliderModel> get sliders => _sliders;
  bool get hasLoadedOnce => _hasLoadedOnce;

  Future<void> fetchSliders() async {
    startLoading();

    final data = await getCachedRequest('sliders');

    if (data != null && data['code'] == 200 && data['data'] != null) {
      final slidersData = data['data'] as List;
      _sliders = slidersData
          .map((item) => SliderModel.fromJson(item))
          .toList();
      developer.log('Loaded ${_sliders.length} sliders', name: BaseProvider.logTag);
    }

    _hasLoadedOnce = true;
    stopLoading();
  }
}