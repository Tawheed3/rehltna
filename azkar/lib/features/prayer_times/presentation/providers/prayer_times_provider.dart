import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/prayer_times_remote_datasource.dart';
import '../../domain/entities/prayer_times.dart';
import '../../domain/repositories/prayer_times_repository.dart';
import '../../domain/repositories/prayer_times_repository_impl.dart';
import '../../domain/usecases/get_prayer_times.dart';

// DataSource Provider
final prayerTimesRemoteDatasourceProvider = Provider<PrayerTimesRemoteDatasource>((ref) {
  return PrayerTimesRemoteDatasource();
});

// Repository Provider
final prayerTimesRepositoryProvider = Provider<PrayerTimesRepository>((ref) {
  return PrayerTimesRepositoryImpl(
    remoteDatasource: ref.read(prayerTimesRemoteDatasourceProvider),
  );
});

// UseCase Provider
final getPrayerTimesByLocationProvider = Provider<GetPrayerTimesByLocation>((ref) {
  return GetPrayerTimesByLocation(ref.read(prayerTimesRepositoryProvider));
});

// State Provider for UI
final prayerTimesStateProvider = StateNotifierProvider<PrayerTimesNotifier, PrayerTimesState>((ref) {
  return PrayerTimesNotifier(
    getPrayerTimes: ref.read(getPrayerTimesByLocationProvider),
  );
});

// State Classes
class PrayerTimesState {
  final bool isLoading;
  final PrayerTimes? prayerTimes;
  final String? error;
  final double? latitude;
  final double? longitude;

  const PrayerTimesState({
    this.isLoading = false,
    this.prayerTimes,
    this.error,
    this.latitude,
    this.longitude,
  });

  PrayerTimesState copyWith({
    bool? isLoading,
    PrayerTimes? prayerTimes,
    String? error,
    double? latitude,
    double? longitude,
  }) {
    return PrayerTimesState(
      isLoading: isLoading ?? this.isLoading,
      prayerTimes: prayerTimes ?? this.prayerTimes,
      error: error ?? this.error,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}

// Notifier
class PrayerTimesNotifier extends StateNotifier<PrayerTimesState> {
  final GetPrayerTimesByLocation getPrayerTimes;

  PrayerTimesNotifier({required this.getPrayerTimes}) : super(const PrayerTimesState());

  Future<void> fetchPrayerTimes({
    required double latitude,
    required double longitude,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await getPrayerTimes(
      latitude: latitude,
      longitude: longitude,
    );

    result.fold(
          (error) => state = state.copyWith(
        isLoading: false,
        error: error,
      ),
          (prayerTimes) => state = state.copyWith(
        isLoading: false,
        prayerTimes: prayerTimes,
        latitude: latitude,
        longitude: longitude,
      ),
    );
  }

  // دالة لتحميل البيانات المخزنة
  void setCachedData({required PrayerTimes prayerTimes}) {
    state = PrayerTimesState(
      isLoading: false,
      prayerTimes: prayerTimes,
      error: null,
      latitude: prayerTimes.latitude,
      longitude: prayerTimes.longitude,
    );
    print('✅ تم تحميل البيانات المخزنة إلى الـ Provider');
  }

  // إعادة تعيين الحالة
  void reset() {
    state = const PrayerTimesState();
  }
}