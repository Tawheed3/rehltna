import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/location_service.dart';
import '../services/permission_service.dart';
import '../services/storage_service.dart';

// WHY: Singleton providers for dependency injection
// These services will be available throughout the app

// Location Service Provider (Singleton)
final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService();
});

// Permission Service Provider (Singleton)
final permissionServiceProvider = Provider<PermissionService>((ref) {
  return PermissionService();
});

// Storage Service Provider (Async - needs initialization)
final storageServiceProvider = FutureProvider<StorageService>((ref) async {
  return await StorageService.getInstance();
});