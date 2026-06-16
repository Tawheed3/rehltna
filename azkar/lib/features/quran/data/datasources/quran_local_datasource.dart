import 'dart:convert';
import 'package:flutter/services.dart';

class QuranLocalDatasource {
  Future<List<Map<String, dynamic>>> loadSurahs() async {
    try {
      final String response = await rootBundle.loadString('assets/quran/surahs.json');
      final List<dynamic> data = jsonDecode(response);
      return data.map((e) => Map<String, dynamic>.from(e)).toList();
    } catch (e) {
      print('Error loading surahs: $e');
      return _getFallbackSurahs();
    }
  }

  List<Map<String, dynamic>> _getFallbackSurahs() {
    return [
      {"id": 1, "arabicName": "الفاتحة", "englishName": "Al-Fatihah", "versesCount": 7, "revelationType": "مكية", "pageNumber": 1},
      {"id": 2, "arabicName": "البقرة", "englishName": "Al-Baqarah", "versesCount": 286, "revelationType": "مدنية", "pageNumber": 2},
    ];
  }

  Future<List<Map<String, dynamic>>> loadAyahs(int surahId) async {
    try {
      final String response = await rootBundle.loadString('assets/quran/ayahs/$surahId.json');
      final List<dynamic> data = jsonDecode(response);
      return data.map((e) => Map<String, dynamic>.from(e)).toList();
    } catch (e) {
      print('Error loading ayahs for surah $surahId: $e');
      return _getFallbackAyahs(surahId);
    }
  }

  List<Map<String, dynamic>> _getFallbackAyahs(int surahId) {
    final List<Map<String, dynamic>> ayahs = [];
    int maxVerses = surahId == 1 ? 7 : 10;
    for (int i = 1; i <= maxVerses; i++) {
      ayahs.add({
        'surahId': surahId,
        'ayahNumber': i,
        'text': i == 1 ? 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ' : 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
        'translation': i == 1 ? 'بسم الله الرحمن الرحيم' : 'الحمد لله رب العالمين',
        'juz': 1,
        'page': i,
      });
    }
    return ayahs;
  }

  // روابط صوت من مصادر متعددة
  String getAyahAudioUrl(int surahId, int ayahNumber, {String reciter = 'ar.alafasy'}) {
    final surahNumber = surahId.toString().padLeft(3, '0');

    // روابط بديلة
    final Map<String, String> audioUrls = {
      'ar.alafasy': 'https://ia800104.us.archive.org/33/items/Alafasy_mp3_128kbps/$surahNumber.mp3',
      'ar.saood': 'https://archive.org/download/Shuraim_mp3_128kbps/$surahNumber.mp3',
      'ar.abdulsamad': 'https://archive.org/download/Abdul_Baset_mp3_128kbps/$surahNumber.mp3',
      'ar.husary': 'https://archive.org/download/Husary_mp3_128kbps/$surahNumber.mp3',
      'ar.minshawi': 'https://archive.org/download/Minshawi_mp3_128kbps/$surahNumber.mp3',
    };

    return audioUrls[reciter] ?? audioUrls['ar.alafasy']!;
  }

  List<Map<String, String>> getAvailableReciters() {
    return [
      {'id': 'ar.alafasy', 'name': 'مشاري راشد العفاسي'},
      {'id': 'ar.saood', 'name': 'سعود الشريم'},
      {'id': 'ar.abdulsamad', 'name': 'عبد الباسط عبد الصمد'},
      {'id': 'ar.husary', 'name': 'محمود خليل الحصري'},
      {'id': 'ar.minshawi', 'name': 'محمد صديق المنشاوي'},
    ];
  }
}