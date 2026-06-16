import '../../domain/entities/prayer_record.dart';

class PrayerRecordModel {
  final String id;
  final String date;
  final Map<String, int> prayers;
  final DateTime lastUpdated;

  PrayerRecordModel({
    required this.id,
    required this.date,
    required this.prayers,
    required this.lastUpdated,
  });

  factory PrayerRecordModel.fromEntity(PrayerRecord record) {
    final prayersMap = <String, int>{};
    record.prayers.forEach((key, status) {
      prayersMap[key] = status.value;
    });

    return PrayerRecordModel(
      id: record.id,
      date: record.date,
      prayers: prayersMap,
      lastUpdated: record.lastUpdated,
    );
  }

  PrayerRecord toEntity() {
    final prayersMap = <String, PrayerStatus>{};
    prayers.forEach((key, value) {
      prayersMap[key] = _intToPrayerStatus(value);
    });

    return PrayerRecord(
      id: id,
      date: date,
      prayers: prayersMap,
      lastUpdated: lastUpdated,
    );
  }

  PrayerStatus _intToPrayerStatus(int value) {
    switch (value) {
      case 0:
        return PrayerStatus.notPrayed;
      case 1:
        return PrayerStatus.qada;
      case 2:
        return PrayerStatus.prayed;
      default:
        return PrayerStatus.notPrayed;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'prayers': prayers,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory PrayerRecordModel.fromJson(Map<String, dynamic> json) {
    return PrayerRecordModel(
      id: json['id'] as String,
      date: json['date'] as String,
      prayers: Map<String, int>.from(json['prayers'] as Map),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );
  }
}