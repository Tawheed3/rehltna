// نموذج مبسط جداً لبيانات أوقات الصلاة
class PrayerTimesModel {
  final int code;
  final String status;
  final Map<String, dynamic> data;

  PrayerTimesModel({
    required this.code,
    required this.status,
    required this.data,
  });

  factory PrayerTimesModel.fromJson(Map<String, dynamic> json) {
    return PrayerTimesModel(
      code: json['code'] ?? 0,
      status: json['status'] ?? '',
      data: json['data'] ?? {},
    );
  }

  // جلب أوقات الصلاة من البيانات
  Map<String, String> getTimings() {
    final timings = data['timings'] as Map<String, dynamic>? ?? {};
    return {
      'Fajr': timings['Fajr']?.toString() ?? '--:--',
      'Sunrise': timings['Sunrise']?.toString() ?? '--:--',
      'Dhuhr': timings['Dhuhr']?.toString() ?? '--:--',
      'Asr': timings['Asr']?.toString() ?? '--:--',
      'Maghrib': timings['Maghrib']?.toString() ?? '--:--',
      'Isha': timings['Isha']?.toString() ?? '--:--',
    };
  }

  // جلب التاريخ الميلادي
  String getGregorianDate() {
    final date = data['date'] as Map<String, dynamic>? ?? {};
    final gregorian = date['gregorian'] as Map<String, dynamic>? ?? {};
    return gregorian['date']?.toString() ?? 'Unknown date';
  }

  // جلب التاريخ الهجري
  String getHijriDate() {
    final date = data['date'] as Map<String, dynamic>? ?? {};
    final hijri = date['hijri'] as Map<String, dynamic>? ?? {};
    final day = hijri['day']?.toString() ?? '';
    final month = hijri['month']?['en']?.toString() ?? '';
    final year = hijri['year']?.toString() ?? '';
    return '$day $month $year';
  }
// جلب اليوم من API
  String getWeekday() {
    try {
      final date = data['date'] as Map<String, dynamic>? ?? {};
      final gregorian = date['gregorian'] as Map<String, dynamic>? ?? {};
      final weekday = gregorian['weekday']?['en']?.toString() ?? '';
      return weekday;
    } catch (e) {
      return '';
    }
  }
}