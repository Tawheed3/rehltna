import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../core/constants/app_config.dart';
import '../profile/currency_calculator_screen.dart';
import '../qibla/qibla_screen.dart';

class MosqueScreen extends StatefulWidget {
  const MosqueScreen({super.key});

  @override
  State<MosqueScreen> createState() => _MosqueScreenState();
}

class _MosqueScreenState extends State<MosqueScreen> {

  // ── Weather ──
  double? _temperature;
  int? _weatherCode;
  bool _weatherLoaded = false;
  List<Map<String, dynamic>> _weeklyForecast = [];

  // ── Currency ──
  Map<String, double> _rates = {};
  bool _currencyLoaded = false;
  bool _currencyExpanded = false;
  bool _prayerExpanded = false;

  // ── Travel Tools ──
  List<Map<String, dynamic>> _travelTools = [];
  bool _travelToolsLoaded = false;
  bool _travelToolsExpanded = false;

  // Quick-view list shown in the rates card (collapsed by default)
  static const _currencies = {
    'USD': ('دولار أمريكي',    '\$'),
    'EUR': ('يورو',             '€'),
    'GBP': ('جنيه إسترليني',   '£'),
    'AED': ('درهم إماراتي',    'د.إ'),
    'KWD': ('دينار كويتي',     'د.ك'),
    'BHD': ('دينار بحريني',    'د.ب'),
    'QAR': ('ريال قطري',       'ر.ق'),
    'OMR': ('ريال عماني',      'ر.ع'),
    'TRY': ('ليرة تركية',      '₺'),
    'EGP': ('جنيه مصري',       'ج.م'),
    'CHF': ('فرانك سويسري',    'Fr'),
    'CNY': ('يوان صيني',       '¥'),
    'INR': ('روبية هندية',     '₹'),
    'CAD': ('دولار كندي',      'C\$'),
  };

