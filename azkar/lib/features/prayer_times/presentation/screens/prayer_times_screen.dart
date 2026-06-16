import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../../core/services/location_service.dart';
import '../../../../core/services/storage_service.dart';
import '../../domain/entities/prayer_times.dart';
import '../providers/prayer_times_provider.dart';

// Notification State Provider
final notificationStateProvider = StateNotifierProvider<NotificationNotifier, NotificationState>((ref) {
  return NotificationNotifier();
});

class NotificationState {
  final bool isEnabled;
  const NotificationState({this.isEnabled = false});

  NotificationState copyWith({bool? isEnabled}) {
    return NotificationState(isEnabled: isEnabled ?? this.isEnabled);
  }
}

class NotificationNotifier extends StateNotifier<NotificationState> {
  NotificationNotifier() : super(const NotificationState());
  void setEnabled(bool value) => state = state.copyWith(isEnabled: value);
}

class PrayerTimesScreen extends ConsumerStatefulWidget {
  const PrayerTimesScreen({super.key});

  @override
  ConsumerState<PrayerTimesScreen> createState() => _PrayerTimesScreenState();
}

class _PrayerTimesScreenState extends ConsumerState<PrayerTimesScreen> {
  final LocationService _locationService = LocationService();
  bool _isLoadingLocation = true;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _loadSavedDataOrFetch();
  }

  @override
  void dispose() {
    // تنظيف الموارد
    super.dispose();
  }

  // تحميل البيانات المخزنة أولاً، ثم تحديثها
  Future<void> _loadSavedDataOrFetch() async {
    if (!mounted) return;

    setState(() => _isLoadingLocation = true);

    // محاولة تحميل البيانات المخزنة
    final hasSavedData = await _loadSavedPrayerTimes();

    if (!hasSavedData) {
      // إذا لم تكن هناك بيانات مخزنة، جلب من API
      await _fetchPrayerTimes();
    }

    if (mounted) {
      setState(() => _isLoadingLocation = false);
    }
  }

  // تحميل البيانات المخزنة من Hive
  Future<bool> _loadSavedPrayerTimes() async {
    try {
      final storageService = await StorageService.getInstance();

      final savedLat = await storageService.getData('prayer_cache', 'latitude');
      final savedLon = await storageService.getData('prayer_cache', 'longitude');
      final savedFajr = await storageService.getData('prayer_cache', 'fajr');
      final savedSunrise = await storageService.getData('prayer_cache', 'sunrise');
      final savedDhuhr = await storageService.getData('prayer_cache', 'dhuhr');
      final savedAsr = await storageService.getData('prayer_cache', 'asr');
      final savedMaghrib = await storageService.getData('prayer_cache', 'maghrib');
      final savedIsha = await storageService.getData('prayer_cache', 'isha');
      final savedDate = await storageService.getData('prayer_cache', 'date');
      final savedHijri = await storageService.getData('prayer_cache', 'hijriDate');

      if (savedFajr != null && savedDate != null && savedLat != null && savedLon != null) {
        // تحديث حالة الـ Provider بالبيانات المخزنة
        ref.read(prayerTimesStateProvider.notifier).setCachedData(
          prayerTimes: PrayerTimes(
            fajr: savedFajr as String,
            sunrise: savedSunrise as String? ?? '--:--',
            dhuhr: savedDhuhr as String? ?? '--:--',
            asr: savedAsr as String? ?? '--:--',
            maghrib: savedMaghrib as String? ?? '--:--',
            isha: savedIsha as String? ?? '--:--',
            date: savedDate as String,
            hijriDate: savedHijri as String? ?? '',
            latitude: savedLat as double,
            longitude: savedLon as double,
          ),
        );
        print('✅ تم تحميل البيانات المخزنة من: $savedDate');
        return true;
      }
    } catch (e) {
      print('❌ خطأ في تحميل البيانات المخزنة: $e');
    }
    return false;
  }

  // حفظ البيانات في Hive
  Future<void> _savePrayerTimes(PrayerTimes prayerTimes) async {
    try {
      final storageService = await StorageService.getInstance();

      await storageService.saveData('prayer_cache', 'latitude', prayerTimes.latitude);
      await storageService.saveData('prayer_cache', 'longitude', prayerTimes.longitude);
      await storageService.saveData('prayer_cache', 'fajr', prayerTimes.fajr);
      await storageService.saveData('prayer_cache', 'sunrise', prayerTimes.sunrise);
      await storageService.saveData('prayer_cache', 'dhuhr', prayerTimes.dhuhr);
      await storageService.saveData('prayer_cache', 'asr', prayerTimes.asr);
      await storageService.saveData('prayer_cache', 'maghrib', prayerTimes.maghrib);
      await storageService.saveData('prayer_cache', 'isha', prayerTimes.isha);
      await storageService.saveData('prayer_cache', 'date', prayerTimes.date);
      await storageService.saveData('prayer_cache', 'hijriDate', prayerTimes.hijriDate);

      print('✅ تم حفظ البيانات بنجاح');
    } catch (e) {
      print('❌ خطأ في حفظ البيانات: $e');
    }
  }

  // جلب البيانات من API وتحديثها
  Future<void> _fetchPrayerTimes() async {
    final location = await _locationService.getCurrentLocation();

    if (location != null && mounted) {
      await ref.read(prayerTimesStateProvider.notifier).fetchPrayerTimes(
        latitude: location.latitude!,
        longitude: location.longitude!,
      );

      // حفظ البيانات بعد الجلب
      if (mounted) {
        final state = ref.read(prayerTimesStateProvider);
        if (state.prayerTimes != null) {
          await _savePrayerTimes(state.prayerTimes!);
        }
      }
    }
  }

  // ✅ تحديث البيانات عند سحب الشاشة (مع التحقق من mounted)
  Future<void> _onRefresh() async {
    if (!mounted) return;

    setState(() => _isRefreshing = true);
    await _fetchPrayerTimes();

    if (mounted) {
      setState(() => _isRefreshing = false);
    }
  }

  Future<String> _getCityName(double lat, double lon) async {
    try {
      final dio = Dio();
      dio.options.headers['User-Agent'] = 'IslamicDawahApp/1.0';

      final response = await dio.get(
        'https://nominatim.openstreetmap.org/reverse',
        queryParameters: {
          'lat': lat,
          'lon': lon,
          'format': 'json',
          'accept-language': 'ar',
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final address = response.data['address'];
        final city = address['city'] ??
            address['town'] ??
            address['village'] ??
            address['state'] ??
            'موقعك الحالي';
        return city;
      }
    } catch (e) {
      print('❌ خطأ في جلب اسم المدينة: $e');
    }
    return 'موقعك الحالي';
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(prayerTimesStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('أوقات الصلاة'),
        backgroundColor: Colors.green,
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isRefreshing ? null : _onRefresh,
          ),
        ],
      ),
      body: _buildBody(state),
    );
  }

  Widget _buildBody(PrayerTimesState state) {
    if (_isLoadingLocation && state.prayerTimes == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.green)),
            SizedBox(height: 16),
            Text('جاري تحميل البيانات...', style: TextStyle(color: Colors.green)),
          ],
        ),
      );
    }

    if (state.error != null && state.prayerTimes == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(state.error!, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _onRefresh,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      );
    }

    if (state.prayerTimes == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.access_time, size: 64, color: Colors.green),
            SizedBox(height: 16),
            Text('لا توجد بيانات. اسحب لأسفل للتحديث'),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      color: Colors.green,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildLocationCard(state),
            const SizedBox(height: 16),
            _buildDateCard(state),
            const SizedBox(height: 16),
            _buildPrayerTimesCard(state),
            const SizedBox(height: 16),
            _buildLastUpdateInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationCard(PrayerTimesState state) {
    return FutureBuilder<String>(
      future: _getCityName(state.prayerTimes!.latitude, state.prayerTimes!.longitude),
      builder: (context, snapshot) {
        final locationName = snapshot.data ?? 'موقعك الحالي';
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.location_on, size: 32, color: Colors.green),
                ),
                const SizedBox(height: 12),
                Text(
                  locationName,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  '${state.prayerTimes!.latitude.toStringAsFixed(4)}°, ${state.prayerTimes!.longitude.toStringAsFixed(4)}°',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDateCard(PrayerTimesState state) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(Icons.calendar_today, size: 28, color: Colors.green),
            const SizedBox(height: 12),
            Text(
              state.prayerTimes!.date,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                state.prayerTimes!.hijriDate,
                style: const TextStyle(fontSize: 14, color: Colors.green, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrayerTimesCard(PrayerTimesState state) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: const BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
            ),
            child: const Center(
              child: Text(
                '🕋 مواقيت الصلاة 🕋',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
          _buildPrayerRow('الفجر', state.prayerTimes!.fajr, Icons.wb_twilight),
          _buildDivider(),
          _buildPrayerRow('الشروق', state.prayerTimes!.sunrise, Icons.wb_sunny),
          _buildDivider(),
          _buildPrayerRow('الظهر', state.prayerTimes!.dhuhr, Icons.sunny),
          _buildDivider(),
          _buildPrayerRow('العصر', state.prayerTimes!.asr, Icons.sunny_snowing),
          _buildDivider(),
          _buildPrayerRow('المغرب', state.prayerTimes!.maghrib, Icons.nights_stay),
          _buildDivider(),
          _buildPrayerRow('العشاء', state.prayerTimes!.isha, Icons.nightlight_round),
        ],
      ),
    );
  }

  Widget _buildLastUpdateInfo() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Text(
        _isRefreshing ? 'جاري التحديث...' : 'اسحب لأسفل لتحديث المواقيت',
        style: const TextStyle(fontSize: 12, color: Colors.grey),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildPrayerRow(String name, String time, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.green, size: 28),
      title: Text(
        name,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          time,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 0, indent: 20, endIndent: 20, color: Colors.grey);
  }
}