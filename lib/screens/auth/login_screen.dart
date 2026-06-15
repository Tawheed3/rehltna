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
  final bool returnOnLogin;

  const LoginScreen({Key? key, this.returnOnLogin = false}) : super(key: key);

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


  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    // ✅ التحقق من صحة الحقول
    if (!_formKey.currentState!.validate()) return;

    // ✅ التحقق من البريد الإلكتروني
    final email = _emailController.text.trim();
    if (!_isValidEmail(email)) {
      _showError('البريد الإلكتروني غير صحيح\nمثال: example@domain.com');
      return;
    }

    // ✅ التحقق من كلمة المرور
    final password = _passwordController.text;
    if (password.length < 6) {
      _showError('كلمة المرور قصيرة جداً\nيجب أن تكون 6 أحرف على الأقل');
      return;
    }

    // ✅ محاولة تسجيل الدخول
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.login(email, password);

    if (success && mounted) {
      developer.log('[Login] Success', name: 'Response-output');

      // تحديث FCM في الخلفية
      _updateFcmTokenInBackground(authProvider);

      if (!mounted) return;
      _showSuccess('تم تسجيل الدخول بنجاح 🎉');
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return;
      if (widget.returnOnLogin) {
        Navigator.pop(context);
      } else {
        context.go(AppRoutes.home);
      }
    } else if (mounted && !success) {
      // ✅ رسالة خطأ من الباك إند
      _showError(authProvider.errorMessage ?? 'فشل تسجيل الدخول\nتأكد من البريد الإلكتروني وكلمة المرور');
    }
  }

  // ==================== دوال التحقق ====================

  bool _isValidEmail(String email) {
    return RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(email);
  }

  // ==================== دوال الرسائل ====================

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(message, style: const TextStyle(fontSize: 14))),
          ],
        ),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'حسناً',
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(message, style: const TextStyle(fontSize: 14))),
          ],
        ),
        backgroundColor: Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// ✅ تحديث FCM Token في الخلفية بدون انتظار
  void _updateFcmTokenInBackground(AuthProvider authProvider) async {
    try {
      final fcmToken = await _notificationService.getToken();
      if (fcmToken != null && fcmToken.isNotEmpty) {
        authProvider.updateFcmTokenInBackground(fcmToken);
      }
    } catch (e) {
      developer.log('[Login] FCM update error: $e', name: 'Response-output', level: 900);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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

              // أيقونة
              Center(
                child: Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.travel_explore, size: 60, color: AppColors.primary),
                ),
              ),
              const SizedBox(height: 24),

              // عنوان
              Text(
                'تسجيل الدخول',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              // نص ترحيبي
              Text(
                'مرحباً بعودتك! سجل دخولك للمتابعة',
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? Colors.white70 : Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // فورم تسجيل الدخول
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // ✅ حقل البريد الإلكتروني
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: 'البريد الإلكتروني',
                        hintText: 'example@email.com',
                        prefixIcon: Icon(Icons.email_outlined, color: AppColors.primary),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor: isDark ? Colors.grey.shade800 : Colors.white,
                      ),
                      style: TextStyle(color: isDark ? Colors.white : Colors.black),
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return 'الرجاء إدخال البريد الإلكتروني';
                        }
                        if (!_isValidEmail(v)) {
                          return 'بريد إلكتروني غير صالح (مثال: name@domain.com)';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // ✅ حقل كلمة المرور
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        labelText: 'كلمة المرور',
                        hintText: '********',
                        prefixIcon: Icon(Icons.lock_outline, color: AppColors.primary),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off : Icons.visibility,
                            color: isDark ? Colors.white54 : Colors.grey[600],
                          ),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor: isDark ? Colors.grey.shade800 : Colors.white,
                      ),
                      style: TextStyle(color: isDark ? Colors.white : Colors.black),
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return 'الرجاء إدخال كلمة المرور';
                        }
                        if (v.length < 6) {
                          return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),

                    // تذكرني + نسيت كلمة المرور
                    Row(
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: _rememberMe,
                              onChanged: (v) => setState(() => _rememberMe = v ?? false),
                              activeColor: AppColors.primary,
                              checkColor: Colors.white,
                            ),
                            Text(
                              'تذكرني',
                              style: TextStyle(
                                color: isDark ? Colors.white70 : Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
                          ),
                          child: Text(
                            'نسيت كلمة المرور؟',
                            style: TextStyle(color: AppColors.primary),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // ✅ زر تسجيل الدخول
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: authProvider.isLoading ? null : _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: authProvider.isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                          'تسجيل الدخول',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),

                    // ✅ رسالة خطأ من الباك إند
                    if (authProvider.errorMessage != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.red.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.error_outline, color: Colors.red),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                authProvider.errorMessage!,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // رابط إنشاء حساب
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'ليس لديك حساب؟ ',
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.grey[600],
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SignupScreen()),
                    ),
                    child: Text(
                      'إنشاء حساب جديد',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              // تصفح كضيف
              TextButton.icon(
                onPressed: () {
                  final auth = Provider.of<AuthProvider>(context, listen: false);
                  auth.continueAsGuest();
                  context.go(AppRoutes.home);
                },
                icon: Icon(Icons.person_outline, color: isDark ? Colors.white54 : Colors.grey[600]),
                label: Text(
                  'تصفح كضيف',
                  style: TextStyle(
                    color: isDark ? Colors.white54 : Colors.grey[600],
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}