  // ── Location + Prayer Times ──
  Position? _userPosition;
  Map<String, String> _prayerTimes = {};
  bool _prayerLoading = false;
  bool _prayerLoaded = false;
  String _cityName = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initLocation());
  }

  Future<void> _initLocation() async {
    try {
      var status = await Permission.location.status;
      if (!status.isGranted) {
        status = await Permission.location.request();
      }
      if (!status.isGranted) {
        // Still load currency even without location
        await _loadCurrencyRates();
        return;
      }
      final pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
      if (mounted) setState(() => _userPosition = pos);
      await Future.wait([
        _loadPrayerTimes(pos),
        _loadWeather(pos),
        _loadCurrencyRates(),
        _loadTravelTools(),
      ]);
    } catch (_) {
      await Future.wait([_loadCurrencyRates(), _loadTravelTools()]);
    }
  }

  Future<void> _loadTravelTools() async {
    try {
      final res = await Dio().get(
        '${AppConfig.baseUrl}/travel-tools',
        options: Options(headers: {
          'X-API-Key': AppConfig.apiKey,
          'X-Tenant-ID': AppConfig.tenantId.toString(),
        }),
      );
      final data = res.data['data'] as List<dynamic>? ?? [];
      if (mounted) {
        setState(() {
          _travelTools = data.map((e) => Map<String, dynamic>.from(e as Map)).toList();
          _travelToolsLoaded = true;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _travelToolsLoaded = true);
    }
  }

  Future<void> _loadWeather(Position pos) async {
    try {
      final res = await Dio().get(
        'https://api.open-meteo.com/v1/forecast',
        queryParameters: {
          'latitude': pos.latitude,
          'longitude': pos.longitude,
          'current_weather': true,
          'temperature_unit': 'celsius',
          'daily': 'temperature_2m_max,temperature_2m_min,weathercode,precipitation_probability_max,windspeed_10m_max',
          'timezone': 'auto',
          'forecast_days': 7,
        },
      );
      final cw = res.data['current_weather'] as Map<String, dynamic>;
      List<Map<String, dynamic>> forecast = [];
      final daily = res.data['daily'] as Map<String, dynamic>?;
      if (daily != null) {
        final dates = (daily['time'] as List).cast<String>();
        final maxT = (daily['temperature_2m_max'] as List).cast<num>();
        final minT = (daily['temperature_2m_min'] as List).cast<num>();
        final codes = (daily['weathercode'] as List).cast<num>();
        final precip = daily['precipitation_probability_max'] as List;
        final wind = (daily['windspeed_10m_max'] as List).cast<num>();
        forecast = List.generate(dates.length, (i) => {
          'date': dates[i],
          'max': maxT[i].toDouble(),
          'min': minT[i].toDouble(),
          'code': codes[i].toInt(),
          'rain': precip[i] != null ? (precip[i] as num).toInt() : 0,
          'wind': wind[i].toDouble(),
        });
      }
      if (mounted) {
        setState(() {
          _temperature = (cw['temperature'] as num).toDouble();
          _weatherCode = cw['weathercode'] as int;
          _weeklyForecast = forecast;
          _weatherLoaded = true;
        });
      }
    } catch (_) {}
  }

  Future<void> _loadCurrencyRates() async {
    try {
      final res = await Dio().get('https://open.er-api.com/v6/latest/SAR');
      final raw = res.data['rates'] as Map<String, dynamic>;
      if (mounted) {
        setState(() {
          // Store rates for every currency the calculator knows about
          _rates = {
            for (final k in CurrencyCalculatorScreen.allCurrencies.keys)
            if (raw[k] != null) k: (raw[k] as num).toDouble()
          };
          _currencyLoaded = true;
        });
      }
    } catch (_) {}
  }

  Future<void> _loadPrayerTimes(Position pos) async {
    if (_prayerLoaded || _prayerLoading) return;
    if (mounted) setState(() => _prayerLoading = true);
    try {
      try {
        final geo = await Dio().get(
          'https://nominatim.openstreetmap.org/reverse',
          queryParameters: {'format': 'json', 'lat': pos.latitude, 'lon': pos.longitude, 'accept-language': 'ar'},
          options: Options(headers: {'User-Agent': 'RehltnaApp/1.0'}),
        );
        final addr = geo.data['address'] as Map<String, dynamic>? ?? {};
        final city = addr['city'] ?? addr['town'] ?? addr['county'] ?? addr['state_district'] ?? addr['state'] ?? '';
        if (mounted) setState(() => _cityName = city.toString());
      } catch (_) {}

      final response = await Dio().get(
        'https://api.aladhan.com/v1/timings',
        queryParameters: {'latitude': pos.latitude, 'longitude': pos.longitude, 'method': 4},
      );
      final timings = response.data['data']['timings'] as Map<String, dynamic>;
      if (mounted) {
        setState(() {
          _prayerTimes = {
            'الفجر':   _stripSeconds(timings['Fajr'] ?? ''),
            'الشروق':  _stripSeconds(timings['Sunrise'] ?? ''),
            'الظهر':   _stripSeconds(timings['Dhuhr'] ?? ''),
            'العصر':   _stripSeconds(timings['Asr'] ?? ''),
            'المغرب':  _stripSeconds(timings['Maghrib'] ?? ''),
            'العشاء':  _stripSeconds(timings['Isha'] ?? ''),
          };
          _prayerLoaded = true;
          _prayerLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _prayerLoading = false);
    }
  }

  String _stripSeconds(String t) => t.length >= 5 ? t.substring(0, 5) : t;

  String? _nextPrayer() {
    if (_prayerTimes.isEmpty) return null;
    final now = TimeOfDay.now();
    final nowMins = now.hour * 60 + now.minute;
    for (final entry in _prayerTimes.entries) {
      if (entry.key == 'الشروق') continue;
      final parts = entry.value.split(':');
      if (parts.length < 2) continue;
      final mins = int.tryParse(parts[0])! * 60 + int.tryParse(parts[1])!;
      if (mins > nowMins) return entry.key;
    }
    return _prayerTimes.keys.first;
  }

  String _remainingTime(String prayerTime) {
    final parts = prayerTime.split(':');
    if (parts.length < 2) return '';
    final prayerMins = int.parse(parts[0]) * 60 + int.parse(parts[1]);
    final now = TimeOfDay.now();
    final nowMins = now.hour * 60 + now.minute;
    int diff = prayerMins - nowMins;
    if (diff <= 0) diff += 24 * 60;
    final h = diff ~/ 60;
    final m = diff % 60;
    if (h > 0) return 'يتبقى ${h}س ${m}د';
    return 'يتبقى ${m} دقيقة';
  }

  String _weatherIcon(int code) {
    if (code == 0) return '☀️';
    if (code <= 2) return '🌤️';
    if (code == 3) return '☁️';
    if (code <= 48) return '🌫️';
    if (code <= 67) return '🌧️';
    if (code <= 77) return '❄️';
    if (code <= 82) return '🌦️';
    return '⛈️';
  }

  String _weatherDesc(int code) {
    if (code == 0) return 'صافٍ';
    if (code <= 2) return 'غائم جزئياً';
    if (code == 3) return 'غائم';
    if (code <= 48) return 'ضباب';
    if (code <= 55) return 'رذاذ';
    if (code <= 67) return 'مطر';
    if (code <= 77) return 'ثلج';
    if (code <= 82) return 'زخات مطر';
    return 'عاصفة رعدية';
  }

  String _arabicDayName(String dateStr) {
    try {
      final dt = DateTime.parse(dateStr);
      final today = DateTime.now();
      if (dt.year == today.year && dt.month == today.month && dt.day == today.day) return 'اليوم';
      final tomorrow = today.add(const Duration(days: 1));
      if (dt.year == tomorrow.year && dt.month == tomorrow.month && dt.day == tomorrow.day) return 'غداً';
      const days = ['الاثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت', 'الأحد'];
      return days[dt.weekday - 1];
    } catch (_) {
      return '';
    }
  }

  // ==================== Build ====================

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0f1723) : const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black87),
        title: Row(mainAxisSize: MainAxisSize.min, children: [
          const Text('🕋', style: TextStyle(fontSize: 22)),
          const SizedBox(width: 8),
          Text(
            'من أجلك',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ]),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(children: [
            _buildWeatherCard(isDark),
            const SizedBox(height: 16),
            _buildQiblaCard(isDark),
            const SizedBox(height: 16),
            _buildPrayerTimesCard(isDark),
            const SizedBox(height: 16),
            _buildCurrencyCard(isDark),
            const SizedBox(height: 16),
            _buildTravelToolsCard(isDark),
            const SizedBox(height: 24),
          ]),
        ),
      ),
    );
  }

  // ── Weather Card ──

  Widget _buildWeatherCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF0d3b6e), const Color(0xFF1a6b8a)]
              : [const Color(0xFF1e6fa8), const Color(0xFF38b2d8)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: const Color(0xFF1e6fa8).withOpacity(0.3), blurRadius: 16, offset: const Offset(0, 6))],
      ),
      child: !_weatherLoaded
          ? const Center(child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)),
            ))
          : Column(children: [
              Row(children: [
                Text(_weatherIcon(_weatherCode ?? 0), style: const TextStyle(fontSize: 52)),
                const SizedBox(width: 16),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    '${_temperature?.toStringAsFixed(0) ?? '--'}°C',
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  Text(_weatherDesc(_weatherCode ?? 0), style: const TextStyle(fontSize: 14, color: Colors.white70)),
                ])),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  const Text('الطقس', style: TextStyle(fontSize: 12, color: Colors.white70)),
                  const SizedBox(height: 4),
                  Text(
                    _cityName.isNotEmpty ? _cityName : 'موقعك الحالي',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ]),
              ]),
              if (_weeklyForecast.isNotEmpty) ...[
                const SizedBox(height: 14),
                Container(height: 1, color: Colors.white.withOpacity(0.2)),
                const SizedBox(height: 10),
                const Align(
                  alignment: Alignment.centerRight,
                  child: Text('توقعات الأسبوع', style: TextStyle(fontSize: 12, color: Colors.white70)),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 112,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _weeklyForecast.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (_, i) => _buildDayCard(_weeklyForecast[i]),
                  ),
                ),
              ],
            ]),
    );
  }

  Widget _buildDayCard(Map<String, dynamic> day) {
    final dayName = _arabicDayName(day['date'] as String);
    final max = (day['max'] as double).toStringAsFixed(0);
    final min = (day['min'] as double).toStringAsFixed(0);
    final icon = _weatherIcon(day['code'] as int);
    final rain = day['rain'] as int;
    final wind = day['wind'] as double;
    return Container(
      width: 72,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.13),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(dayName, style: const TextStyle(fontSize: 10, color: Colors.white70), textAlign: TextAlign.center),
        const SizedBox(height: 4),
        Text(icon, style: const TextStyle(fontSize: 22)),
        const SizedBox(height: 4),
        Text('$max°', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
        Text('$min°', style: const TextStyle(fontSize: 11, color: Colors.white60)),
        const SizedBox(height: 2),
        if (rain > 0)
          Text('💧$rain%', style: const TextStyle(fontSize: 9, color: Colors.lightBlueAccent))
        else
          Text('💨${wind.toStringAsFixed(0)}', style: const TextStyle(fontSize: 9, color: Colors.white54)),
      ]),
    );
  }

  // ── Currency Card ──

  Widget _buildCurrencyCard(bool isDark) {
    final bg = isDark ? const Color(0xFF1c2333) : Colors.white;
    final borderRadius = BorderRadius.circular(20);
    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: borderRadius,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 14, offset: const Offset(0, 4))],
      ),
      child: Column(children: [
        // Tappable header
        GestureDetector(
          onTap: () => setState(() => _currencyExpanded = !_currencyExpanded),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2d5016), Color(0xFF4a8a1a)],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
              borderRadius: _currencyExpanded
                  ? const BorderRadius.vertical(top: Radius.circular(20))
                  : BorderRadius.circular(20),
            ),
            child: Row(children: [
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
                child: const Center(child: Text('💱', style: TextStyle(fontSize: 22))),
              ),
              const SizedBox(width: 14),
              const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('أسعار الصرف', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                Text('مقابل الريال السعودي', style: TextStyle(fontSize: 11, color: Colors.white70)),
              ])),
              AnimatedRotation(
                turns: _currencyExpanded ? 0.5 : 0,
                duration: const Duration(milliseconds: 250),
                child: const Icon(Icons.keyboard_arrow_down, color: Colors.white70, size: 24),
              ),
            ]),
          ),
        ),
        // Collapsible body
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 250),
          crossFadeState: _currencyExpanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          firstChild: Column(children: [
            if (!_currencyLoaded)
              const Padding(padding: EdgeInsets.all(24), child: Center(child: CircularProgressIndicator(strokeWidth: 2)))
            else
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(children: [
                  for (int i = 0; i < _currencies.keys.length; i++) ...[
                    Builder(builder: (_) {
                      final code = _currencies.keys.elementAt(i);
                      final info = _currencies[code]!;
                      final rate = _rates[code];
                      if (rate == null) return const SizedBox.shrink();
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 3),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white.withOpacity(0.04) : const Color(0xFFF8FFF8),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(children: [
                          Container(
                            width: 36, height: 36,
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(child: Text(info.$2, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green.shade700))),
                          ),
                          const SizedBox(width: 10),
                          Expanded(child: Text(info.$1, style: TextStyle(fontSize: 13, color: isDark ? Colors.white70 : Colors.black54))),
                          Text(
                            '${(1 / rate).toStringAsFixed(2)}',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87),
                          ),
                          const SizedBox(width: 4),
                          Text('ر.س', style: TextStyle(fontSize: 11, color: isDark ? Colors.white38 : Colors.black38)),
                        ]),
                      );
                    }),
                  ],
                ]),
              ),
            if (_currencyLoaded)
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => CurrencyCalculatorScreen(rates: _rates)),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF2d5016), Color(0xFF4a8a1a)],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                    ),
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
                  ),
                  child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text('🧮', style: TextStyle(fontSize: 16)),
                    SizedBox(width: 8),
                    Text('حاسبة العملات', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                    SizedBox(width: 6),
                    Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white70, size: 13),
                  ]),
                ),
              ),
          ]),
          secondChild: const SizedBox.shrink(),
        ),
      ]),
    );
  }

  // ── Prayer Times Card ──

  Widget _buildPrayerTimesCard(bool isDark) {
    final next = _nextPrayer();
    final prayers = _prayerTimes.entries.toList();
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1c2333) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 14, offset: const Offset(0, 4))],
      ),
      child: Column(children: [
        // Tappable header
        GestureDetector(
          onTap: () => setState(() => _prayerExpanded = !_prayerExpanded),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1a3a5c), Color(0xFF2c5f8a)],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
              borderRadius: _prayerExpanded
                  ? const BorderRadius.vertical(top: Radius.circular(20))
                  : BorderRadius.circular(20),
            ),
            child: Row(children: [
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
                child: const Center(child: Text('🌙', style: TextStyle(fontSize: 22))),
              ),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('مواقيت الصلاة', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                Text(
                  _cityName.isNotEmpty ? 'بتوقيت $_cityName' : 'بتوقيت موقعك الحالي',
                  style: const TextStyle(fontSize: 11, color: Colors.white70),
                ),
              ])),
              AnimatedRotation(
                turns: _prayerExpanded ? 0.5 : 0,
                duration: const Duration(milliseconds: 250),
                child: const Icon(Icons.keyboard_arrow_down, color: Colors.white70, size: 24),
              ),
            ]),
          ),
        ),
        // Collapsible body
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 250),
          crossFadeState: _prayerExpanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          firstChild: _prayerLoading
              ? const Padding(padding: EdgeInsets.all(24), child: Center(child: CircularProgressIndicator(strokeWidth: 2)))
              : prayers.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text('تعذّر تحميل المواقيت', style: TextStyle(color: Colors.grey.shade500)),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Column(children: [
                        for (int i = 0; i < prayers.length; i++) ...[
                          _prayerRow(prayers[i].key, prayers[i].value, prayers[i].key == next, isDark),
                          if (i < prayers.length - 1) Divider(height: 1, color: Colors.grey.withOpacity(0.1)),
                        ],
                      ]),
                    ),
          secondChild: const SizedBox.shrink(),
        ),
      ]),
    );
  }

  Widget _prayerRow(String name, String time, bool isNext, bool isDark) {
    const Map<String, String> icons = {
      'الفجر': '🌙', 'الشروق': '🌅', 'الظهر': '☀️', 'العصر': '🌤️', 'المغرب': '🌇', 'العشاء': '🌃',
    };
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: isNext
            ? const Color(0xFF1a3a5c).withOpacity(isDark ? 0.3 : 0.08)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        border: isNext ? Border.all(color: const Color(0xFF1a3a5c).withOpacity(0.3), width: 1) : null,
      ),
      child: Row(children: [
        Text(icons[name] ?? '🕌', style: const TextStyle(fontSize: 20)),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            name,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isNext ? FontWeight.bold : FontWeight.w500,
              color: isNext ? const Color(0xFF1a3a5c) : (isDark ? Colors.white70 : Colors.black87),
            ),
          ),
          if (isNext)
            Text(
              _remainingTime(time),
              style: const TextStyle(fontSize: 11, color: Color(0xFF2e9e7a), fontWeight: FontWeight.w600),
            ),
        ])),
        Text(
          time,
          style: TextStyle(
            fontSize: 15,
            fontWeight: isNext ? FontWeight.bold : FontWeight.w500,
            color: isNext ? const Color(0xFF1a3a5c) : (isDark ? Colors.white38 : Colors.black45),
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
        if (isNext) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF1a3a5c), Color(0xFF2c5f8a)]),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text('التالية', style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ]),
    );
  }

  // ── Travel Tools Card ──

  Widget _buildTravelToolsCard(bool isDark) {
    if (!_travelToolsLoaded) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1c2333) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 14, offset: const Offset(0, 4))],
        ),
        child: const Center(child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))),
      );
    }
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1c2333) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 14, offset: const Offset(0, 4))],
      ),
      child: Column(children: [
        // Tappable header
        GestureDetector(
          onTap: () => setState(() => _travelToolsExpanded = !_travelToolsExpanded),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF4a2010), const Color(0xFF8a3a1a)]
                    : [const Color(0xFF8B4513), const Color(0xFFc0642a)],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
              borderRadius: _travelToolsExpanded
                  ? const BorderRadius.vertical(top: Radius.circular(20))
                  : BorderRadius.circular(20),
            ),
            child: Row(children: [
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
                child: const Center(child: Text('🧳', style: TextStyle(fontSize: 22))),
              ),
              const SizedBox(width: 14),
              const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('أدوات السفر', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                Text('نصائح ومستلزمات للمسافر', style: TextStyle(fontSize: 11, color: Colors.white70)),
              ])),
              AnimatedRotation(
                turns: _travelToolsExpanded ? 0.5 : 0,
                duration: const Duration(milliseconds: 250),
                child: const Icon(Icons.keyboard_arrow_down, color: Colors.white70, size: 24),
              ),
            ]),
          ),
        ),
        // Collapsible body
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 250),
          crossFadeState: _travelToolsExpanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          firstChild: !_travelToolsLoaded
              ? const Padding(padding: EdgeInsets.all(24), child: Center(child: CircularProgressIndicator(strokeWidth: 2)))
              : _travelTools.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text('لا توجد أدوات حتى الآن', style: TextStyle(color: Colors.grey.shade500)),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Column(children: [
                        for (int i = 0; i < _travelTools.length; i++) ...[
                          Builder(builder: (_) {
                            final tool = _travelTools[i];
                            final icon = (tool['icon'] as String?) ?? '🔧';
                            final title = (tool['title'] as String?) ?? '';
                            final desc = (tool['description'] as String?) ?? '';
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text(icon, style: const TextStyle(fontSize: 22)),
                                const SizedBox(width: 12),
                                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
                                  if (desc.isNotEmpty) ...[
                                    const SizedBox(height: 3),
                                    Text(desc, style: TextStyle(fontSize: 12, color: isDark ? Colors.white60 : Colors.black54, height: 1.4)),
                                  ],
                                ])),
                              ]),
                            );
                          }),
                          if (i < _travelTools.length - 1) Divider(height: 1, color: Colors.grey.withOpacity(0.1)),
                        ],
                      ]),
                    ),
          secondChild: const SizedBox.shrink(),
        ),
      ]),
    );
  }

  // ── Qibla Card ──

  Widget _buildQiblaCard(bool isDark) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => QiblaScreen(initialPosition: _userPosition)),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF0d3b6e), Color(0xFF1a6b8a)],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: const Color(0xFF0d3b6e).withOpacity(0.4), blurRadius: 18, offset: const Offset(0, 6))],
        ),
        child: Stack(children: [
          // Background decorative circle
          Positioned(right: -20, top: -20, child: Container(
            width: 110, height: 110,
            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.05)),
          )),
          Positioned(right: 10, top: 10, child: Container(
            width: 70, height: 70,
            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.05)),
          )),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(children: [
              // Compass icon circle
              Container(
                width: 62, height: 62,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.12),
                  border: Border.all(color: Colors.white.withOpacity(0.25), width: 1.5),
                ),
                child: const Center(child: Text('🧭', style: TextStyle(fontSize: 30))),
              ),
              const SizedBox(width: 16),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('اتجاه القبلة', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 4),
                Text(
                  _userPosition != null ? 'اضغط لفتح البوصلة' : 'اضغط لتحديد موقعك',
                  style: const TextStyle(fontSize: 12, color: Colors.white70),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(mainAxisSize: MainAxisSize.min, children: [
                    Text('🕋', style: TextStyle(fontSize: 13)),
                    SizedBox(width: 6),
                    Text('افتح البوصلة', style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600)),
                  ]),
                ),
              ])),
            ]),
          ),
        ]),
      ),
    );
  }
}
