import '../../data/datasources/prayer_times_remote_datasource.dart';
import '../../domain/entities/prayer_times.dart';
import '../../domain/repositories/prayer_times_repository.dart';

class PrayerTimesRepositoryImpl implements PrayerTimesRepository {
  final PrayerTimesRemoteDatasource remoteDatasource;

  PrayerTimesRepositoryImpl({required this.remoteDatasource});

  // قائمة طرق الحساب المتاحة
  final List<Map<String, dynamic>> _methods = [
    {'id': 5, 'name': 'MWL - رابطة العالم الإسلامي'},
    {'id': 2, 'name': 'ISNA - أمريكا الشمالية'},
    {'id': 14, 'name': 'Egypt - الهيئة المصرية'},
    {'id': 1, 'name': 'Karachi - جامعة كراتشي'},
    {'id': 3, 'name': 'Makkah - أم القرى'},
  ];

  @override
  Future<PrayerTimes> getPrayerTimesByLocation({
    required double latitude,
    required double longitude,
  }) async {
    PrayerTimes? bestResult;

    // جرب كل الطرق
    for (var method in _methods) {
      try {
        print('🔄 جرب طريقة: ${method['name']}');

        final model = await remoteDatasource.getPrayerTimesByCoordinates(
          latitude: latitude,
          longitude: longitude,
          method: method['id'],
        );

        final timings = model.getTimings();

        print('   الفجر: ${timings['Fajr']}');
        print('   الظهر: ${timings['Dhuhr']}');
        print('   العصر: ${timings['Asr']}');
        print('   المغرب: ${timings['Maghrib']}');
        print('   العشاء: ${timings['Isha']}');

        // استخدم أول طريقة ناجحة
        if (bestResult == null) {
          bestResult = PrayerTimes(
            fajr: timings['Fajr'] ?? '--:--',
            sunrise: timings['Sunrise'] ?? '--:--',
            dhuhr: timings['Dhuhr'] ?? '--:--',
            asr: timings['Asr'] ?? '--:--',
            maghrib: timings['Maghrib'] ?? '--:--',
            isha: timings['Isha'] ?? '--:--',
            date: model.getGregorianDate(),
            hijriDate: model.getHijriDate(),
            latitude: latitude,
            longitude: longitude,
          );
        }
      } catch (e) {
        print('❌ فشلت طريقة ${method['name']}: $e');
      }
    }

    if (bestResult != null) {
      print('✅ تم استخدام أوقات الصلاة من أول طريقة ناجحة');
      return bestResult;
    }

    throw Exception('فشل جلب أوقات الصلاة من جميع الطرق');
  }

  @override
  Future<PrayerTimes> getPrayerTimesByCity({
    required String city,
    required String country,
  }) async {
    throw UnimplementedError();
  }
}