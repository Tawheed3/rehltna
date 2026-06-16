import 'package:flutter/material.dart';
import 'package:qcf_quran_plus/qcf_quran_plus.dart';
import 'package:just_audio/just_audio.dart';

class QuranMushafScreen extends StatefulWidget {
  final int surahId;
  const QuranMushafScreen({super.key, required this.surahId});

  @override
  State<QuranMushafScreen> createState() => _QuranMushafScreenState();
}

class _QuranMushafScreenState extends State<QuranMushafScreen> {
  AudioPlayer? _audioPlayer;
  int _currentPage = 1;
  bool _isPlaying = false;
  double _fontSize = 22; // ✅ التحكم في حجم الخط

  @override
  void initState() {
    super.initState();
    _initAudio();
  }

  Future<void> _initAudio() async {
    try {
      _audioPlayer = AudioPlayer();
    } catch (e) {}
  }

  Future<void> _playSurah() async {
    if (_audioPlayer == null) return;
    try {
      final surahNumber = widget.surahId.toString().padLeft(3, '0');
      final url = 'https://ia800104.us.archive.org/33/items/Alafasy_mp3_128kbps/$surahNumber.mp3';

      if (_isPlaying) {
        await _audioPlayer!.pause();
        setState(() => _isPlaying = false);
      } else {
        await _audioPlayer!.setUrl(url);
        await _audioPlayer!.play();
        setState(() => _isPlaying = true);
      }
    } catch (e) {}
  }

  @override
  void dispose() {
    _audioPlayer?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF6E3),
      body: Stack(
        children: [
          // ✅ استخدام qcf_quran_plus مع التحكم في حجم الخط
          PageviewQuran(
            initialPageNumber: 1,
            textScaleFactor: _fontSize / 14, // ✅ التحكم في حجم الخط
            onPageChanged: (page) {
              setState(() => _currentPage = page);
            },
            onLongPress: (surah, verse) {
              _showAyahOptions(surah, verse);
            },
          ),
          
          // ✅ أزرار التحكم في حجم الخط
          Positioned(
            top: 16,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.zoom_out, color: Colors.green),
                      onPressed: () {
                        setState(() {
                          _fontSize = (_fontSize - 2).clamp(14, 32);
                        });
                      },
                    ),
                    Container(
                      width: 1,
                      height: 30,
                      color: Colors.grey.shade300,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        '${_fontSize.toInt()}',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 30,
                      color: Colors.grey.shade300,
                    ),
                    IconButton(
                      icon: const Icon(Icons.zoom_in, color: Colors.green),
                      onPressed: () {
                        setState(() {
                          _fontSize = (_fontSize + 2).clamp(14, 32);
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // ✅ زر الصوت
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.green, size: 28),
                onPressed: _playSurah,
              ),
            ),
          ),
          
          // ✅ رقم الصفحة
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  '۩ الصفحة $_currentPage ۩',
                  style: const TextStyle(fontSize: 14, color: Colors.green),
                ),
              ),
            ),
          ),
          
          // ✅ زر الرجوع
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.green, size: 22),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAyahOptions(int surah, int verse) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.translate, color: Colors.blue),
                title: const Text('عرض الترجمة'),
                onTap: () {
                  Navigator.pop(context);
                  _showTranslationDialog(surah, verse);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showTranslationDialog(int surah, int verse) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('الترجمة', textAlign: TextAlign.center),
        content: Text('سورة $surah الآية $verse'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('إغلاق')),
        ],
      ),
    );
  }
}