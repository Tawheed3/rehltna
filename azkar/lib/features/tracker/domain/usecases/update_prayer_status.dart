import '../entities/prayer_record.dart';
import '../repositories/tracker_repository.dart';

class UpdatePrayerStatus {
  final TrackerRepository repository;

  UpdatePrayerStatus(this.repository);

  Future<PrayerRecord> call({
    required String date,
    required String prayerName,
    required PrayerStatus status,
  }) async {
    final record = await repository.updatePrayerStatus(date, prayerName, status);
    return record ?? PrayerRecord.createNew(date);
  }
}