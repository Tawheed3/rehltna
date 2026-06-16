import 'package:equatable/equatable.dart';

enum PrayerStatus {
  notPrayed,   // لم يُصلى
  prayed,      // صليت
  qada,        // قضاء
}

extension PrayerStatusExtension on PrayerStatus {
  String get arabicName {
    switch (this) {
      case PrayerStatus.notPrayed:
        return 'لم يُصلى';
      case PrayerStatus.prayed:
        return 'صليت ✅';
      case PrayerStatus.qada:
        return 'قضاء ⏰';
    }
  }

  String get englishName {
    switch (this) {
      case PrayerStatus.notPrayed:
        return 'Not Prayed';
      case PrayerStatus.prayed:
        return 'Prayed';
      case PrayerStatus.qada:
        return 'Qada';
    }
  }

  int get value {
    switch (this) {
      case PrayerStatus.notPrayed:
        return 0;
      case PrayerStatus.prayed:
        return 2;
      case PrayerStatus.qada:
        return 1;
    }
  }
}

class PrayerRecord extends Equatable {
  final String id;
  final String date;
  final Map<String, PrayerStatus> prayers;
  final DateTime lastUpdated;

  const PrayerRecord({
    required this.id,
    required this.date,
    required this.prayers,
    required this.lastUpdated,
  });

  int get prayedCount {
    return prayers.values.where((s) => s == PrayerStatus.prayed).length;
  }

  int get qadaCount {
    return prayers.values.where((s) => s == PrayerStatus.qada).length;
  }

  double get completionPercentage {
    final total = prayers.length * 2;
    final score = prayers.values.fold(0, (sum, status) => sum + status.value);
    return total > 0 ? (score / total) * 100 : 0;
  }

  bool get isComplete {
    return prayers.values.every((s) => s != PrayerStatus.notPrayed);
  }

  factory PrayerRecord.createNew(String date) {
    return PrayerRecord(
      id: date,
      date: date,
      prayers: {
        'Fajr': PrayerStatus.notPrayed,
        'Dhuhr': PrayerStatus.notPrayed,
        'Asr': PrayerStatus.notPrayed,
        'Maghrib': PrayerStatus.notPrayed,
        'Isha': PrayerStatus.notPrayed,
      },
      lastUpdated: DateTime.now(),
    );
  }

  PrayerRecord copyWith({
    String? id,
    String? date,
    Map<String, PrayerStatus>? prayers,
    DateTime? lastUpdated,
  }) {
    return PrayerRecord(
      id: id ?? this.id,
      date: date ?? this.date,
      prayers: prayers ?? this.prayers,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  List<Object?> get props => [id, date, prayers, lastUpdated];
}