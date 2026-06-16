import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../core/services/prayer_notification_service.dart';
import 'prayer_times_provider.dart';

// Notification service provider
final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

// Prayer notification service provider
final prayerNotificationServiceProvider = Provider<PrayerNotificationService>((ref) {
  return PrayerNotificationService();
});

// Notification state provider
final notificationStateProvider = StateNotifierProvider<NotificationNotifier, NotificationState>((ref) {
  return NotificationNotifier();
});

class NotificationState {
  final bool isEnabled;
  final bool isScheduled;
  final String? lastError;

  const NotificationState({
    this.isEnabled = false,
    this.isScheduled = false,
    this.lastError,
  });

  NotificationState copyWith({
    bool? isEnabled,
    bool? isScheduled,
    String? lastError,
  }) {
    return NotificationState(
      isEnabled: isEnabled ?? this.isEnabled,
      isScheduled: isScheduled ?? this.isScheduled,
      lastError: lastError ?? this.lastError,
    );
  }
}

class NotificationNotifier extends StateNotifier<NotificationState> {
  NotificationNotifier() : super(const NotificationState());

  void setEnabled(bool enabled) {
    state = state.copyWith(isEnabled: enabled);
  }

  void setScheduled(bool scheduled) {
    state = state.copyWith(isScheduled: scheduled);
  }

  void setError(String error) {
    state = state.copyWith(lastError: error);
  }

  void clearError() {
    state = state.copyWith(lastError: null);
  }
}