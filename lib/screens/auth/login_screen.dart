import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/routes/app_routes.dart';
import '../../data/providers/auth_provider.dart';
import '../../data/services/notification_service.dart';
import 'signup_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;
  final NotificationService _notificationService = NotificationService();

  final List<Map<String, String>> _realUsers = [
    {'email': 'admin@rehlatna.com', 'password': 'Admin@2026', 'name': 'احمد', 'role': 'مدير النظام', 'color': 'red'},
  ];

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.login(_emailController.text, _passwordController.text);

    if (success && mounted) {
      developer.log('[Login] Success', name: 'Response-output');

      // ✅ تحديث FCM في الخلفية (لا ننتظر النتيجة)
      _updateFcmTokenInBackground(authProvider);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم تسجيل الدخول بنجاح'), backgroundColor: Colors.green, duration: Duration(seconds: 1))
      );
      await Future.delayed(const Duration(milliseconds: 300));
      if (mounted) context.go(AppRoutes.home);
    }
  }

  /// ✅ تحديث FCM Token في الخلفية بدون انتظار
  void _updateFcmTokenInBackground(AuthProvider authProvider) async {
    try {
      final fcmToken = await _notificationService.getToken();
      if (fcmToken != null && fcmToken.isNotEmpty) {
        // ✅ استخدام الدالة الجديدة التي لا تنتظر
        authProvider.updateFcmTokenInBackground(fcmToken);
      }
    } catch (e) {
      developer.log('[Login] FCM update error: $e', name: 'Response-output', level: 900);
    }
  }

  Color _getRoleColor(String colorName) {
    switch (colorName) {
      case 'red': return Colors.red;
      case 'blue': return Colors.blue;
      case 'green': return Colors.green;
      default: return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final localizations = AppLocalizations.of(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 50),
              Center(child: Container(height: 120, width: 120, decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), shape: BoxShape.circle), child: Icon(Icons.travel_explore, size: 60, color: AppColors.primary))),
              const SizedBox(height: 24),
              Text('تسجيل الدخول', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black), textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text('مرحباً بعودتك! سجل دخولك للمتابعة', style: TextStyle(fontSize: 16, color: isDark ? Colors.white70 : Colors.grey[600]), textAlign: TextAlign.center),
              const SizedBox(height: 40),
              Form(
                key: _formKey,
                child: Column(children: [
                  TextFormField(
                    controller: _emailController, keyboardType: TextInputType.emailAddress, textInputAction: TextInputAction.next,
                    decoration: InputDecoration(labelText: 'البريد الإلكتروني', hintText: 'example@email.com', prefixIcon: Icon(Icons.email_outlined, color: AppColors.primary), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: isDark ? Colors.grey.shade800 : Colors.white),
                    style: TextStyle(color: isDark ? Colors.white : Colors.black),
                    validator: (v) { if (v == null || v.isEmpty) return 'الرجاء إدخال البريد الإلكتروني'; if (!v.contains('@') || !v.contains('.')) return 'البريد الإلكتروني غير صالح'; return null; },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController, obscureText: _obscurePassword, textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      labelText: 'كلمة المرور', hintText: '********', prefixIcon: Icon(Icons.lock_outline, color: AppColors.primary),
                      suffixIcon: IconButton(icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: isDark ? Colors.white54 : Colors.grey[600]), onPressed: () => setState(() => _obscurePassword = !_obscurePassword)),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: isDark ? Colors.grey.shade800 : Colors.white,
                    ),
                    style: TextStyle(color: isDark ? Colors.white : Colors.black),
                    validator: (v) { if (v == null || v.isEmpty) return 'الرجاء إدخال كلمة المرور'; if (v.length < 6) return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل'; return null; },
                  ),
                  const SizedBox(height: 8),
                  Row(children: [
                    Row(children: [Checkbox(value: _rememberMe, onChanged: (v) => setState(() => _rememberMe = v ?? false), activeColor: AppColors.primary, checkColor: Colors.white), Text('تذكرني', style: TextStyle(color: isDark ? Colors.white70 : Colors.grey[700]))]),
                    const Spacer(),
                    TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ForgotPasswordScreen())), child: Text('نسيت كلمة المرور؟', style: TextStyle(color: AppColors.primary))),
                  ]),
                  const SizedBox(height: 16),
                  SizedBox(height: 50, child: ElevatedButton(onPressed: authProvider.isLoading ? null : _handleLogin, style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: authProvider.isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('تسجيل الدخول', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)))),
                  if (authProvider.errorMessage != null) ...[
                    const SizedBox(height: 16),
                    Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.red.withOpacity(0.3))), child: Row(children: [Icon(Icons.error_outline, color: Colors.red), const SizedBox(width: 8), Expanded(child: Text(authProvider.errorMessage!, style: const TextStyle(color: Colors.red)))]))
                  ],
                ]),
              ),
              const SizedBox(height: 30),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text('ليس لديك حساب؟ ', style: TextStyle(color: isDark ? Colors.white70 : Colors.grey[600])), TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SignupScreen())), child: Text('إنشاء حساب جديد', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)))]),
              const SizedBox(height: 20),
              _buildUserAccount(context, isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserAccount(BuildContext context, bool isDark) {
    final user = _realUsers.first;
    return Container(
      padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: isDark ? Colors.grey.shade800 : Colors.grey.shade100, borderRadius: BorderRadius.circular(16), border: Border.all(color: _getRoleColor(user['color']!).withOpacity(0.3))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: _getRoleColor(user['color']!).withOpacity(0.1), shape: BoxShape.circle), child: Icon(Icons.admin_panel_settings, color: _getRoleColor(user['color']!), size: 16)), const SizedBox(width: 8), Text('حساب تجريبي', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black))]),
        const SizedBox(height: 12),
        InkWell(
          onTap: () { _emailController.text = user['email']!; _passwordController.text = user['password']!; ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تم تعبئة بيانات ${user['name']}'), backgroundColor: Colors.green, duration: const Duration(seconds: 1))); },
          child: Container(
            padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: _getRoleColor(user['color']!).withOpacity(0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: _getRoleColor(user['color']!).withOpacity(0.3))),
            child: Row(children: [
              Container(width: 10, height: 10, decoration: BoxDecoration(color: _getRoleColor(user['color']!), shape: BoxShape.circle)), const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('البريد الإلكتروني:', style: TextStyle(fontSize: 11, color: isDark ? Colors.white54 : Colors.grey[600])),
                Text(user['email']!, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)),
                const SizedBox(height: 4),
                Text('الدور:', style: TextStyle(fontSize: 11, color: isDark ? Colors.white54 : Colors.grey[600])),
                Text(user['role']!, style: TextStyle(fontSize: 12, color: _getRoleColor(user['color']!), fontWeight: FontWeight.bold)),
              ])),
              Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), decoration: BoxDecoration(color: _getRoleColor(user['color']!), borderRadius: BorderRadius.circular(30)), child: const Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.login, color: Colors.white, size: 14), SizedBox(width: 4), Text('تعبئة البيانات', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold))])),
            ]),
          ),
        ),
      ]),
    );
  }
}