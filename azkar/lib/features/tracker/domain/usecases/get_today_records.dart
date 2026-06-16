import '../entities/prayer_record.dart';
import '../repositories/tracker_repository.dart';

class GetTodayRecords {
  final TrackerRepository repository;

  GetTodayRecords(this.repository);

  Future<PrayerRecord> call() async {
    final today = DateTime.now();
    final dateString = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    final existing = await repository.getRecordByDate(dateString);
    if (existing != null) {
      return existing;
    }

    return PrayerRecord.createNew(dateString);
  }
}