import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:in_app_review/in_app_review.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/routes/app_routes.dart';
import '../../data/models/settings_model.dart';
import '../../data/models/user_model.dart';
import '../../data/providers/auth_provider.dart';
import '../../data/providers/settings_provider.dart';
import '../../data/providers/user_provider.dart';
import '../../data/providers/custom_pages_provider.dart';
import '../../data/services/notification_service.dart';
import '../../data/services/settings_service.dart';
import 'widgets/settings_tile.dart';
import 'custom_page_screen.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';


class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  final NotificationService _notificationService = NotificationService();
  File? _savedImage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSavedImage(); // ✅ تحميل الصورة المحفوظة
      final sp = Provider.of<SettingsProvider>(context, listen: false);
      if (sp.settings == null) sp.fetchSettings();
      final ap = Provider.of<AuthProvider>(context, listen: false);
      final up = Provider.of<UserProvider>(context, listen: false);
      if (ap.isLoggedIn) up.fetchProfile();
      final cpp = context.read<CustomPagesProvider>();
      cpp.fetchCustomPages();
    });
  }

  Future<void> _loadSavedImage() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString('user_avatar');
    if (imagePath != null && imagePath.isNotEmpty) {
      final file = File(imagePath);
      if (await file.exists()) {
        setState(() {
          _savedImage = file;
        });
      }
    }
  }

  Future<void> _toggleNotifications(bool value) async {
    setState(() => _notificationsEnabled = value);
    if (value) {
      await _notificationService.subscribeToTopic('all');
    } else {
      await _notificationService.unsubscribeFromTopic('all');
    }
  }

  Future<void> _launchURL(String url) async {
    if (url.isEmpty) return;
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _launchPhone(String phone) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phone.replaceAll(RegExp(r'[^\d+]'), ''));
    if (await canLaunchUrl(phoneUri)) await launchUrl(phoneUri);
  }

  Future<void> _launchWhatsApp(String phone) async {
    final Uri whatsappUri = Uri.parse('https://wa.me/${phone.replaceAll(RegExp(r'[^\d]'), '')}');
    if (await canLaunchUrl(whatsappUri)) await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
  }

  Future<void> _rateApp() async {
    final InAppReview inAppReview = InAppReview.instance;
    if (await inAppReview.isAvailable()) {
      inAppReview.requestReview();
    } else {
      await _launchURL('https://play.google.com/store/apps/details?id=com.example.rehlaty');
    }
  }

  void _showLogoutDialog(AuthProvider ap) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تسجيل الخروج'),
        content: const Text('هل أنت متأكد؟'),
        backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await ap.signOut();
              if (mounted) context.go(AppRoutes.login);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text('تسجيل الخروج'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settingsService = Provider.of<SettingsService>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final isDark = settingsService.isDarkMode;
    final lang = settingsService.languageCode;
    final localizations = AppLocalizations.of(context);
    final user = userProvider.user ?? authProvider.currentUser;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF8FAFC),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 200,
              floating: false,
              pinned: true,
              backgroundColor: AppColors.primary,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  localizations.translate('settings'),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                ),
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.primary, AppColors.secondary],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                    Positioned(
                      top: -50,
                      right: -50,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.1)),
                      ),
                    ),
                    Positioned(
                      bottom: -80,
                      left: -80,
                      child: Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.1)),
                      ),
                    ),
                  ],
                ),
              ),
              leading: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios, size: 18, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildProfileSection(user, isDark, authProvider),
                  const SizedBox(height: 24),
                  _buildSectionTitle(localizations.translate('appearance_language'), isDark),
                  SettingsTile(
                    icon: Icons.dark_mode_outlined,
                    title: localizations.translate('dark_mode'),
                    trailing: Switch(
                      value: isDark,
                      onChanged: (v) => settingsService.toggleDarkMode(v),
                      activeColor: AppColors.primary,
                    ),
                    onTap: () => settingsService.toggleDarkMode(!isDark),
                  ),
                  SettingsTile(
                    icon: Icons.language_outlined,
                    title: localizations.translate('language'),
                    subtitle: lang == 'ar' ? 'العربية' : 'English',
                    onTap: () => _showLanguageDialog(settingsService, localizations),
                  ),
                  const SizedBox(height: 16),
                  Divider(color: isDark ? Colors.white24 : Colors.grey.shade300),
                  const SizedBox(height: 16),
                  _buildSectionTitle(localizations.translate('notifications'), isDark),
                  SettingsTile(
                    icon: Icons.notifications_outlined,
                    title: localizations.translate('notifications'),
                    trailing: Switch(
                      value: _notificationsEnabled,
                      onChanged: _toggleNotifications,
                      activeColor: AppColors.primary,
                    ),
                    onTap: () => _toggleNotifications(!_notificationsEnabled),
                  ),
                  const SizedBox(height: 16),
                  Divider(color: isDark ? Colors.white24 : Colors.grey.shade300),
                  const SizedBox(height: 16),
                  _buildSectionTitle('عن التطبيق', isDark),
                  _buildContactInfo(settingsProvider.settings, isDark, lang),
                  const SizedBox(height: 16),

                  // ✅ الشروط والأحكام + سياسة الخصوصية
                  Consumer<CustomPagesProvider>(
                    builder: (context, cpp, child) {
                      if (cpp.pages.isEmpty) return const SizedBox.shrink();
                      return Column(
                        children: [
                          _buildPageTile(
                            icon: Icons.description_outlined,
                            title: lang == 'ar' ? 'الشروط والأحكام' : 'Terms & Conditions',
                            isDark: isDark,
                            onTap: () {
                              final page = cpp.getTermsAndConditions();
                              if (page != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => CustomPageScreen(page: page)),
                                );
                              }
                            },
                          ),
                          const SizedBox(height: 8),
                          _buildPageTile(
                            icon: Icons.privacy_tip_outlined,
                            title: lang == 'ar' ? 'سياسة الخصوصية' : 'Privacy Policy',
                            isDark: isDark,
                            onTap: () {
                              final page = cpp.getPrivacyPolicy();
                              if (page != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => CustomPageScreen(page: page)),
                                );
                              }
                            },
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 16),
                  _buildSocialLinks(settingsProvider.settings, isDark),
                  const SizedBox(height: 16),
                  _buildActionButtons(localizations, isDark),
                  const SizedBox(height: 24),
                  _buildStats(isDark),
                  const SizedBox(height: 24),
                  if (user != null) _buildLogoutButton(authProvider, localizations),
                  const SizedBox(height: 24),
                  Center(
                    child: Text(
                      localizations.translate('version'),
                      style: TextStyle(fontSize: 12, color: isDark ? Colors.white38 : Colors.grey[400]),
                    ),
                  ),
                  const SizedBox(height: 24),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== بطاقة الصفحة ====================

  Widget _buildPageTile({
    required IconData icon,
    required String title,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.primary, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: isDark ? Colors.white38 : Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  // ==================== باقي الدوال ====================

  Widget _buildProfileSection(UserModel? user, bool isDark, AuthProvider ap) {
    return user == null
        ? Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            isDark ? const Color(0xFF1E1E1E) : Colors.white,
            isDark ? const Color(0xFF2D2D2D) : Colors.grey.shade50,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person_outline,
              size: 60,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'أنت الآن زائر',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'سجل دخول للاستفادة من جميع المميزات',
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white70 : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.go(AppRoutes.login),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 30),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text('تسجيل الدخول'),
          ),
        ],
      ),
    )
        : Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            isDark ? const Color(0xFF1E1E1E) : Colors.white,
            isDark ? const Color(0xFF2D2D2D) : Colors.grey.shade50,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.secondary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: ClipOval(
                  child: _buildSettingsAvatar(user), // ✅ دالة جديدة
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: user.isVerified ? Colors.green : Colors.orange,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Icon(
                    user.isVerified ? Icons.check : Icons.access_time,
                    color: Colors.white,
                    size: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.email,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white70 : Colors.grey[600],
                  ),
                ),
                if (user.phone != null && user.phone!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    '📞 ${user.phone}',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white60 : Colors.grey[500],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
  /// بناء صورة الآڤاتار للإعدادات - الصورة المحفوظة أولاً
  Widget _buildSettingsAvatar(UserModel user) {
    // ✅ الصورة المحفوظة محلياً أولاً
    if (_savedImage != null) {
      return Image.file(
        _savedImage!,
        width: 80,
        height: 80,
        fit: BoxFit.cover,
      );
    }

    // ✅ صورة الباك إند ثانياً
    if (user.avatarUrl != null && user.avatarUrl!.isNotEmpty) {
      return Image.network(
        user.avatarUrl!,
        width: 80,
        height: 80,
        fit: BoxFit.cover,
        errorBuilder: (c, e, s) => Center(
          child: Text(
            user.initials,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    // ✅ الأحرف الأولى
    return Center(
      child: Text(
        user.initials,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  Widget _buildContactInfo(SettingsModel? s, bool isDark, String lang) {
    if (s == null) return const SizedBox();
    final p = s.sitePhone.replaceAll(RegExp(r'[^\d+]'), '');
    final w = s.whatsappNumber;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [isDark ? const Color(0xFF1E1E1E) : Colors.white, isDark ? const Color(0xFF2D2D2D) : Colors.grey.shade50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(4)),
              ),
              const SizedBox(width: 8),
              Text('معلومات الاتصال', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
            ],
          ),
          const SizedBox(height: 16),
          if (s.getAddress(lang).isNotEmpty) _buildContactItem(Icons.location_on, 'العنوان', s.getAddress(lang), isDark),
          if (s.siteEmail.isNotEmpty) _buildContactItem(Icons.email, 'البريد الإلكتروني', s.siteEmail, isDark, () => _launchURL('mailto:${s.siteEmail}')),
          if (s.sitePhone.isNotEmpty) _buildContactItem(Icons.phone, 'الهاتف', s.sitePhone, isDark, () => _launchPhone(p)),
          if (w.isNotEmpty) _buildContactItem(Icons.chat, 'واتساب', s.sitePhone, isDark, () => _launchWhatsApp(w)),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String title, String value, bool isDark, [VoidCallback? onTap]) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(icon, color: AppColors.primary, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 12, color: isDark ? Colors.white60 : Colors.grey[600])),
                  const SizedBox(height: 2),
                  Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: isDark ? Colors.white : Colors.black87)),
                ],
              ),
            ),
            if (onTap != null) Icon(Icons.arrow_forward_ios, size: 14, color: isDark ? Colors.white38 : Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialLinks(SettingsModel? s, bool isDark) {
    if (s == null) return const SizedBox();
    final links = <Map<String, dynamic>>[];
    if (s.facebook.isNotEmpty) links.add({'icon': Icons.facebook, 'color': const Color(0xFF1877F2), 'url': s.facebook.first, 'label': 'فيسبوك'});
    if (s.instagram.isNotEmpty) links.add({'icon': Icons.photo_camera, 'color': const Color(0xFFE4405F), 'url': s.instagram.first, 'label': 'انستغرام'});
    if (s.twitter.isNotEmpty) links.add({'icon': Icons.alternate_email, 'color': const Color(0xFF1DA1F2), 'url': s.twitter.first, 'label': 'تويتر'});
    if (s.youtube.isNotEmpty) links.add({'icon': Icons.play_circle_fill, 'color': const Color(0xFFFF0000), 'url': s.youtube.first, 'label': 'يوتيوب'});
    if (s.whatsappNumber.isNotEmpty) links.add({'icon': Icons.chat, 'color': const Color(0xFF25D366), 'url': 'https://wa.me/${s.whatsappNumber}', 'label': 'واتساب'});
    if (links.isEmpty) return const SizedBox();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [isDark ? const Color(0xFF1E1E1E) : Colors.white, isDark ? const Color(0xFF2D2D2D) : Colors.grey.shade50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 4, height: 24, decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(4))),
              const SizedBox(width: 8),
              Text('تواصل معنا', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: links.map((l) {
              return InkWell(
                onTap: () => _launchURL(l['url']),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: l['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: l['color'].withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(l['icon'], color: l['color'], size: 16),
                      const SizedBox(width: 4),
                      Text(l['label'], style: TextStyle(fontSize: 12, color: l['color'], fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(AppLocalizations loc, bool isDark) {
    return Column(
      children: [
        SettingsTile(icon: Icons.share_outlined, title: loc.translate('share_app'), onTap: _shareApp),
        SettingsTile(icon: Icons.star_outline, title: loc.translate('rate_app'), onTap: _rateApp),
        SettingsTile(icon: Icons.feedback_outlined, title: loc.translate('feedback'), onTap: () => _showFeedbackDialog(loc)),
      ],
    );
  }

  Widget _buildStats(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [isDark ? const Color(0xFF1E1E1E) : Colors.white, isDark ? const Color(0xFF2D2D2D) : Colors.grey.shade50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _statItem(Icons.flight, 'رحلات', '4'),
          _statItem(Icons.people, 'أقسام', '5'),
          _statItem(Icons.star, 'تقييم', '4.8'),
        ],
      ),
    );
  }

  Widget _statItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 24),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildLogoutButton(AuthProvider ap, AppLocalizations loc) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _showLogoutDialog(ap),
        icon: const Icon(Icons.logout),
        label: Text(loc.translate('logout')),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Row(
        children: [
          Container(width: 4, height: 20, decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(4))),
          const SizedBox(width: 8),
          Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? Colors.white : AppColors.primary)),
        ],
      ),
    );
  }

  void _showLanguageDialog(SettingsService settings, AppLocalizations loc) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(loc.translate('language')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('العربية'),
              leading: settings.languageCode == 'ar' ? const Icon(Icons.check, color: AppColors.primary) : null,
              onTap: () async {
                await settings.changeLanguage('ar');
                if (ctx.mounted) Navigator.pop(ctx);
              },
            ),
            ListTile(
              title: const Text('English'),
              leading: settings.languageCode == 'en' ? const Icon(Icons.check, color: AppColors.primary) : null,
              onTap: () async {
                await settings.changeLanguage('en');
                if (ctx.mounted) Navigator.pop(ctx);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showFeedbackDialog(AppLocalizations loc) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(loc.translate('feedback')),
        content: TextField(
          maxLines: 5,
          decoration: InputDecoration(hintText: loc.translate('feedback_hint'), border: const OutlineInputBorder()),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(loc.translate('cancel'))),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(loc.translate('thank_you_feedback')), backgroundColor: Colors.green),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
            child: Text(loc.translate('save')),
          ),
        ],
      ),
    );
  }

  void _shareApp() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Share App'), backgroundColor: Colors.blue));
  }
}