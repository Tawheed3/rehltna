import '../entities/surah.dart';

abstract class QuranRepository {
  Future<List<Surah>> getAllSurahs();
  Future<Surah?> getSurahById(int id);
  Future<List<Ayah>> getAyahsBySurahId(int surahId);
  Future<List<Surah>> searchSurahs(String query);
  Future<List<Ayah>> searchAyahs(String query);
}