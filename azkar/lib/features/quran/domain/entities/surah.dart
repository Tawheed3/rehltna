import 'package:equatable/equatable.dart';

class Surah extends Equatable {
  final int id;
  final String name;
  final String arabicName;
  final String englishName;
  final int versesCount;
  final String revelationType; // Meccan or Medinan
  final int pageNumber;

  const Surah({
    required this.id,
    required this.name,
    required this.arabicName,
    required this.englishName,
    required this.versesCount,
    required this.revelationType,
    required this.pageNumber,
  });

  @override
  List<Object?> get props => [id, name, arabicName, versesCount];
}

class Ayah extends Equatable {
  final int surahId;
  final int ayahNumber;
  final String text;
  final String translation; // الترجمة
  final int juz;
  final int page;

  const Ayah({
    required this.surahId,
    required this.ayahNumber,
    required this.text,
    required this.translation,
    required this.juz,
    required this.page,
  });

  @override
  List<Object?> get props => [surahId, ayahNumber, text];
}