import 'package:auth_app_fixed/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SettingsPage extends StatefulWidget {
  final Locale currentLocale;
  final Function(Locale) onLocaleChanged;

  const SettingsPage({
    super.key,
    required this.currentLocale,
    required this.onLocaleChanged,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _selectedLanguage = 'ar';
  bool _enableNotifications = true;

  @override
  void initState() {
    super.initState();
    _selectedLanguage = widget.currentLocale.languageCode;
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLanguage = prefs.getString('language') ?? 'ar';
      _enableNotifications = prefs.getBool('notifications') ?? true;
    });
  }

  Future<void> _saveLanguage(String language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', language);
    widget.onLocaleChanged(Locale(language));
    setState(() {
      _selectedLanguage = language;
    });
  }

  Future<void> _saveNotifications(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications', enabled);
  }

  Future<void> _logout(BuildContext context) async {
    final l10n = AppLocalizations.of(context);

    try {
      // 1. تسجيل الخروج من Google
      final googleSignIn = GoogleSignIn();
      await googleSignIn.signOut(); // أو disconnect()
      await googleSignIn.disconnect();

      // 2. تسجيل الخروج من Firebase
      await FirebaseAuth.instance.signOut();

      // 3. الانتقال لصفحة Login مع مسح كل صفحات الـ Stack
      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          "login",
              (Route<dynamic> route) => false,
        );
      }

      // 4. إظهار رسالة نجاح (اختياري)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n?.logout ?? 'Logged out successfully'),
          backgroundColor: Colors.green,
        ),
      );

    } catch (error) {
      print('Logout error: $error');
      // حتى لو حدث خطأ، حاول تسجيل الخروج
      try {
        await FirebaseAuth.instance.signOut();
        if (mounted) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            "login",
                (Route<dynamic> route) => false,
          );
        }
      } catch (e) {
        print('Fallback logout error: $e');
      }
    }
  }

  void _showLogoutDialog() {
    final l10n = AppLocalizations.of(context);

    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.bottomSlide,
      title: l10n?.logout ?? 'Logout',
      desc: l10n?.logoutConfirmation ?? 'Are you sure you want to logout?',
      btnCancelText: l10n?.cancel ?? 'Cancel',
      btnOkText: l10n?.logout ?? 'Logout',
      btnCancelOnPress: () {},
      btnOkOnPress: () => _logout(context),
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (l10n == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final isArabic = _selectedLanguage == 'ar';

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.settings),
          leading: IconButton(
            icon: Icon(isArabic ? Icons.arrow_forward : Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.language, color: Colors.blue, size: 24),
                        const SizedBox(width: 12),
                        Text(
                          l10n.language,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    RadioListTile(
                      title: Row(
                        children: [
                          const Icon(Icons.language, color: Colors.green),
                          const SizedBox(width: 8),
                          Text(l10n.arabic),
                        ],
                      ),
                      value: 'ar',
                      groupValue: _selectedLanguage,
                      onChanged: (value) => _saveLanguage(value!),
                    ),
                    RadioListTile(
                      title: Row(
                        children: [
                          const Icon(Icons.language, color: Colors.blue),
                          const SizedBox(width: 8),
                          Text(l10n.english),
                        ],
                      ),
                      value: 'en',
                      groupValue: _selectedLanguage,
                      onChanged: (value) => _saveLanguage(value!),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.notifications, color: Colors.orange, size: 24),
                        const SizedBox(width: 12),
                        Text(
                          l10n.notifications,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      title: Text(l10n.enableNotifications),
                      value: _enableNotifications,
                      onChanged: (value) {
                        setState(() => _enableNotifications = value);
                        _saveNotifications(value);
                      },
                      secondary: const Icon(Icons.notifications_active),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: _showLogoutDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.logout, color: Colors.white),
                label: Text(
                  l10n.logout,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}