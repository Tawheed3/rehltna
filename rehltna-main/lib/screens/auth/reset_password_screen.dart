import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../data/providers/auth_provider.dart';
import 'login_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;

  const ResetPasswordScreen({Key? key, required this.email}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isResetting = false;
  int _secondsRemaining = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _codeController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _canResend = false;
    _secondsRemaining = 60;
    Future.delayed(const Duration(seconds: 1), _tick);
  }

  void _tick() {
    if (!mounted) return;
    if (_secondsRemaining > 0) {
      setState(() => _secondsRemaining--);
      Future.delayed(const Duration(seconds: 1), _tick);
    } else {
      setState(() => _canResend = true);
    }
  }

  Future<void> _handleResetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isResetting = true);

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // ✅ نبعت الكود + الباسورد مرة واحدة
    final success = await authProvider.resetPassword(
      email: widget.email,
      code: _codeController.text.trim(),
      password: _passwordController.text,
      passwordConfirmation: _confirmPasswordController.text,
    );

    if (!mounted) return;
    setState(() => _isResetting = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم تغيير كلمة المرور بنجاح'), backgroundColor: Colors.green),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
            (route) => false,
      );
    }
  }

  Future<void> _handleResendCode() async {
    if (!_canResend) return;

    setState(() => _isResetting = true);

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.forgotPassword(widget.email);

    if (!mounted) return;
    setState(() => _isResetting = false);

    if (success) {
      _startTimer();
      _codeController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم إرسال كود جديد'), backgroundColor: Colors.green),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('إعادة تعيين كلمة المرور', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary, elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 18, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              Center(
                child: Container(
                  height: 100, width: 100,
                  decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), shape: BoxShape.circle),
                  child: const Icon(Icons.lock_reset, size: 50, color: AppColors.primary),
                ),
              ),
              const SizedBox(height: 24),
              Text('إعادة تعيين كلمة المرور', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black), textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(30)),
                child: Text(widget.email, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary), textAlign: TextAlign.center),
              ),
              const SizedBox(height: 40),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // كود التحقق
                    TextFormField(
                      controller: _codeController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      maxLength: 6,
                      decoration: InputDecoration(
                        labelText: 'كود التحقق',
                        hintText: 'أدخل الكود المكون من 6 أرقام',
                        prefixIcon: Icon(Icons.sms, color: AppColors.primary),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor: isDark ? Colors.grey.shade800 : Colors.white,
                        counterText: '',
                      ),
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 4, color: isDark ? Colors.white : Colors.black),
                      textAlign: TextAlign.center,
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'الرجاء إدخال الكود';
                        if (v.length != 6) return 'الكود يجب أن يكون 6 أرقام';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // كلمة المرور الجديدة
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: 'كلمة المرور الجديدة',
                        hintText: '********',
                        prefixIcon: Icon(Icons.lock_outline, color: AppColors.primary),
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor: isDark ? Colors.grey.shade800 : Colors.white,
                      ),
                      style: TextStyle(color: isDark ? Colors.white : Colors.black),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'الرجاء إدخال كلمة المرور';
                        if (v.length < 8) return '8 أحرف على الأقل';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // تأكيد كلمة المرور
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        labelText: 'تأكيد كلمة المرور',
                        hintText: '********',
                        prefixIcon: Icon(Icons.lock_outline, color: AppColors.primary),
                        suffixIcon: IconButton(
                          icon: Icon(_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                          onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                        ),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor: isDark ? Colors.grey.shade800 : Colors.white,
                      ),
                      style: TextStyle(color: isDark ? Colors.white : Colors.black),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'الرجاء تأكيد كلمة المرور';
                        if (v != _passwordController.text) return 'غير متطابقة';
                        return null;
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // إعادة إرسال الكود
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('لم تستلم الكود؟ ', style: TextStyle(color: isDark ? Colors.white54 : Colors.grey[600], fontSize: 14)),
                  _canResend
                      ? TextButton(onPressed: _handleResendCode, child: const Text('إعادة الإرسال', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)))
                      : Text('إعادة الإرسال بعد $_secondsRemaining ثانية', style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),

              const SizedBox(height: 24),

              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: (_isResetting || authProvider.isLoading) ? null : _handleResetPassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary, foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isResetting
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('تغيير كلمة المرور', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),

              if (authProvider.errorMessage != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                  child: Row(children: [
                    const Icon(Icons.error_outline, color: Colors.red),
                    const SizedBox(width: 8),
                    Expanded(child: Text(authProvider.errorMessage!, style: const TextStyle(color: Colors.red))),
                  ]),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}