import 'dart:developer' as developer;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/auth_provider.dart';
import '../providers/base_provider.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  String? _fcmToken;
  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    try {
      developer.log('[Notifications] Initializing...', name: BaseProvider.logTag);

      NotificationSettings settings = await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus != AuthorizationStatus.authorized) {
        developer.log('[Notifications] Permission denied by user', name: BaseProvider.logTag, level: 900);
        return;
      }

      await _initLocalNotifications();

      _fcmToken = await _firebaseMessaging.getToken();
      developer.log('[Notifications] FCM Token: $_fcmToken', name: BaseProvider.logTag);

      // ✅ حفظ الـ FCM Token محلياً
      if (_fcmToken != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('fcm_token', _fcmToken!);
      }

      _firebaseMessaging.onTokenRefresh.listen((newToken) async {
        developer.log('[Notifications] FCM Token refreshed: $newToken', name: BaseProvider.logTag);
        _fcmToken = newToken;
        // ✅ حفظ الـ token الجديد
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('fcm_token', newToken);
      });

      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
      FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

      RemoteMessage? initialMessage = await _firebaseMessaging.getInitialMessage();
      if (initialMessage != null) {
        _handleMessageOpenedApp(initialMessage);
      }

      _isInitialized = true;
      developer.log('[Notifications] Initialized successfully', name: BaseProvider.logTag);
    } catch (e) {
      developer.log('[Notifications] Init error: $e', name: BaseProvider.logTag, level: 1000);
    }
  }

  Future<void> _initLocalNotifications() async {
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings();
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        _handleLocalNotificationTap(response);
      },
    );
  }

  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    developer.log('[Notifications] Background message: ${message.messageId}', name: BaseProvider.logTag);
  }

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    developer.log('[Notifications] Foreground message: ${message.messageId}', name: BaseProvider.logTag);
    await _showLocalNotification(message);
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'rehlatna_channel',
      'إشعارات رحلتنا',
      channelDescription: 'إشعارات التطبيق',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
    );

    final NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: const DarwinNotificationDetails(),
    );

    await _localNotifications.show(
      message.hashCode,
      message.notification?.title ?? 'إشعار جديد',
      message.notification?.body ?? 'لديك إشعار جديد',
      notificationDetails,
      payload: message.data['postId'] ?? '',
    );
  }

  void _handleMessageOpenedApp(RemoteMessage message) {
    developer.log('[Notifications] App opened from notification: ${message.messageId}', name: BaseProvider.logTag);
  }

  void _handleLocalNotificationTap(NotificationResponse response) {
    developer.log('[Notifications] Local notification tapped: ${response.payload}', name: BaseProvider.logTag);
  }

  Future<void> sendLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'rehlatna_channel',
      'إشعارات رحلتنا',
      channelDescription: 'إشعارات التطبيق',
      importance: Importance.high,
      priority: Priority.high,
    );

    final NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: const DarwinNotificationDetails(),
    );

    await _localNotifications.show(
      0,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
    developer.log('[Notifications] Subscribed to topic: $topic', name: BaseProvider.logTag);
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
    developer.log('[Notifications] Unsubscribed from topic: $topic', name: BaseProvider.logTag);
  }

  Future<String?> getToken() async {
    if (_fcmToken == null) {
      _fcmToken = await _firebaseMessaging.getToken();
      // ✅ حفظ الـ token عند استرجاعه
      if (_fcmToken != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('fcm_token', _fcmToken!);
      }
    }
    return _fcmToken;
  }
}