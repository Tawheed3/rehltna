// WHY: Centralize all constants to avoid magic strings and easy maintenance
class AppConstants {
  static const String appName = 'Islamic Dawah';
  static const String sharedPrefsKey = 'islamic_app_prefs';

  // API Constants
  static const String aladhanApiBaseUrl = 'https://api.aladhan.com/v1';
  static const int apiTimeoutSeconds = 30;

  // Prayer Names
  static const List<String> prayerNames = [
    'Fajr',
    'Dhuhr',
    'Asr',
    'Maghrib',
    'Isha'
  ];

  // Database Box Names
  static const String prayerTrackerBox = 'prayer_tracker';
  static const String adhkarBox = 'adhkar';
  static const String userPreferencesBox = 'user_preferences';

  // Donation Message
  static const String donationMessage =
      'This app is a Sadaqah Jariyah donated by Al-Mansouri Family. '
      'Please remember us in your Du\'a. 🤲';
}