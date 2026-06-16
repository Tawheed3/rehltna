import '../../domain/entities/surah.dart';
import '../../domain/repositories/quran_repository.dart';
import '../datasources/quran_local_datasource.dart';

class QuranRepositoryImpl implements QuranRepository {
  final QuranLocalDatasource datasource;

  QuranRepositoryImpl({required this.datasource});

  @override
  Future<List<Surah>> getAllSurahs() async {
    final surahsData = await datasource.loadSurahs();
    return surahsData.map((data) => Surah(
      id: data['id'] as int,
      name: data['englishName'] as String,
      arabicName: data['arabicName'] as String,
      englishName: data['englishName'] as String,
      versesCount: data['versesCount'] as int,
      revelationType: data['revelationType'] as String,
      pageNumber: data['pageNumber'] as int,
    )).toList();
  }

  @override
  Future<Surah?> getSurahById(int id) async {
    final surahs = await getAllSurahs();
    try {
      return surahs.firstWhere((s) => s.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<Ayah>> getAyahsBySurahId(int surahId) async {
    final ayahsData = await datasource.loadAyahs(surahId);
    return ayahsData.map((data) => Ayah(
      surahId: data['surahId'] as int,
      ayahNumber: data['ayahNumber'] as int,
      text: data['text'] as String,
      translation: data['translation'] as String,
      juz: data['juz'] as int,
      page: data['page'] as int,
    )).toList();
  }

  @override
  Future<List<Surah>> searchSurahs(String query) async {
    final allSurahs = await getAllSurahs();
    return allSurahs.where((surah) =>
    surah.name.toLowerCase().contains(query.toLowerCase()) ||
        surah.arabicName.contains(query) ||
        surah.englishName.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  @override
  Future<List<Ayah>> searchAyahs(String query) async {
    // البحث في الآيات - يمكن تنفيذه لاحقاً
    return [];
  }

  // دالة للحصول على رابط الصوت
  String getAudioUrl(int surahId, int ayahNumber, {String reciter = 'ar.alafasy'}) {
    return datasource.getAyahAudioUrl(surahId, ayahNumber, reciter: reciter);
  }
}