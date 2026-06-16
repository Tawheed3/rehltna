import 'package:equatable/equatable.dart';

class PrayerTimes extends Equatable {
  final String fajr;
  final String sunrise;
  final String dhuhr;
  final String asr;
  final String maghrib;
  final String isha;
  final String date;
  final String hijriDate;
  final double latitude;
  final double longitude;

  const PrayerTimes({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    required this.date,
    required this.hijriDate,
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [
    fajr, sunrise, dhuhr, asr, maghrib, isha, date, hijriDate, latitude, longitude
  ];
}