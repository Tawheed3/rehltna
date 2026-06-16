import '../entities/prayer_times.dart';

abstract class PrayerTimesRepository {
  Future<PrayerTimes> getPrayerTimesByLocation({
    required double latitude,
    required double longitude,
  });

  Future<PrayerTimes> getPrayerTimesByCity({
    required String city,
    required String country,
  });
}