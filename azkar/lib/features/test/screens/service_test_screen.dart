import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/service_providers.dart';

class ServiceTestScreen extends ConsumerStatefulWidget {
  const ServiceTestScreen({super.key});

  @override
  ConsumerState<ServiceTestScreen> createState() => _ServiceTestScreenState();
}

class _ServiceTestScreenState extends ConsumerState<ServiceTestScreen> {
  String _locationStatus = 'Not tested';
  String _permissionStatus = 'Not tested';
  String _storageStatus = 'Not tested';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Test'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              child: ListTile(
                title: const Text('Location Service'),
                subtitle: Text(_locationStatus),
                trailing: ElevatedButton(
                  onPressed: _testLocationService,
                  child: const Text('Test'),
                ),
              ),
            ),
            Card(
              child: ListTile(
                title: const Text('Permission Service'),
                subtitle: Text(_permissionStatus),
                trailing: ElevatedButton(
                  onPressed: _testPermissionService,
                  child: const Text('Test'),
                ),
              ),
            ),
            Card(
              child: ListTile(
                title: const Text('Storage Service'),
                subtitle: Text(_storageStatus),
                trailing: ElevatedButton(
                  onPressed: _testStorageService,
                  child: const Text('Test'),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              '✅ All services working? Ready for Phase 3!',
              style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _testLocationService() async {
    setState(() => _locationStatus = 'Testing...');

    final locationService = ref.read(locationServiceProvider);
    final location = await locationService.getCurrentLocation();

    if (location != null) {
      setState(() {
        _locationStatus = '✅ Success!\nLat: ${location.latitude}, Lon: ${location.longitude}';
      });
    } else {
      setState(() => _locationStatus = '❌ Failed - Check permissions');
    }
  }

  Future<void> _testPermissionService() async {
    setState(() => _permissionStatus = 'Testing...');

    final permissionService = ref.read(permissionServiceProvider);
    final hasLocation = await permissionService.hasLocationPermission();

    setState(() {
      _permissionStatus = '✅ Location permission: ${hasLocation ? "Granted" : "Not granted"}\n'
          'Use the button above to request if needed';
    });
  }

  Future<void> _testStorageService() async {
    setState(() => _storageStatus = 'Testing...');

    try {
      final storageAsync = ref.read(storageServiceProvider);
      final storage = await storageAsync.value;

      if (storage != null) {
        // ✅ إزالة <String> لأن getData لا تستخدم Generic الآن
        await storage.saveData('test_box', 'test_key', 'Hello Phase 2!');
        final value = await storage.getData('test_box', 'test_key');

        setState(() {
          _storageStatus = '✅ Success!\nSaved and retrieved: "$value"';
        });
      } else {
        setState(() => _storageStatus = '❌ Failed - Storage not initialized');
      }
    } catch (e) {
      setState(() => _storageStatus = '❌ Error: $e');
    }
  }
}