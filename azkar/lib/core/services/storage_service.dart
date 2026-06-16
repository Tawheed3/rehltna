import 'package:hive_flutter/hive_flutter.dart';

class StorageService {
  static StorageService? _instance;
  final Map<String, Box> _boxes = {};

  StorageService._internal();

  static Future<StorageService> getInstance() async {
    if (_instance == null) {
      _instance = StorageService._internal();
      await _instance!._init();
    }
    return _instance!;
  }

  Future<void> _init() async {
    await Hive.initFlutter();
  }

  // فتح Box بدون تحديد نوع (ديناميكي)
  Future<Box> _getBox(String boxName) async {
    if (!_boxes.containsKey(boxName)) {
      final box = await Hive.openBox(boxName);
      _boxes[boxName] = box;
    }
    return _boxes[boxName]!;
  }

  // حفظ بيانات - أي نوع
  Future<void> saveData(String boxName, String key, dynamic value) async {
    try {
      final box = await _getBox(boxName);
      await box.put(key, value);
      print('✅ Saved to $boxName: $key = $value');
    } catch (e) {
      print('❌ Error saving data: $e');
    }
  }

  // جلب بيانات - أي نوع (بدون Generic)
  Future<dynamic> getData(String boxName, String key) async {
    try {
      final box = await _getBox(boxName);
      return box.get(key);
    } catch (e) {
      print('❌ Error getting data: $e');
      return null;
    }
  }

  // حذف بيانات
  Future<void> deleteData(String boxName, String key) async {
    try {
      final box = await _getBox(boxName);
      await box.delete(key);
      print('✅ Deleted from $boxName: $key');
    } catch (e) {
      print('❌ Error deleting data: $e');
    }
  }

  // مسح كل البيانات من Box
  Future<void> clearBox(String boxName) async {
    try {
      final box = await _getBox(boxName);
      await box.clear();
      print('✅ Cleared box: $boxName');
    } catch (e) {
      print('❌ Error clearing box: $e');
    }
  }

  // التحقق من وجود مفتاح
  Future<bool> containsKey(String boxName, String key) async {
    try {
      final box = await _getBox(boxName);
      return box.containsKey(key);
    } catch (e) {
      print('❌ Error checking key: $e');
      return false;
    }
  }

  // إغلاق Box (بدون isClosed)
  Future<void> closeBox(String boxName) async {
    try {
      final box = _boxes[boxName];
      if (box != null) {
        await box.close();
        _boxes.remove(boxName);
        print('✅ Closed box: $boxName');
      }
    } catch (e) {
      print('❌ Error closing box: $e');
    }
  }

  // حذف Box بالكامل
  Future<void> deleteBox(String boxName) async {
    try {
      await closeBox(boxName);
      await Hive.deleteBoxFromDisk(boxName);
      print('✅ Deleted box: $boxName');
    } catch (e) {
      print('❌ Error deleting box: $e');
    }
  }
}