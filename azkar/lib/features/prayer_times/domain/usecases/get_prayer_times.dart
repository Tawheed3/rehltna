import 'package:dartz/dartz.dart';
import '../entities/prayer_times.dart';
import '../repositories/prayer_times_repository.dart';

class GetPrayerTimesByLocation {
  final PrayerTimesRepository repository;

  GetPrayerTimesByLocation(this.repository);

  Future<Either<String, PrayerTimes>> call({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final prayerTimes = await repository.getPrayerTimesByLocation(
        latitude: latitude,
        longitude: longitude,
      );
      return Right(prayerTimes);
    } catch (e) {
      return Left(e.toString());
    }
  }
}