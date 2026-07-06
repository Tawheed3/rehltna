import 'package:cached_network_image/cached_network_image.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:in_app_review/in_app_review.dart';
import '../../core/constants/app_colors.dart';
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
  bool _contactInfoExpanded = false;
  final NotificationService _notificationService = NotificationService();
  File? _savedImage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSavedImage();
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
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _launchPhone(String phone) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phone.replaceAll(RegExp(r'[^\d+]'), ''));
    if (await canLaunchUrl(phoneUri)) await launchUrl(phoneUri);
  }

  Future<void> _launchWhatsApp(String phone) async {
    final Uri whatsappUri = Uri.parse('https://wa.me/${phone.replaceAll(RegExp(r'[^\d]'), '')}');
    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _rateApp() async {
    final InAppReview inAppReview = InAppReview.instance;
    if (await inAppReview.isAvailable()) {
      inAppReview.requestReview();
    } else {
      final url = Platform.isIOS
          ? 'https://apps.apple.sa/app/id6746780603'
          : 'https://play.google.sa/store/apps/details?id=sa.rehltna.app';
      await _launchURL(url);
    }
  }

  void _showLogoutDialog(AuthProvider ap) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تسجيل الخروج'),
        content: const Text('هل أنت متأكد من تسجيل الخروج؟'),
        backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await ap.signOut();
              if (mounted) context.go(AppRoutes.login);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
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
    final user = userProvider.user ?? authProvider.currentUser;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF8FAFC),

        body: CustomScrollView(
          slivers: [
            // رأس الصفحة
            SliverAppBar(
              expandedHeight: 200,
              floating: false,
              pinned: true,
              backgroundColor: AppColors.primary,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text(
                  'الإعدادات',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
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
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -80,
                      left: -80,
                      child: Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              leading: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios, size: 18, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),

            // محتوى الإعدادات
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // ملف المستخدم
                  _buildProfileSection(user, isDark, authProvider),
                  const SizedBox(height: 24),

                  // قسم المظهر
                  _buildSectionTitle('المظهر', isDark),
                  SettingsTile(
                    icon: Icons.dark_mode_outlined,
                    title: 'الوضع المظلم',
                    trailing: Switch(
                      value: isDark,
                      onChanged: (v) => settingsService.toggleDarkMode(v),
                      activeColor: AppColors.primary,
                    ),
                    onTap: () => settingsService.toggleDarkMode(!isDark),
                  ),
                  const SizedBox(height: 16),
                  Divider(color: isDark ? Colors.white24 : Colors.grey.shade300),
                  const SizedBox(height: 16),

                  // قسم الإشعارات
                  _buildSectionTitle('الإشعارات', isDark),
                  SettingsTile(
                    icon: Icons.notifications_outlined,
                    title: 'الإشعارات',
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

                  // قسم عن التطبيق
                  _buildSectionTitle('عن التطبيق', isDark),
                  _buildContactInfo(settingsProvider.settings, isDark),
                  const SizedBox(height: 16),

                  // الشروط والأحكام وسياسة الخصوصية
                  Consumer<CustomPagesProvider>(
                    builder: (context, cpp, child) {
                      if (cpp.pages.isEmpty) return const SizedBox.shrink();
                      return Column(
                        children: [
                          _buildPageTile(
                            icon: Icons.description_outlined,
                            title: 'الشروط والأحكام',
                            isDark: isDark,
                            onTap: () {
                              final page = cpp.getTermsAndConditions();
                              if (page != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CustomPageScreen(page: page),
                                  ),
                                );
                              }
                            },
                          ),
                          const SizedBox(height: 8),
                          _buildPageTile(
                            icon: Icons.privacy_tip_outlined,
                            title: 'سياسة الخصوصية',
                            isDark: isDark,
                            onTap: () {
                              final page = cpp.getPrivacyPolicy();
                              if (page != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CustomPageScreen(page: page),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  // روابط التواصل الاجتماعي
                  _buildSocialLinks(settingsProvider.settings, isDark),
                  const SizedBox(height: 16),

                  // أزرار الإجراءات
                  _buildActionButtons(isDark),
                  const SizedBox(height: 24),

                  // زر تسجيل الخروج
                  if (authProvider.isLoggedIn) _buildLogoutButton(authProvider),
                  if (authProvider.isLoggedIn) const SizedBox(height: 12),

                  // زر حذف الحساب
                  if (authProvider.isLoggedIn) _buildDeleteAccountButton(authProvider),
                  const SizedBox(height: 24),

                  // إصدار التطبيق
                  Center(
                    child: Text(
                      'الإصدار 1.0.0',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white38 : Colors.grey[400],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ]),
              ),
            ),
          ],
        ),

    );
  }

  // ==================== قسم ملف المستخدم ====================
  Widget _buildProfileSection(UserModel? user, bool isDark, AuthProvider ap) {
    // حالة الزائر (غير مسجل دخول)
    if (user == null) {
      return Container(
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
      );
    }

    // حالة المستخدم (مسجل دخول)
    return Container(
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
                  child: _buildSettingsAvatar(user),
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

  // ==================== صورة الآفاتار ====================
  Widget _buildSettingsAvatar(UserModel user) {
    // الصورة المحفوظة محلياً
    if (_savedImage != null) {
      return Image.file(
        _savedImage!,
        width: 80,
        height: 80,
        fit: BoxFit.cover,
      );
    }

    // صورة من السيرفر
    if (user.avatarUrl != null && user.avatarUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: user.avatarUrl!,
        width: 80,
        height: 80,
        fit: BoxFit.cover,
        errorWidget: (c, url, e) => Center(
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

    // الأحرف الأولى
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
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: isDark ? Colors.white38 : Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==================== معلومات الاتصال ====================
  Widget _buildContactInfo(SettingsModel? s, bool isDark) {
    if (s == null) return const SizedBox.shrink();

    final phone = s.sitePhone.replaceAll(RegExp(r'[^\d+]'), '');
    final whatsapp = s.whatsappNumber;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            isDark ? const Color(0xFF1E1E1E) : Colors.white,
            isDark ? const Color(0xFF2D2D2D) : Colors.grey.shade50,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _contactInfoExpanded = !_contactInfoExpanded),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'معلومات الاتصال',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const Spacer(),
                  AnimatedRotation(
                    turns: _contactInfoExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 250),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: isDark ? Colors.white54 : Colors.black45,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 250),
            crossFadeState: _contactInfoExpanded
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: [
                  if (s.getAddress('ar').isNotEmpty)
                    _buildContactItem(Icons.location_on, 'العنوان', s.getAddress('ar'), isDark),
                  if (s.siteEmail.isNotEmpty)
                    _buildContactItem(Icons.email, 'البريد الإلكتروني', s.siteEmail, isDark,
                        () => _launchURL('mailto:${s.siteEmail}')),
                  if (s.sitePhone.isNotEmpty)
                    _buildContactItem(Icons.phone, 'الهاتف', s.sitePhone, isDark,
                        () => _launchPhone(phone)),
                  if (whatsapp.isNotEmpty)
                    _buildContactItem(Icons.chat, 'واتساب', s.sitePhone, isDark,
                        () => _launchWhatsApp(whatsapp)),
                ],
              ),
            ),
            secondChild: const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  // ==================== عنصر الاتصال ====================
  Widget _buildContactItem(
      IconData icon,
      String title,
      String value,
      bool isDark, [
        VoidCallback? onTap,
      ]) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.primary, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white60 : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: isDark ? Colors.white38 : Colors.grey[400],
              ),
          ],
        ),
      ),
    );
  }

  // ==================== روابط التواصل الاجتماعي ====================
  Widget _buildSocialLinks(SettingsModel? s, bool isDark) {
    if (s == null) return const SizedBox.shrink();

    final links = <Map<String, dynamic>>[];

    if (s.facebook.isNotEmpty) {
      links.add({
        'image': 'assets/social/facebook.png',
        'color': const Color(0xFF1877F2),
        'url': s.facebook.first,
        'label': 'فيسبوك',
      });
    }

    if (s.instagram.isNotEmpty) {
      links.add({
        'image': 'assets/social/instagram.jpeg',
        'color': const Color(0xFFE4405F),
        'url': s.instagram.first,
        'label': 'انستغرام',
      });
    }

    if (s.twitter.isNotEmpty) {
      links.add({
        'image': 'assets/social/twitter.png',
        'color': const Color(0xFF000000),
        'url': s.twitter.first,
        'label': 'تويتر',
      });
    }

    if (s.youtube.isNotEmpty) {
      links.add({
        'image': 'assets/social/youtube.png',
        'color': const Color(0xFFFF0000),
        'url': s.youtube.first,
        'label': 'يوتيوب',
      });
    }

    if (s.tiktok.isNotEmpty) {
      links.add({
        'image': 'assets/social/tiktok.png',
        'color': const Color(0xFF010101),
        'url': s.tiktok.first,
        'label': 'تيك توك',
      });
    }

    if (s.snapchat.isNotEmpty) {
      links.add({
        'image': 'assets/social/snapchat.png',
        'color': const Color(0xFFFFFC00),
        'url': s.snapchat.first,
        'label': 'سناب شات',
      });
    }

    if (s.whatsappNumber.isNotEmpty) {
      links.add({
        'image': 'assets/social/whatsapp.png',
        'color': const Color(0xFF25D366),
        'url': 'https://wa.me/${s.whatsappNumber}',
        'label': 'واتساب',
      });
    }

    if (links.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2E2E45), Color(0xFF3D3D5C)],
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
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'تواصل معنا',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: links.map((link) {
              final color = link['color'] as Color;
              final hasImage = link.containsKey('image');
              return InkWell(
                onTap: () => _launchURL(link['url'] as String),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: 64,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.15), width: 1),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      hasImage
                          ? Image.asset(
                              link['image'] as String,
                              width: 28,
                              height: 28,
                              fit: BoxFit.contain,
                            )
                          : Icon(link['icon'] as IconData, color: color, size: 28),
                      const SizedBox(height: 6),
                      Text(
                        link['label'] as String,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
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

  // ==================== أزرار الإجراءات ====================
  Widget _buildActionButtons(bool isDark) {
    return const SizedBox.shrink();
  }

  // ==================== زر حذف الحساب ====================
  Widget _buildDeleteAccountButton(AuthProvider ap) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => _showDeleteAccountDialog(ap),
        icon: const Icon(Icons.delete_forever_outlined, color: Colors.red),
        label: const Text('حذف الحساب', style: TextStyle(color: Colors.red)),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.red),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
      ),
    );
  }

  void _showDeleteAccountDialog(AuthProvider ap) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('حذف الحساب', style: TextStyle(color: Colors.red)),
        content: const Text(
          'هل أنت متأكد من حذف حسابك؟\nسيتم حذف جميع بياناتك ويمكنك التسجيل مجدداً بنفس البريد الإلكتروني.',
        ),
        backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final success = await ap.deleteAccount();
              if (mounted) {
                if (success) {
                  context.go(AppRoutes.login);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('فشل حذف الحساب، حاول مرة أخرى'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('حذف الحساب'),
          ),
        ],
      ),
    );
  }

  // ==================== زر تسجيل الخروج ====================
  Widget _buildLogoutButton(AuthProvider ap) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _showLogoutDialog(ap),
        icon: const Icon(Icons.logout),
        label: const Text('تسجيل الخروج'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }

  // ==================== عنوان القسم ====================
  Widget _buildSectionTitle(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}