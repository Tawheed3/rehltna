import 'package:dio/dio.dart';
import '../../../../core/constants/app_constants.dart';
import '../models/prayer_times_model.dart';

class PrayerTimesRemoteDatasource {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: AppConstants.aladhanApiBaseUrl,
    connectTimeout: const Duration(seconds: AppConstants.apiTimeoutSeconds),
    receiveTimeout: const Duration(seconds: AppConstants.apiTimeoutSeconds),
  ));

  Future<PrayerTimesModel> getPrayerTimesByCoordinates({
    required double latitude,
    required double longitude,
    required int method,
  }) async {
    try {
      final response = await _dio.get(
        '/timings/today',
        queryParameters: {
          'latitude': latitude,
          'longitude': longitude,
          'method': method,
          'school': 1,
          'midnightMode': 1,
          'adjustment': 0,
          // ✅ إضافة المنطقة الزمنية لمصر
          'timezonestring': 'Africa/Cairo',
          // ✅ إضافة الإحداثيات بدقة
          'latitudeAdjustmentMethod': 'ANGLE_BASED',
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        // طباعة المنطقة الزمنية من API للتحقق
        final meta = response.data['data']['meta'];
        print('🌍 المنطقة الزمنية من API: ${meta['timezone']}');
        print('🕌 الفجر (API): ${response.data['data']['timings']['Fajr']}');

        return PrayerTimesModel.fromJson(response.data);
      } else {
        throw Exception('Failed to load prayer times');
      }
    } on DioException catch (e) {
      print('❌ خطأ في الشبكة: ${e.message}');
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      print('❌ خطأ غير متوقع: $e');
      throw Exception('Unexpected error: $e');
    }
  }
}