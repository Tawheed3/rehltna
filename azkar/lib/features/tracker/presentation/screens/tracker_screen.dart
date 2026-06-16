import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/prayer_record.dart';
import '../providers/tracker_provider.dart';

class TrackerScreen extends ConsumerStatefulWidget {
  const TrackerScreen({super.key});

  @override
  ConsumerState<TrackerScreen> createState() => _TrackerScreenState();
}

class _TrackerScreenState extends ConsumerState<TrackerScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(trackerStateProvider.notifier).loadData());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(trackerStateProvider);
    final notifier = ref.read(trackerStateProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('تتبع الصلوات'),
        backgroundColor: Colors.green,
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: state.isLoading ? null : () => notifier.loadData(),
          ),
        ],
      ),
      body: _buildBody(state, notifier),
    );
  }

  Widget _buildBody(TrackerState state, TrackerNotifier notifier) {
    if (state.isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            ),
            SizedBox(height: 16),
            Text('جاري تحميل البيانات...'),
          ],
        ),
      );
    }

    if (state.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(state.error!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => notifier.loadData(),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      );
    }

    if (state.todayRecord == null) {
      return const Center(child: Text('لا توجد بيانات'));
    }

    return RefreshIndicator(
      onRefresh: () => notifier.loadData(),
      color: Colors.green,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDonationMessage(),
            const SizedBox(height: 16),
            _buildDailyProgressCard(state),
            const SizedBox(height: 16),
            _buildPrayerButtons(state, notifier),
            const SizedBox(height: 16),
            _buildWeeklyStatsCard(state),
          ],
        ),
      ),
    );
  }

  Widget _buildDonationMessage() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primaryColor, AppTheme.primaryColor.withOpacity(0.7)],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.volunteer_activism, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              AppConstants.donationMessage,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyProgressCard(TrackerState state) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'تقدم اليوم',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${state.dailyProgress.toStringAsFixed(0)}%',
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: state.dailyProgress / 100,
              backgroundColor: Colors.grey.shade200,
              color: Colors.green,
              minHeight: 12,
              borderRadius: BorderRadius.circular(6),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  'صليت',
                  '${state.todayRecord?.prayedCount ?? 0}',
                  Icons.check_circle,
                  Colors.green,
                ),
                _buildStatItem(
                  'قضاء',
                  '${state.todayRecord?.qadaCount ?? 0}',
                  Icons.access_time,
                  Colors.orange,
                ),
                _buildStatItem(
                  'متبقي',
                  '${5 - (state.todayRecord?.prayedCount ?? 0) - (state.todayRecord?.qadaCount ?? 0)}',
                  Icons.pending,
                  Colors.grey,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildPrayerButtons(TrackerState state, TrackerNotifier notifier) {
    final List<Map<String, dynamic>> prayers = [
      {'name': 'Fajr', 'arabic': 'الفجر', 'icon': Icons.wb_twilight},
      {'name': 'Dhuhr', 'arabic': 'الظهر', 'icon': Icons.sunny},
      {'name': 'Asr', 'arabic': 'العصر', 'icon': Icons.sunny_snowing},
      {'name': 'Maghrib', 'arabic': 'المغرب', 'icon': Icons.nights_stay},
      {'name': 'Isha', 'arabic': 'العشاء', 'icon': Icons.nightlight_round},
    ];

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: const BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: const Center(
              child: Text(
                'سجل صلوات اليوم',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
          ...prayers.map((prayer) => _buildPrayerButton(
            arabicName: prayer['arabic'] as String,
            name: prayer['name'] as String,
            icon: prayer['icon'] as IconData,
            status: state.todayRecord?.prayers[prayer['name'] as String] ?? PrayerStatus.notPrayed,
            onTap: () => notifier.togglePrayerStatus(prayer['name'] as String),
          )),
        ],
      ),
    );
  }

  Widget _buildPrayerButton({
    required String arabicName,
    required String name,
    required IconData icon,
    required PrayerStatus status,
    required VoidCallback onTap,
  }) {
    Color getColor() {
      switch (status) {
        case PrayerStatus.prayed:
          return Colors.green;
        case PrayerStatus.qada:
          return Colors.orange;
        case PrayerStatus.notPrayed:
          return Colors.grey;
      }
    }

    String getStatusText() {
      switch (status) {
        case PrayerStatus.prayed:
          return 'صليت';
        case PrayerStatus.qada:
          return 'قضاء';
        case PrayerStatus.notPrayed:
          return 'لم يُصلى';
      }
    }

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: getColor().withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: getColor(), size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                arabicName,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: getColor().withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    status == PrayerStatus.prayed ? Icons.check_circle :
                    status == PrayerStatus.qada ? Icons.access_time :
                    Icons.radio_button_unchecked,
                    color: getColor(),
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    getStatusText(),
                    style: TextStyle(color: getColor(), fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyStatsCard(TrackerState state) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.bar_chart, color: Colors.green),
                SizedBox(width: 8),
                Text(
                  'إحصائيات الأسبوع',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildWeeklyStat(
                  'نسبة الإنجاز',
                  '${state.weeklyProgress.toStringAsFixed(0)}%',
                  Colors.green,
                ),
                _buildWeeklyStat(
                  'أيام كاملة',
                  '${state.completeDaysCount}/7',
                  Colors.blue,
                ),
                _buildWeeklyStat(
                  'إجمالي الصلوات',
                  '${state.weeklyRecords.fold(0, (sum, r) => sum + r.prayedCount)}/35',
                  Colors.orange,
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: state.weeklyProgress / 100,
              backgroundColor: Colors.grey.shade200,
              color: Colors.green,
              minHeight: 10,
              borderRadius: BorderRadius.circular(5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}