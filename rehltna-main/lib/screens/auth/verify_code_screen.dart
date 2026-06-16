import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../data/providers/auth_provider.dart';

class VerifyCodeScreen extends StatefulWidget {
  final String email;
  const VerifyCodeScreen({Key? key, required this.email}) : super(key: key);

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  final List<TextEditingController> _codeControllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  bool _isVerifying = false;
  int _secondsRemaining = 60;
  bool _canResend = false;

  @override
  void initState() { super.initState(); _startTimer(); }

  @override
  void dispose() { for (var c in _codeControllers) c.dispose(); for (var n in _focusNodes) n.dispose(); super.dispose(); }

  void _startTimer() { _canResend = false; _secondsRemaining = 60; Future.delayed(const Duration(seconds: 1), _tick); }
  void _tick() { if (!mounted) return; if (_secondsRemaining > 0) { setState(() => _secondsRemaining--); Future.delayed(const Duration(seconds: 1), _tick); } else { setState(() => _canResend = true); } }

  String _getCode() => _codeControllers.map((c) => c.text).join();

  Future<void> _handleVerify() async { /* مش شغالة دلوقتي */ }
  Future<void> _handleResend() async {
    if (!_canResend) return; setState(() => _isVerifying = true);
    final ap = Provider.of<AuthProvider>(context, listen: false);
    if (await ap.forgotPassword(widget.email)) { _startTimer(); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم إرسال كود جديد'), backgroundColor: Colors.green)); }
    setState(() => _isVerifying = false);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text('كود التحقق', style: TextStyle(color: Colors.white)), backgroundColor: AppColors.primary, elevation: 0, leading: Container(margin: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle), child: IconButton(icon: const Icon(Icons.arrow_back_ios, size: 18, color: Colors.white), onPressed: () => Navigator.pop(context)))),
      body: SafeArea(child: SingleChildScrollView(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const SizedBox(height: 40),
        Center(child: Container(height: 100, width: 100, decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), shape: BoxShape.circle), child: const Icon(Icons.sms, size: 50, color: AppColors.primary))),
        const SizedBox(height: 24),
        Text('أدخل كود التحقق', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black), textAlign: TextAlign.center),
        const SizedBox(height: 8),
        Text('تم إرسال كود التحقق إلى', style: TextStyle(fontSize: 14, color: isDark ? Colors.white70 : Colors.grey[600]), textAlign: TextAlign.center),
        Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), margin: const EdgeInsets.only(top: 8), decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(30)), child: Text(widget.email, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary), textAlign: TextAlign.center)),
        const SizedBox(height: 40),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: List.generate(6, (i) => SizedBox(width: 50, height: 60, child: TextFormField(controller: _codeControllers[i], focusNode: _focusNodes[i], keyboardType: TextInputType.number, textAlign: TextAlign.center, maxLength: 1, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold), decoration: InputDecoration(counterText: '', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: isDark ? Colors.grey.shade800 : Colors.white), onChanged: (v) { if (v.isNotEmpty && i < 5) _focusNodes[i+1].requestFocus(); if (v.isEmpty && i > 0) _focusNodes[i-1].requestFocus(); })))),
        const SizedBox(height: 24),
        SizedBox(height: 50, child: ElevatedButton(onPressed: _isVerifying ? null : _handleVerify, style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: _isVerifying ? const CircularProgressIndicator(color: Colors.white) : const Text('تحقق', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)))),
        const SizedBox(height: 16),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text('لم تستلم الكود؟ ', style: TextStyle(color: isDark ? Colors.white54 : Colors.grey[600], fontSize: 14)), _canResend ? TextButton(onPressed: _handleResend, child: const Text('إعادة الإرسال', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold))) : Text('إعادة الإرسال بعد $_secondsRemaining ثانية', style: TextStyle(color: isDark ? Colors.white38 : Colors.grey[400], fontSize: 12))]),
      ]))),
    );
  }
}