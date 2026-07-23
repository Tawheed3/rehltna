// ==================== notification_service.dart ====================
import 'dart:developer' as developer;
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
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

  /// ✅ مفتاح التنقل العام عشان نقدر نروح لأي شاشة من الإشعار
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<void> init() async {
    if (_isInitialized) return;

    try {
      developer.log('[Notifications] Initializing...', name: BaseProvider.logTag);
      debugPrint('[Notifications] Initializing...');

      // ✅ نطلب إذن الإشعارات عند فتح التطبيق
      NotificationSettings settings = await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      developer.log('[Notifications] Permission status: ${settings.authorizationStatus}', name: BaseProvider.logTag);
      debugPrint('[Notifications] Permission status: ${settings.authorizationStatus}');

      // نكمّل طالما المستخدم ما رفضش صراحة (authorized أو provisional)
      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        developer.log('[Notifications] Permission denied by user', name: BaseProvider.logTag, level: 900);
        debugPrint('[Notifications] Permission denied by user — enable it from iOS Settings');
        return;
      }

      // iOS: show banners even when app is in foreground
      await _firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      await _initLocalNotifications();

      _fcmToken = await _fetchFcmToken();
      // ⚠️ نطبع التوكن في وضع التطوير فقط — عشان ما يتسربش في الإنتاج
      if (kDebugMode) {
        developer.log('[Notifications] FCM Token: $_fcmToken', name: BaseProvider.logTag);
        debugPrint('[Notifications] FCM Token: $_fcmToken');
      }

      if (_fcmToken != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('fcm_token', _fcmToken!);
      }

      _firebaseMessaging.onTokenRefresh.listen((newToken) async {
        if (kDebugMode) {
          developer.log('[Notifications] FCM Token refreshed: $newToken', name: BaseProvider.logTag);
        }
        _fcmToken = newToken;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('fcm_token', newToken);
      });

      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
      FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

      RemoteMessage? initialMessage = await _firebaseMessaging.getInitialMessage();
      if (initialMessage != null) {
        developer.log('[Notifications] Initial message received: ${initialMessage.messageId}', name: BaseProvider.logTag);
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
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      defaultPresentAlert: true,
      defaultPresentBadge: true,
      defaultPresentSound: true,
    );
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

  @pragma('vm:entry-point')
  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    developer.log('[Notifications] Background message: ${message.messageId}', name: BaseProvider.logTag);
    final NotificationService service = NotificationService();
    await service._showBackgroundNotification(message);
  }

  Future<void> _showBackgroundNotification(RemoteMessage message) async {
    try {
      final itemId = _extractItemId(message);

      final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        'rehlatna_channel',
        'إشعارات رحلتنا',
        channelDescription: 'إشعارات التطبيق',
        importance: Importance.high,
        priority: Priority.high,
      );

      final NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: const DarwinNotificationDetails(presentAlert: true, presentBadge: true, presentSound: true),
      );

      await _localNotifications.show(
        message.hashCode,
        message.notification?.title ?? 'إشعار جديد',
        message.notification?.body ?? 'لديك إشعار جديد',
        notificationDetails,
        payload: itemId,
      );
    } catch (e) {
      developer.log('[Notifications] Background notification error: $e', name: BaseProvider.logTag);
    }
  }

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    developer.log('[Notifications] Foreground message: ${message.messageId}', name: BaseProvider.logTag);
    developer.log('[Notifications] Message data: ${message.data}', name: BaseProvider.logTag);

    final itemId = _extractItemId(message);
    developer.log('[Notifications] Extracted itemId: "$itemId"', name: BaseProvider.logTag);

    if (itemId.isNotEmpty) {
      await _showLocalNotification(message, itemId);
    } else {
      await _showLocalNotificationWithoutNavigation(message);
    }
  }

  Future<void> _showLocalNotification(RemoteMessage message, String itemId) async {
    developer.log('[Notifications] Showing local notification for item: $itemId', name: BaseProvider.logTag);

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
      payload: itemId,
    );
  }

  /// عرض إشعار بدون itemId (لا يؤدي للتنقل)
  Future<void> _showLocalNotificationWithoutNavigation(RemoteMessage message) async {
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
      message.hashCode,
      message.notification?.title ?? 'إشعار جديد',
      message.notification?.body ?? 'لديك إشعار جديد',
      notificationDetails,
      payload: '',
    );
  }

  /// ✅ استخراج الـ itemId من الـ message بطرق مختلفة
  String _extractItemId(RemoteMessage message) {
    developer.log('[Notifications] Extracting from data: ${message.data}', name: BaseProvider.logTag);

    // ✅ الأولوية لـ trip_id (المستخدم في الإشعارات)
    if (message.data.containsKey('trip_id')) {
      final tripId = message.data['trip_id']?.toString();
      if (tripId != null && tripId.isNotEmpty && tripId != '0') {
        developer.log('[Notifications] Found trip_id: $tripId', name: BaseProvider.logTag);
        return tripId;
      }
    }

    // محاولة من item_id
    if (message.data.containsKey('item_id')) {
      final itemId = message.data['item_id']?.toString();
      if (itemId != null && itemId.isNotEmpty && itemId != '0') {
        developer.log('[Notifications] Found item_id: $itemId', name: BaseProvider.logTag);
        return itemId;
      }
    }

    // محاولة من postId
    if (message.data.containsKey('postId')) {
      final postId = message.data['postId']?.toString();
      if (postId != null && postId.isNotEmpty && postId != '0') {
        developer.log('[Notifications] Found postId: $postId', name: BaseProvider.logTag);
        return postId;
      }
    }

    // محاولة من id
    if (message.data.containsKey('id')) {
      final id = message.data['id']?.toString();
      if (id != null && id.isNotEmpty && id != '0') {
        developer.log('[Notifications] Found id: $id', name: BaseProvider.logTag);
        return id;
      }
    }

    // محاولة من الـ notification title (مثال: "رحلة #123")
    if (message.notification != null) {
      final title = message.notification!.title ?? '';
      final regex = RegExp(r'#(\d+)');
      final match = regex.firstMatch(title);
      if (match != null) {
        final idFromTitle = match.group(1) ?? '';
        developer.log('[Notifications] Extracted from title: $idFromTitle', name: BaseProvider.logTag);
        return idFromTitle;
      }
    }

    developer.log('[Notifications] Could not extract itemId from message: ${message.data}', name: BaseProvider.logTag, level: 900);
    return '';
  }

  void _handleMessageOpenedApp(RemoteMessage message) {
    developer.log('[Notifications] App opened from notification: ${message.messageId}', name: BaseProvider.logTag);
    developer.log('[Notifications] Message data: ${message.data}', name: BaseProvider.logTag);

    final itemId = _extractItemId(message);
    developer.log('[Notifications] Extracted itemId: "$itemId"', name: BaseProvider.logTag);

    if (itemId.isNotEmpty) {
      Future.delayed(const Duration(milliseconds: 500), () {
        _navigateToItem(itemId);
      });
    } else {
      developer.log('[Notifications] No itemId found, cannot navigate', name: BaseProvider.logTag, level: 900);
    }
  }

  void _handleLocalNotificationTap(NotificationResponse response) {
    developer.log('[Notifications] Local notification tapped: ${response.payload}', name: BaseProvider.logTag);

    final itemId = response.payload ?? '';

    if (itemId.isNotEmpty) {
      _navigateToItem(itemId);
    }
  }

  /// ✅ التنقل لشاشة تفاصيل الرحلة
  void _navigateToItem(String itemId) {
    developer.log('[Notifications] _navigateToItem called with itemId: $itemId', name: BaseProvider.logTag);

    final id = int.tryParse(itemId);
    if (id == null || id == 0) {
      developer.log('[Notifications] Invalid item ID after parsing: $itemId', name: BaseProvider.logTag);
      return;
    }

    developer.log('[Notifications] Valid ID: $id, attempting navigation...', name: BaseProvider.logTag);

    final context = navigatorKey.currentContext;
    if (context == null) {
      developer.log('[Notifications] No context available for navigation', name: BaseProvider.logTag);
      return;
    }

    developer.log('[Notifications] Context available, navigating to /details/$id', name: BaseProvider.logTag);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        GoRouter.of(context).push('/details/$id');
        developer.log('[Notifications] Navigation successful!', name: BaseProvider.logTag);
      } catch (e) {
        developer.log('[Notifications] Navigation failed: $e', name: BaseProvider.logTag);

        // محاولة بديلة
        try {
          GoRouter.of(context).go('/details/$id');
          developer.log('[Notifications] Alternative navigation (go) successful!', name: BaseProvider.logTag);
        } catch (e2) {
          developer.log('[Notifications] Alternative navigation also failed: $e2', name: BaseProvider.logTag);
        }
      }
    });
  }

  // ==================== إشعار محلي مخصص ====================

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

  // ==================== الاشتراك في المواضيع ====================

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
      _fcmToken = await _fetchFcmToken();
      if (_fcmToken != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('fcm_token', _fcmToken!);
      }
    }
    return _fcmToken;
  }

  /// ✅ جلب FCM token — على iOS لازم ننتظر APNs token الأول
  /// وإلا بيرجع null (وده سبب إن iOS ما كانش بيبعت توكن للـ backend)
  Future<String?> _fetchFcmToken() async {
    try {
      if (Platform.isIOS) {
        String? apnsToken = await _firebaseMessaging.getAPNSToken();

        // APNs token ممكن ياخد لحظات بعد التسجيل — نعمل retry بسيط
        for (var i = 0; i < 10 && apnsToken == null; i++) {
          debugPrint('[Notifications] Waiting for APNS token... attempt ${i + 1}');
          await Future.delayed(const Duration(seconds: 1));
          apnsToken = await _firebaseMessaging.getAPNSToken();
        }

        if (apnsToken == null) {
          developer.log(
            '[Notifications] APNS token still null — cannot mint FCM token',
            name: BaseProvider.logTag,
            level: 900,
          );
          debugPrint('[Notifications] APNS token still NULL — no APNs registration (check permission / Firebase APNs key / Push capability)');
          return null;
        }
        if (kDebugMode) {
          developer.log('[Notifications] APNS Token: $apnsToken', name: BaseProvider.logTag);
          debugPrint('[Notifications] APNS Token: $apnsToken');
        }
      }

      return await _firebaseMessaging.getToken();
    } catch (e) {
      developer.log('[Notifications] getToken error: $e', name: BaseProvider.logTag, level: 1000);
      return null;
    }
  }
}