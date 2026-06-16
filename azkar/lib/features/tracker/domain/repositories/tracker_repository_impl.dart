import 'dart:convert';
import 'package:hive/hive.dart';
import '../../data/models/prayer_record_model.dart';
import '../../domain/entities/prayer_record.dart';
import '../../domain/repositories/tracker_repository.dart';

class TrackerRepositoryImpl implements TrackerRepository {
  static Box<String>? _box;
  static bool _isInitialized = false;

  TrackerRepositoryImpl() {
    _init();
  }

  Future<void> _init() async {
    if (_isInitialized && _box != null) return;

    try {
      // ✅ استخدام isBoxOpen للتحقق بدلاً من المحاولة المباشرة
      if (Hive.isBoxOpen('prayer_tracker')) {
        _box = Hive.box<String>('prayer_tracker');
      } else {
        _box = await Hive.openBox<String>('prayer_tracker');
      }
      _isInitialized = true;
      print('✅ Box prayer_tracker initialized successfully');
    } catch (e) {
      print('❌ Error initializing box: $e');
      _isInitialized = false;
    }
  }

  Future<void> _ensureInitialized() async {
    if (!_isInitialized || _box == null) {
      await _init();
    }
  }

  @override
  Future<void> saveRecord(PrayerRecord record) async {
    await _ensureInitialized();
    if (_box == null) {
      print('❌ Box is null, cannot save');
      return;
    }

    final model = PrayerRecordModel.fromEntity(record);
    final jsonString = jsonEncode(model.toJson());
    await _box!.put(record.id, jsonString);
    print('✅ تم حفظ سجل الصلاة لليوم: ${record.date}');
  }

  @override
  Future<PrayerRecord?> getRecordByDate(String date) async {
    await _ensureInitialized();
    if (_box == null) return null;

    final jsonString = _box!.get(date);
    if (jsonString != null) {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      final model = PrayerRecordModel.fromJson(json);
      return model.toEntity();
    }
    return null;
  }

  @override
  Future<PrayerRecord?> updatePrayerStatus(
      String date,
      String prayerName,
      PrayerStatus status,
      ) async {
    await _ensureInitialized();
    if (_box == null) {
      print('❌ Box not initialized, creating record without storage');
      // إنشاء سجل مؤقت بدون حفظ
      final record = PrayerRecord.createNew(date);
      record.prayers[prayerName] = status;
      return record;
    }

    final existing = await getRecordByDate(date);
    PrayerRecord record;

    if (existing != null) {
      final updatedPrayers = Map<String, PrayerStatus>.from(existing.prayers);
      updatedPrayers[prayerName] = status;

      record = existing.copyWith(
        prayers: updatedPrayers,
        lastUpdated: DateTime.now(),
      );
    } else {
      record = PrayerRecord.createNew(date);
      record.prayers[prayerName] = status;
    }

    await saveRecord(record);
    return record;
  }

  @override
  Future<List<PrayerRecord>> getRecordsForWeek(DateTime startDate) async {
    await _ensureInitialized();
    final records = <PrayerRecord>[];

    for (int i = 0; i < 7; i++) {
      final date = startDate.add(Duration(days: i));
      final dateString = _formatDate(date);
      final record = await getRecordByDate(dateString);

      if (record != null) {
        records.add(record);
      } else {
        records.add(PrayerRecord.createNew(dateString));
      }
    }

    return records;
  }

  @override
  Future<List<PrayerRecord>> getAllRecords() async {
    await _ensureInitialized();
    if (_box == null) return [];

    final records = <PrayerRecord>[];
    for (var key in _box!.keys) {
      final jsonString = _box!.get(key);
      if (jsonString != null) {
        final json = jsonDecode(jsonString) as Map<String, dynamic>;
        final model = PrayerRecordModel.fromJson(json);
        records.add(model.toEntity());
      }
    }
    return records;
  }

  @override
  Future<void> deleteRecord(String date) async {
    await _ensureInitialized();
    if (_box == null) return;

    await _box!.delete(date);
    print('✅ تم حذف سجل الصلاة لليوم: $date');
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}