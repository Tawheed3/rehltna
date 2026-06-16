import 'notification_service.dart';
import '../../features/prayer_times/domain/entities/prayer_times.dart';

class PrayerNotificationService {
  final NotificationService _notificationService = NotificationService();

  // تفعيل الإشعارات (نسخة مبسطة)
  Future<void> enableNotifications(PrayerTimes prayerTimes) async {
    await _notificationService.init();

    // إشعار ترحيبي
    await _notificationService.showNotification(
      id: 999,
      title: '🕌 تفعيل إشعارات الأذان',
      body: 'تم تفعيل الإشعارات بنجاح',
    );

    // يمكن إضافة إشعارات لكل صلاة هنا حسب الحاجة
    print('✅ Prayer notifications enabled');
  }

  // إيقاف الإشعارات
  Future<void> disableNotifications() async {
    await _notificationService.cancelAll();
    print('✅ All notifications disabled');
  }

  // إشعار تجريبي
  Future<void> testNotification() async {
    await _notificationService.init();
    await _notificationService.showNotification(
      id: 888,
      title: '🕌 اختبار الإشعارات',
      body: 'هذا إشعار تجريبي',
    );
  }
}