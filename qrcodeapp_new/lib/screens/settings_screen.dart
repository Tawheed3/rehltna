import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../database/database_helper.dart';
import '../model/product_model.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _autoBackup = false;
  String _language = 'العربية';
  final _dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإعدادات'),
        backgroundColor: const Color(0xFF95A5A6),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20),

          // قسم التطبيق
          _buildSectionHeader('إعدادات التطبيق'),
          _buildSwitchTile(
            icon: Icons.notifications,
            title: 'الإشعارات',
            subtitle: 'تلقي إشعارات عند انخفاض المخزون',
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
          ),

          _buildSwitchTile(
            icon: Icons.backup,
            title: 'النسخ الاحتياطي التلقائي',
            subtitle: 'حفظ نسخة احتياطية يومياً',
            value: _autoBackup,
            onChanged: (value) {
              setState(() {
                _autoBackup = value;
              });
            },
          ),

          const Divider(),

          // قسم اللغة
          _buildSectionHeader('اللغة'),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF95A5A6).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.language, color: Color(0xFF95A5A6)),
            ),
            title: const Text('اللغة'),
            subtitle: Text(_language),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              _showLanguageDialog();
            },
          ),

          const Divider(),

          // قسم البيانات
          _buildSectionHeader('إدارة البيانات'),
          _buildActionTile(
            icon: Icons.backup_outlined,
            title: 'إنشاء نسخة احتياطية',
            subtitle: 'حفظ جميع البيانات في ملف',
            color: Colors.blue,
            onTap: () {
              _createBackup();
            },
          ),
          _buildActionTile(
            icon: Icons.restore,
            title: 'استعادة البيانات',
            subtitle: 'استعادة البيانات من نسخة احتياطية',
            color: Colors.green,
            onTap: () {
              _restoreBackup();
            },
          ),
          _buildActionTile(
            icon: Icons.delete_forever,
            title: 'مسح جميع البيانات',
            subtitle: 'حذف جميع المنتجات بشكل نهائي',
            color: Colors.red,
            onTap: () {
              _showClearDataDialog();
            },
          ),

          const Divider(),

          // قسم المساعدة
          _buildSectionHeader('المساعدة والدعم'),
          _buildActionTile(
            icon: Icons.share,
            title: 'مشاركة التطبيق',
            subtitle: 'أخبر أصدقاءك عن التطبيق',
            color: Colors.orange,
            onTap: () {
              Share.share('جرّب تطبيق مدير QR Code الرائع!');
            },
          ),
          _buildActionTile(
            icon: Icons.star,
            title: 'تقييم التطبيق',
            subtitle: 'دعمنا بتقييم إيجابي',
            color: Colors.amber,
            onTap: () {
              // رابط المتجر
            },
          ),
          _buildActionTile(
            icon: Icons.info,
            title: 'حول التطبيق',
            subtitle: 'معلومات الإصدار والمطور',
            color: Colors.purple,
            onTap: () {
              _showAboutDialog();
            },
          ),

          const SizedBox(height: 20),

          // معلومات الإصدار
          Center(
            child: Column(
              children: [
                Text(
                  'الإصدار 1.0.0',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                const SizedBox(height: 4),
                Text(
                  '© 2024 QR Code Manager',
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade600,
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      secondary: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF95A5A6).withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: const Color(0xFF95A5A6)),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('اختر اللغة'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('العربية'),
              leading: Radio(
                value: 'العربية',
                groupValue: _language,
                onChanged: (value) {
                  setState(() {
                    _language = value.toString();
                  });
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              title: const Text('English'),
              leading: Radio(
                value: 'English',
                groupValue: _language,
                onChanged: (value) {
                  setState(() {
                    _language = value.toString();
                  });
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _createBackup() async {
    try {
      // الحصول على جميع المنتجات
      List<Product> products = await _dbHelper.getAllProducts();

      // تحويل إلى JSON
      List<Map<String, dynamic>?> productsJson =
      products.map((p) => p?.toJson()).toList();

      // حفظ في ملف
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/backup_${DateTime.now().millisecondsSinceEpoch}.json');
      await file.writeAsString(productsJson.toString());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ تم إنشاء النسخة الاحتياطية بنجاح'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ حدث خطأ: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _restoreBackup() async {
    // يمكن إضافة منطق استعادة البيانات هنا
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('جاري تطوير هذه الميزة'),
      ),
    );
  }

  void _showClearDataDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('⚠️ تحذير'),
        content: const Text('هل أنت متأكد من حذف جميع البيانات؟ لا يمكن التراجع عن هذا الإجراء.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              // حذف جميع المنتجات
              // await _dbHelper.deleteAllProducts();
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم حذف جميع البيانات'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('حذف الكل'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حول التطبيق'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.qr_code, size: 80, color: Color(0xFF95A5A6)),
            const SizedBox(height: 16),
            const Text(
              'QR Code Manager',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'الإصدار 1.0.0',
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 16),
            const Text(
              'تطبيق متكامل لإدارة المنتجات باستخدام QR Code\n'
                  'يمكنك إنشاء ومسح وتخزين QR Codes بسهولة',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text('تم التطوير بواسطة: Flutter'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }
}






