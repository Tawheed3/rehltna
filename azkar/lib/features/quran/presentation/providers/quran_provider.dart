import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/quran_local_datasource.dart';
import '../../data/repositories/quran_repository_impl.dart';
import '../../domain/entities/surah.dart';
import '../../domain/repositories/quran_repository.dart';
import '../../domain/usecases/get_surahs.dart';

// DataSource Provider
final quranLocalDatasourceProvider = Provider<QuranLocalDatasource>((ref) {
  return QuranLocalDatasource();
});

// Repository Provider
final quranRepositoryProvider = Provider<QuranRepository>((ref) {
  return QuranRepositoryImpl(
    datasource: ref.read(quranLocalDatasourceProvider),
  );
});

// UseCase Provider
final getSurahsProvider = Provider<GetSurahs>((ref) {
  return GetSurahs(ref.read(quranRepositoryProvider));
});

// State Provider
final quranStateProvider = StateNotifierProvider<QuranNotifier, QuranState>((ref) {
  return QuranNotifier(
    getSurahs: ref.read(getSurahsProvider),
  );
});

// State Class
class QuranState {
  final bool isLoading;
  final List<Surah> surahs;
  final List<Surah> filteredSurahs;
  final String? error;
  final String searchQuery;

  const QuranState({
    this.isLoading = false,
    this.surahs = const [],
    this.filteredSurahs = const [],
    this.error,
    this.searchQuery = '',
  });

  QuranState copyWith({
    bool? isLoading,
    List<Surah>? surahs,
    List<Surah>? filteredSurahs,
    String? error,
    String? searchQuery,
  }) {
    return QuranState(
      isLoading: isLoading ?? this.isLoading,
      surahs: surahs ?? this.surahs,
      filteredSurahs: filteredSurahs ?? this.filteredSurahs,
      error: error ?? this.error,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  List<Surah> get displaySurahs {
    return searchQuery.isEmpty ? surahs : filteredSurahs;
  }
}

// Notifier
class QuranNotifier extends StateNotifier<QuranState> {
  final GetSurahs getSurahs;

  QuranNotifier({required this.getSurahs}) : super(const QuranState()) {
    loadSurahs();
  }

  Future<void> loadSurahs() async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await getSurahs();

    result.fold(
          (error) => state = state.copyWith(
        isLoading: false,
        error: error,
      ),
          (surahs) => state = state.copyWith(
        isLoading: false,
        surahs: surahs,
        filteredSurahs: surahs,
      ),
    );
  }

  void search(String query) {
    if (query.isEmpty) {
      state = state.copyWith(searchQuery: '', filteredSurahs: state.surahs);
      return;
    }

    final filtered = state.surahs.where((surah) =>
    surah.name.toLowerCase().contains(query.toLowerCase()) ||
        surah.arabicName.contains(query) ||
        surah.englishName.toLowerCase().contains(query.toLowerCase())
    ).toList();

    state = state.copyWith(
      searchQuery: query,
      filteredSurahs: filtered,
    );
  }
}