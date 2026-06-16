import 'package:location/location.dart';

class LocationService {
  final Location _location = Location();

  Future<bool> isLocationEnabled() async {
    try {
      return await _location.serviceEnabled();
    } catch (e) {
      print('Error checking location service: $e');
      return false;
    }
  }

  Future<bool> requestPermission() async {
    try {
      final permission = await _location.requestPermission();
      return permission == PermissionStatus.granted;
    } catch (e) {
      print('Error requesting permission: $e');
      return false;
    }
  }

  Future<LocationData?> getCurrentLocation() async {
    try {
      bool serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _location.requestService();
        if (!serviceEnabled) {
          print('Location service not enabled');
          return null;
        }
      }

      PermissionStatus permissionGranted = await _location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await _location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          print('Location permission not granted');
          return null;
        }
      }

      final locationData = await _location.getLocation();
      return locationData;
    } catch (e) {
      print('Error getting location: $e');
      return null;
    }
  }

  Stream<LocationData> get locationStream {
    try {
      return _location.onLocationChanged;
    } catch (e) {
      print('Error getting location stream: $e');
      return Stream.empty();
    }
  }
}