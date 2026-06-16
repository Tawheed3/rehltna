import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/prayer_record.dart';
import '../../domain/repositories/tracker_repository.dart';
import '../../domain/repositories/tracker_repository_impl.dart';
import '../../domain/usecases/get_today_records.dart';
import '../../domain/usecases/get_weekly_stats.dart';
import '../../domain/usecases/update_prayer_status.dart';

// Repository Provider (Singleton)
final trackerRepositoryProvider = Provider<TrackerRepository>((ref) {
  return TrackerRepositoryImpl();
});

// UseCases Providers
final getTodayRecordsProvider = Provider<GetTodayRecords>((ref) {
  return GetTodayRecords(ref.read(trackerRepositoryProvider));
});

final updatePrayerStatusProvider = Provider<UpdatePrayerStatus>((ref) {
  return UpdatePrayerStatus(ref.read(trackerRepositoryProvider));
});

final getWeeklyStatsProvider = Provider<GetWeeklyStats>((ref) {
  return GetWeeklyStats(ref.read(trackerRepositoryProvider));
});

// State Provider
final trackerStateProvider = StateNotifierProvider<TrackerNotifier, TrackerState>((ref) {
  return TrackerNotifier(
    getTodayRecords: ref.read(getTodayRecordsProvider),
    updatePrayerStatus: ref.read(updatePrayerStatusProvider),
    getWeeklyStats: ref.read(getWeeklyStatsProvider),
  );
});

// State Class
class TrackerState {
  final bool isLoading;
  final PrayerRecord? todayRecord;
  final List<PrayerRecord> weeklyRecords;
  final String? error;

  const TrackerState({
    this.isLoading = false,
    this.todayRecord,
    this.weeklyRecords = const [],
    this.error,
  });

  TrackerState copyWith({
    bool? isLoading,
    PrayerRecord? todayRecord,
    List<PrayerRecord>? weeklyRecords,
    String? error,
  }) {
    return TrackerState(
      isLoading: isLoading ?? this.isLoading,
      todayRecord: todayRecord ?? this.todayRecord,
      weeklyRecords: weeklyRecords ?? this.weeklyRecords,
      error: error ?? this.error,
    );
  }

  double get dailyProgress {
    if (todayRecord == null) return 0;
    return todayRecord!.completionPercentage;
  }

  double get weeklyProgress {
    if (weeklyRecords.isEmpty) return 0;
    final total = weeklyRecords.fold<double>(0, (sum, record) => sum + record.completionPercentage);
    return total / weeklyRecords.length;
  }

  int get completeDaysCount {
    return weeklyRecords.where((record) => record.isComplete).length;
  }
}

// Notifier
class TrackerNotifier extends StateNotifier<TrackerState> {
  final GetTodayRecords getTodayRecords;
  final UpdatePrayerStatus updatePrayerStatus;
  final GetWeeklyStats getWeeklyStats;

  TrackerNotifier({
    required this.getTodayRecords,
    required this.updatePrayerStatus,
    required this.getWeeklyStats,
  }) : super(const TrackerState()) {
    loadData();
  }

  Future<void> loadData() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final todayRecord = await getTodayRecords();
      final weeklyRecords = await getWeeklyStats();

      state = state.copyWith(
        isLoading: false,
        todayRecord: todayRecord,
        weeklyRecords: weeklyRecords,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> togglePrayerStatus(String prayerName) async {
    if (state.todayRecord == null) return;

    final currentStatus = state.todayRecord!.prayers[prayerName] ?? PrayerStatus.notPrayed;
    PrayerStatus newStatus;

    switch (currentStatus) {
      case PrayerStatus.notPrayed:
        newStatus = PrayerStatus.prayed;
        break;
      case PrayerStatus.prayed:
        newStatus = PrayerStatus.qada;
        break;
      case PrayerStatus.qada:
        newStatus = PrayerStatus.notPrayed;
        break;
    }

    final today = DateTime.now();
    final dateString = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    try {
      final updatedRecord = await updatePrayerStatus(
        date: dateString,
        prayerName: prayerName,
        status: newStatus,
      );

      state = state.copyWith(todayRecord: updatedRecord);

      // تحديث الأسبوع
      final weeklyRecords = await getWeeklyStats();
      state = state.copyWith(weeklyRecords: weeklyRecords);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}