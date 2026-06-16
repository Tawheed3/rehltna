import 'package:dartz/dartz.dart';
import '../entities/surah.dart';
import '../repositories/quran_repository.dart';

class GetSurahs {
  final QuranRepository repository;

  GetSurahs(this.repository);

  Future<Either<String, List<Surah>>> call() async {
    try {
      final surahs = await repository.getAllSurahs();
      return Right(surahs);
    } catch (e) {
      return Left(e.toString());
    }
  }
}

class GetSurahById {
  final QuranRepository repository;

  GetSurahById(this.repository);

  Future<Either<String, Surah?>> call(int id) async {
    try {
      final surah = await repository.getSurahById(id);
      return Right(surah);
    } catch (e) {
      return Left(e.toString());
    }
  }
}

class GetAyahs {
  final QuranRepository repository;

  GetAyahs(this.repository);

  Future<Either<String, List<Ayah>>> call(int surahId) async {
    try {
      final ayahs = await repository.getAyahsBySurahId(surahId);
      return Right(ayahs);
    } catch (e) {
      return Left(e.toString());
    }
  }
}