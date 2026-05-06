import 'dart:developer' as developer;
import '../models/item_model.dart';
import 'base_provider.dart';

class FeaturesProvider extends BaseProvider {
  List<ItemModel> _features = [];
  bool _hasLoadedOnce = false;

  List<ItemModel> get features => _features;
  bool get hasLoadedOnce => _hasLoadedOnce;

  Future<void> fetchFeatures() async {
    startLoading();

    final data = await getRequest('items-features?number=');

    if (data != null && data['code'] == 200 && data['data'] != null) {
      final featuresData = data['data'] as List;
      _features = featuresData
          .map((item) => ItemModel.fromFeatureJson(item))
          .toList();
      developer.log('Loaded ${_features.length} features', name: BaseProvider.logTag);
    }

    _hasLoadedOnce = true;
    stopLoading();
  }
}