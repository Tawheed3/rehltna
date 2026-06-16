import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'signup_page.dart';
import 'package:auth_app_fixed/homepage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  // معلومات التصحيح
  bool _showDebugInfo = false;
  String? _lastErrorCode;
  String? _lastErrorMessage;

  String _getAuthErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'بريد إلكتروني غير صالح';
      case 'user-disabled':
        return 'هذا الحساب موقوف';
      case 'network-request-failed':
        return 'تحقق من الاتصال بالإنترنت';
      case 'too-many-requests':
        return 'محاولات كثيرة جدًا، حاول لاحقًا';
      case 'wrong-password':
        return 'كلمة المرور غير صحيحة';
      case 'user-not-found':
        return 'المستخدم غير موجود';
      default:
        return 'حدث خطأ غير متوقع (${e.code})';
    }
  }

  Future<void> _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showMessage('يرجى ملء جميع الحقول', isError: true);
      return;
    }

    setState(() {
      _isLoading = true;
      _showDebugInfo = false;
      _lastErrorCode = null;
      _lastErrorMessage = null;
    });

    try {
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (userCredential.user!.emailVerified) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        _showMessage('يرجى تأكيد البريد الإلكتروني أولاً', isError: true);
      }

      _showMessage('تم تسجيل الدخول بنجاح!', isError: false);
    } on FirebaseAuthException catch (e) {
      setState(() {
        _lastErrorCode = e.code;
        _lastErrorMessage = e.message;
        _showDebugInfo = true;
      });
      _showMessage(_getAuthErrorMessage(e), isError: true);
    } catch (e) {
      _showMessage('حدث خطأ غير متوقع', isError: true);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    setState(() => _isLoading = true);

    try {

      // 1️⃣ اطلب من المستخدم يختار حساب Google

      final GoogleSignIn googleSignIn = GoogleSignIn(
        // إضافة scopes إذا لزم
        scopes: [
          'email',
          'profile',
        ],
      );

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        _showMessage('تم إلغاء تسجيل الدخول', isError: true);
        return;
      }

      // 2️⃣ جلب بيانات الدخول (idToken فقط)
      final googleAuth = await googleUser.authentication;

      if (googleAuth.idToken == null) {
        _showMessage('حدث خطأ: لا يمكن الحصول على ID Token', isError: true);
        return;
      }

      // 3️⃣ إنشاء Credential
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        // accessToken: googleAuth.accessToken,  -> مش ضروري في النسخة الجديدة
      );

      // 4️⃣ تسجيل الدخول في Firebase
      UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);

      if (userCredential.user != null) {
        Navigator.pushReplacementNamed(context, "homepage");
      }

      _showMessage('✅ تسجيل الدخول ناجح: ${userCredential.user?.email}', isError: false);

    } catch (e) {
      _showMessage('❌ خطأ في تسجيل الدخول بـ Google: $e', isError: true);
    } finally {
      setState(() => _isLoading = false);
    }
  }


  void _showMessage(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showResetPasswordDialog() {
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text('إعادة تعيين كلمة المرور'),
          content: TextField(
            controller: emailController,
            decoration: const InputDecoration(
              labelText: 'البريد الإلكتروني',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.sendPasswordResetEmail(
                    email: emailController.text.trim(),
                  );
                  Navigator.pop(context);
                  _showMessage('تم إرسال رابط إعادة التعيين', isError: false);
                } catch (e) {
                  _showMessage('حدث خطأ في الإرسال', isError: true);
                }
              },
              child: const Text('إرسال'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 50),

                // شعار
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.lock_person,
                    size: 60,
                    color: Colors.blue,
                  ),
                ),

                const SizedBox(height: 30),

                const Text(
                  'تسجيل الدخول',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),

                const SizedBox(height: 30),

                // البريد الإلكتروني
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'البريد الإلكتروني',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 20),

                // كلمة المرور
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'كلمة المرور',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                    ),
                    border: const OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 30),

                // زر تسجيل الدخول
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: _isLoading == true
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                      'تسجيل الدخول',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // زر Google Sign-In
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: _isLoading == true ? null : () => signInWithGoogle(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Colors.grey),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),

                    label: const Text(
                      'تسجيل الدخول بـ Google',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // روابط
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignUpScreen(),
                      ),
                    );
                  },
                  child: const Text('إنشاء حساب جديد'),
                ),

                TextButton(
                  onPressed: _showResetPasswordDialog,
                  child: const Text('نسيت كلمة المرور؟'),
                ),

                // معلومات التصحيح
                if (_showDebugInfo && _lastErrorCode != null) ...[
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.orange.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.bug_report, size: 18, color: Colors.orange),
                            SizedBox(width: 8),
                            Text(
                              'معلومات الخطأ للمطور:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text('الكود: $_lastErrorCode'),
                        if (_lastErrorMessage != null)
                          Text('الرسالة: $_lastErrorMessage'),
                        TextButton(
                          onPressed: () => setState(() => _showDebugInfo = false),
                          child: const Text('إخفاء المعلومات'),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}




