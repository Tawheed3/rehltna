import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import '../providers/quran_provider.dart';
import '../../domain/entities/surah.dart';
import '../../domain/usecases/get_surahs.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/datasources/quran_local_datasource.dart';

class QuranDetailScreen extends ConsumerStatefulWidget {
  final int surahId;
  const QuranDetailScreen({super.key, required this.surahId});

  @override
  ConsumerState<QuranDetailScreen> createState() => _QuranDetailScreenState();
}

class _QuranDetailScreenState extends ConsumerState<QuranDetailScreen> {
  late Future<Surah?> _surahFuture;
  late Future<List<Ayah>> _ayahsFuture;

  // Audio
  AudioPlayer? _audioPlayer;
  int? _currentPlayingAyah;
  bool _isLoadingAudio = false;
  String _selectedReciter = 'ar.alafasy';

  // Display Settings
  double _fontSize = 22;
  String _fontFamily = 'Amiri';
  bool _showTranslation = false; // الترجمة تظهر فقط عند الطلب

  final QuranLocalDatasource _datasource = QuranLocalDatasource();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initAudio();
    _loadData();
  }

  Future<void> _initAudio() async {
    try {
      _audioPlayer = AudioPlayer();
      print('✅ Audio player initialized');
    } catch (e) {
      print('❌ Error initializing audio: $e');
    }
  }

  void _loadData() {
    final getSurahById = GetSurahById(ref.read(quranRepositoryProvider));
    final getAyahs = GetAyahs(ref.read(quranRepositoryProvider));

    _surahFuture = getSurahById(widget.surahId).then((result) {
      return result.fold((error) => null, (surah) => surah);
    });

    _ayahsFuture = getAyahs(widget.surahId).then((result) {
      return result.fold((error) => [], (ayahs) => ayahs);
    });
  }

  Future<void> _playAyah(Ayah ayah) async {
    if (_audioPlayer == null) {
      _showSnackBar('مشغل الصوت قيد التهيئة...', Colors.orange);
      return;
    }

    try {
      if (_currentPlayingAyah == ayah.ayahNumber && _audioPlayer!.playing) {
        await _audioPlayer!.pause();
        setState(() => _currentPlayingAyah = null);
        return;
      }

      setState(() => _isLoadingAudio = true);

      // رابط الصوت من المصدر
      final url = _getAudioUrl(ayah);
      print('🎵 Playing: $url');

      await _audioPlayer!.setUrl(url);
      await _audioPlayer!.play();

      setState(() {
        _currentPlayingAyah = ayah.ayahNumber;
        _isLoadingAudio = false;
      });

      _audioPlayer!.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          if (mounted) setState(() => _currentPlayingAyah = null);
        }
      });
    } catch (e) {
      print('❌ Error: $e');
      setState(() => _isLoadingAudio = false);
      _showSnackBar('حدث خطأ في تشغيل الصوت', Colors.red);
    }
  }

  String _getAudioUrl(Ayah ayah) {
    final surahNumber = widget.surahId.toString().padLeft(3, '0');
    final ayahNumber = ayah.ayahNumber.toString().padLeft(3, '0');

    // روابط متعددة للمحاولة
    final urls = {
      'ar.alafasy': 'https://ia800104.us.archive.org/33/items/Alafasy_mp3_128kbps/$surahNumber.mp3',
      'ar.saood': 'https://archive.org/download/Shuraim_mp3_128kbps/$surahNumber.mp3',
    };
    return urls[_selectedReciter] ?? urls['ar.alafasy']!;
  }

  void _showAyahOptions(Ayah ayah) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 16),

              // تشغيل الآية
              ListTile(
                leading: const Icon(Icons.play_circle_outline, color: Colors.green),
                title: const Text('تشغيل الآية'),
                onTap: () {
                  Navigator.pop(context);
                  _playAyah(ayah);
                },
              ),

              // إظهار الترجمة
              ListTile(
                leading: const Icon(Icons.translate, color: Colors.blue),
                title: const Text('عرض الترجمة'),
                onTap: () {
                  Navigator.pop(context);
                  _showTranslationDialog(ayah);
                },
              ),

              // مشاركة الآية
              ListTile(
                leading: const Icon(Icons.share, color: Colors.orange),
                title: const Text('مشاركة الآية'),
                onTap: () {
                  Navigator.pop(context);
                  _shareAyah(ayah);
                },
              ),

              // نسخ الآية
              ListTile(
                leading: const Icon(Icons.copy, color: Colors.purple),
                title: const Text('نسخ الآية'),
                onTap: () {
                  Navigator.pop(context);
                  _copyAyah(ayah);
                },
              ),

              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  void _showTranslationDialog(Ayah ayah) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('الترجمة', textAlign: TextAlign.center),
        content: Container(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                ayah.text,
                style: const TextStyle(fontSize: 20, fontFamily: 'Amiri'),
                textAlign: TextAlign.right,
              ),
              const Divider(),
              Text(
                ayah.translation,
                style: const TextStyle(fontSize: 16, height: 1.5),
                textAlign: TextAlign.right,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('إغلاق')),
        ],
      ),
    );
  }

  void _shareAyah(Ayah ayah) {
    // سيتم إضافة مشاركة الآية
    _showSnackBar('سيتم إضافة مشاركة الآية قريباً', Colors.green);
  }

  void _copyAyah(Ayah ayah) {
    // سيتم إضافة نسخ النص
    _showSnackBar('تم نسخ النص', Colors.green);
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color, duration: const Duration(seconds: 2)),
    );
  }

  void _showSettingsDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateBottom) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('إعدادات القراءة', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),

                  // حجم الخط
                  ListTile(
                    title: const Text('حجم الخط'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: () {
                            setState(() => _fontSize = (_fontSize - 2).clamp(16, 40));
                            setStateBottom(() {});
                          },
                        ),
                        Text('${_fontSize.toInt()}', style: const TextStyle(fontSize: 16)),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: () {
                            setState(() => _fontSize = (_fontSize + 2).clamp(16, 40));
                            setStateBottom(() {});
                          },
                        ),
                      ],
                    ),
                  ),

                  // نوع الخط
                  ListTile(
                    title: const Text('نوع الخط'),
                    trailing: DropdownButton<String>(
                      value: _fontFamily,
                      items: const [
                        DropdownMenuItem(value: 'Amiri', child: Text('أميري')),
                        DropdownMenuItem(value: 'Scheherazade', child: Text('شهرزاد')),
                        DropdownMenuItem(value: 'Tajawal', child: Text('تجوال')),
                      ],
                      onChanged: (value) {
                        setState(() => _fontFamily = value!);
                        setStateBottom(() {});
                      },
                    ),
                  ),

                  // اختيار القارئ
                  const Divider(),
                  const Text('القارئ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ..._datasource.getAvailableReciters().map((reciter) => RadioListTile<String>(
                    title: Text(reciter['name']!),
                    value: reciter['id']!,
                    groupValue: _selectedReciter,
                    activeColor: Colors.green,
                    onChanged: (value) {
                      setState(() => _selectedReciter = value!);
                      setStateBottom(() {});
                    },
                  )),

                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12)),
                    child: const Text('حفظ', style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _audioPlayer?.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // AppBar مميز
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: Colors.green,
            flexibleSpace: FlexibleSpaceBar(
              title: FutureBuilder<Surah?>(
                future: _surahFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    return Text(snapshot.data!.arabicName);
                  }
                  return const Text('القرآن الكريم');
                },
              ),
              centerTitle: true,
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.green.shade700, Colors.green.shade400],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.menu_book, size: 60, color: Colors.white),
                      const SizedBox(height: 8),
                      FutureBuilder<Surah?>(
                        future: _surahFuture,
                        builder: (context, snapshot) {
                          if (snapshot.hasData && snapshot.data != null) {
                            final surah = snapshot.data!;
                            return Column(
                              children: [
                                Text(
                                  surah.arabicName,
                                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${surah.versesCount} آيات - ${surah.revelationType}',
                                  style: const TextStyle(fontSize: 14, color: Colors.white70),
                                ),
                              ],
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: _showSettingsDialog,
                tooltip: 'الإعدادات',
              ),
            ],
          ),

          // شريط التحكم السريع
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.grey.shade50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.zoom_out, color: Colors.green),
                    onPressed: () => setState(() => _fontSize = (_fontSize - 2).clamp(16, 40)),
                  ),
                  const SizedBox(width: 8),
                  Text('${_fontSize.toInt()}', style: const TextStyle(color: Colors.green)),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.zoom_in, color: Colors.green),
                    onPressed: () => setState(() => _fontSize = (_fontSize + 2).clamp(16, 40)),
                  ),
                  const SizedBox(width: 24),
                  const Text('اضغط مطولاً على الآية للخيارات', style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
          ),

          // عرض الآيات متتالية (مثل المصحف)
          FutureBuilder<List<Ayah>>(
            future: _ayahsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.green))),
                );
              }

              if (snapshot.hasError) {
                return SliverFillRemaining(
                  child: Center(child: Text('خطأ: ${snapshot.error}')),
                );
              }

              final ayahs = snapshot.data ?? [];

              if (ayahs.isEmpty) {
                return const SliverFillRemaining(child: Center(child: Text('لا توجد آيات')));
              }

              // عرض الآيات متتالية بدون فواصل
              return SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) => _buildAyahVerse(ayahs[index]),
                    childCount: ayahs.length,
                  ),
                ),
              );
            },
          ),

          // مساحة في النهاية
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }

  // عرض الآية بشكل متتالي (مثل المصحف)
  Widget _buildAyahVerse(Ayah ayah) {
    final isPlaying = _currentPlayingAyah == ayah.ayahNumber;
    final isLoading = _isLoadingAudio && isPlaying;

    return GestureDetector(
      onLongPress: () => _showAyahOptions(ayah),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade200, width: 1),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // رقم الآية وزر التشغيل في نفس السطر
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // زر التشغيل
                isLoading
                    ? const SizedBox(width: 32, height: 32, child: CircularProgressIndicator(strokeWidth: 2))
                    : IconButton(
                  icon: Icon(
                    isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                    color: Colors.green,
                    size: 28,
                  ),
                  onPressed: () => _playAyah(ayah),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),

                // رمز رقم الآية
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${ayah.ayahNumber}',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        width: 4,
                        height: 4,
                        decoration: const BoxDecoration(color: AppTheme.primaryColor, shape: BoxShape.circle),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // النص القرآني (بحجم كبير ومتتالي)
            Text(
              ayah.text,
              style: TextStyle(
                fontSize: _fontSize,
                height: 1.8,
                fontFamily: _fontFamily,
                color: Colors.black87,
              ),
              textAlign: TextAlign.right,
            ),
          ],
        ),
      ),
    );
  }
}