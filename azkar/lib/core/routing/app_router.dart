import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// استيراد الشاشات
import '../../features/home/screens/home_screen.dart';
import '../../features/prayer_times/presentation/screens/prayer_times_screen.dart';
import '../../features/tracker/presentation/screens/tracker_screen.dart';
import '../../features/quran/presentation/screens/quran_screen.dart';
import '../../features/quran/presentation/screens/quran_mushaf_screen.dart';
import '../../features/test/screens/service_test_screen.dart';
import '../../features/about/screens/about_screen.dart';

class AdhkarScreen extends StatelessWidget {
  const AdhkarScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Adhkar')),
      body: const Center(child: Text('Adhkar - Coming in Phase 6')),
    );
  }
}

class QiblaScreen extends StatelessWidget {
  const QiblaScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Qibla Direction')),
      body: const Center(child: Text('Qibla Direction - Coming in Phase 7')),
    );
  }
}

class AppRouter {
  static const String home = '/';
  static const String prayerTimes = '/prayer-times';
  static const String tracker = '/tracker';
  static const String quran = '/quran';
  static const String quranDetail = '/quran/:surahId';
  static const String adhkar = '/adhkar';
  static const String qibla = '/qibla';
  static const String about = '/about';
  static const String serviceTest = '/service-test';

  static final GoRouter router = GoRouter(
    initialLocation: home,
    routes: [
      GoRoute(
        name: 'home',
        path: home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        name: 'prayer-times',
        path: prayerTimes,
        builder: (context, state) => const PrayerTimesScreen(),
      ),
      GoRoute(
        name: 'tracker',
        path: tracker,
        builder: (context, state) => const TrackerScreen(),
      ),
      GoRoute(
        name: 'quran',
        path: quran,
        builder: (context, state) => const QuranScreen(),
      ),
      GoRoute(
        name: 'quran-detail',
        path: quranDetail,
        builder: (context, state) {
          final surahId = int.parse(state.pathParameters['surahId']!);
          return QuranMushafScreen(surahId: surahId);
        },
      ),
      GoRoute(
        name: 'adhkar',
        path: adhkar,
        builder: (context, state) => const AdhkarScreen(),
      ),
      GoRoute(
        name: 'qibla',
        path: qibla,
        builder: (context, state) => const QiblaScreen(),
      ),
      GoRoute(
        name: 'service-test',
        path: serviceTest,
        builder: (context, state) => const ServiceTestScreen(),
      ),
      GoRoute(
        name: 'about',
        path: about,
        builder: (context, state) => const AboutScreen(),
      ),
    ],
  );
}