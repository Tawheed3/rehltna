import 'package:permission_handler/permission_handler.dart';

// WHY: Single source of truth for all permission requests
class PermissionService {
  // Request location permission (for Prayer Times & Qibla)
  Future<bool> requestLocationPermission() async {
    final status = await Permission.location.request();
    return status.isGranted;
  }

  // Request notification permission (for Adhan alerts)
  Future<bool> requestNotificationPermission() async {
    final status = await Permission.notification.request();
    return status.isGranted;
  }

  // Check if we have location permission
  Future<bool> hasLocationPermission() async {
    final status = await Permission.location.status;
    return status.isGranted;
  }

  // Check if we have notification permission
  Future<bool> hasNotificationPermission() async {
    final status = await Permission.notification.status;
    return status.isGranted;
  }

  // Request multiple permissions at once
  Future<Map<Permission, PermissionStatus>> requestPermissions(
      List<Permission> permissions,
      ) async {
    return await permissions.request();
  }

  // Open app settings (when permission permanently denied)
  Future<void> openAppSettings() async {
    await openAppSettings();
  }
}