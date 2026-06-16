import '../entities/prayer_record.dart';

abstract class TrackerRepository {
  // حفظ سجل اليوم
  Future<void> saveRecord(PrayerRecord record);

  // جلب سجل اليوم
  Future<PrayerRecord?> getRecordByDate(String date);

  // جلب سجلات الأسبوع
  Future<List<PrayerRecord>> getRecordsForWeek(DateTime startDate);

  // تحديث حالة صلاة معينة
  Future<PrayerRecord?> updatePrayerStatus(
      String date,
      String prayerName,
      PrayerStatus status,
      );

  // جلب جميع السجلات
  Future<List<PrayerRecord>> getAllRecords();

  // حذف سجل
  Future<void> deleteRecord(String date);
}