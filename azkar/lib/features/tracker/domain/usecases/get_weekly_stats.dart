import '../entities/prayer_record.dart';
import '../repositories/tracker_repository.dart';

class GetWeeklyStats {
  final TrackerRepository repository;

  GetWeeklyStats(this.repository);

  Future<List<PrayerRecord>> call() async {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    return await repository.getRecordsForWeek(startOfWeek);
  }
}