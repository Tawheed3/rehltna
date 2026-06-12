import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'pdf_viewer_screen.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routes/app_routes.dart';
import '../../data/models/user_model.dart';
import '../../data/providers/auth_provider.dart';
import '../../data/providers/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ==================== ProfileScreen ====================

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  // ==================== Controllers ====================

  late TextEditingController _nameController;
  late TextEditingController _phoneController;

  // ==================== حالة التعديل ====================

  bool _isLoading = false;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  // ==================== حالة توسيع الأقسام ====================

  bool _isOrdersExpanded = false;
  bool _isAccountInfoExpanded = false;

  // ==================== دورة الحياة ====================

  @override
  void initState() {
    super.initState();
    final user = Provider.of<UserProvider>(context, listen: false).user;
    _nameController = TextEditingController(text: user?.name ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSavedImage();
      _refreshProfile();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // ==================== تحديث البروفايل ====================

  Future<void> _refreshProfile() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await Future.wait([
      userProvider.fetchProfile(),
      userProvider.fetchTripDocuments(),
    ]);
  }

  // ==================== تغيير الصورة ====================

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // مقبض
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // عنوان
              const Text(
                'تغيير الصورة الشخصية',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // التقاط صورة
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.camera_alt, color: AppColors.primary),
                ),
                title: const Text('التقاط صورة'),
                onTap: () async {
                  Navigator.pop(ctx);
                  final XFile? image = await _picker.pickImage(
                    source: ImageSource.camera,
                    imageQuality: 80,
                  );
                  if (image != null) {
                    final file = File(image.path);
                    setState(() => _selectedImage = file);
                    await _saveImageLocally(file); // ✅ حفظ الصورة
                  }
                },
              ),

// اختيار من المعرض
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.photo_library, color: Colors.orange),
                ),
                title: const Text('اختيار من المعرض'),
                onTap: () async {
                  Navigator.pop(ctx);
                  final XFile? image = await _picker.pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 80,
                  );
                  if (image != null) {
                    final file = File(image.path);
                    setState(() => _selectedImage = file);
                    await _saveImageLocally(file); // ✅ حفظ الصورة
                  }
                },
              ),

// إزالة الصورة
              if (_selectedImage != null)
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.delete, color: Colors.red),
                  ),
                  title: const Text(
                    'إزالة الصورة',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    setState(() => _selectedImage = null);
                    _removeSavedImage(); // ✅ مسح الصورة المحفوظة
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ==================== نافذة تعديل الملف الشخصي ====================

  void _showEditProfileDialog(UserModel user) {
    // ✅ تعبئة البيانات الحالية
    final nameCtrl = TextEditingController(text: user.name);
    final phoneCtrl = TextEditingController(text: user.phone ?? '');

    showDialog(
      context: context,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;

        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
              title: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.edit,
                      color: AppColors.primary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'تعديل الملف الشخصي',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 8),

                  // حقل الاسم
                  TextField(
                    controller: nameCtrl,
                    decoration: InputDecoration(
                      labelText: 'الاسم',
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: isDark ? Colors.grey.shade800 : Colors.grey.shade50,
                    ),
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // حقل رقم الهاتف
                  TextField(
                    controller: phoneCtrl,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'رقم الهاتف',
                      prefixIcon: const Icon(Icons.phone),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: isDark ? Colors.grey.shade800 : Colors.grey.shade50,
                    ),
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                      fontSize: 15,
                    ),
                  ),

                  // ✅ رسالة خطأ لو فيه
                  if (_isLoading)
                    const Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: LinearProgressIndicator(color: AppColors.primary),
                    ),
                ],
              ),
              actions: [
                // زر إلغاء
                TextButton.icon(
                  onPressed: _isLoading ? null : () => Navigator.pop(ctx),
                  icon: const Icon(Icons.close, size: 18),
                  label: const Text('إلغاء'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                ),

                // زر حفظ
                ElevatedButton.icon(
                  onPressed: _isLoading
                      ? null
                      : () async {
                    if (nameCtrl.text.trim().isEmpty) {
                      ScaffoldMessenger.of(ctx).showSnackBar(
                        const SnackBar(
                          content: Text('الرجاء إدخال الاسم'),
                          backgroundColor: Colors.orange,
                        ),
                      );
                      return;
                    }

                    setDialogState(() {});

                    final userProvider = Provider.of<UserProvider>(
                      context,
                      listen: false,
                    );
                    final body = {
                      'name': nameCtrl.text.trim(),
                      'phone': phoneCtrl.text.trim(),
                    };
                    final success = await userProvider.updateProfile(body);

                    if (ctx.mounted) {
                      Navigator.pop(ctx);
                    }

                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            success
                                ? 'تم التحديث بنجاح'
                                : (userProvider.errorMessage ?? 'فشل التحديث'),
                          ),
                          backgroundColor:
                          success ? Colors.green : Colors.red,
                        ),
                      );
                    }
                  },
                  icon: _isLoading
                      ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                      : const Icon(Icons.check, size: 18),
                  label: Text(_isLoading ? 'جاري الحفظ...' : 'حفظ'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ==================== الواجهة الرئيسية ====================

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final userProvider = Provider.of<UserProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    // ✅ استخدم البيانات المخزنة محلياً لو موجودة
    final user = userProvider.user ?? authProvider.currentUser;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF8FAFC),
      body: user == null
          ? _buildNotLoggedIn(isDark)
          : SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshProfile,
          color: AppColors.primary,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                _buildHeader(user, isDark),
                const SizedBox(height: 20),
                _buildAccountInfoSection(user, isDark),
                const SizedBox(height: 20),
                _buildPointsSection(user, isDark),
                const SizedBox(height: 20),
                _buildOrdersSection(user, isDark),
                const SizedBox(height: 20),
                _buildTripDocumentsSection(userProvider, isDark),
                const SizedBox(height: 20),
                _buildLogoutSection(authProvider, isDark),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==================== هيدر ====================

  Widget _buildHeader(UserModel user, bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // شريط العنوان
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    size: 18,
                    color: Colors.white,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const Text(
                'الملف الشخصي',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
          const SizedBox(height: 30),

          // صورة البروفايل
          GestureDetector(
            onTap: _pickImage,
            child: Stack(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 15,
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: _buildAvatar(user),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primary,
                        width: 3,
                      ),
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: AppColors.primary,
                      size: 22,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // اسم المستخدم
          Text(
            user.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),

          // البريد الإلكتروني
          Text(
            user.email,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  /// بناء صورة الآڤاتار
  Widget _buildAvatar(UserModel user) {
    // ✅ الصورة المحفوظة محلياً أولاً (أسرع)
    if (_selectedImage != null) {
      return Image.file(
        _selectedImage!,
        width: 120,
        height: 120,
        fit: BoxFit.cover,
      );
    }

    // ✅ صورة الباك إند مع cache
    if (user.avatarUrl != null && user.avatarUrl!.isNotEmpty) {
      return Image.network(
        user.avatarUrl!,
        width: 120,
        height: 120,
        fit: BoxFit.cover,
        cacheWidth: 240,  // ✅ كاش للصورة
        cacheHeight: 240,
        errorBuilder: (c, e, s) => _buildInitialsAvatar(user),
      );
    }

    return _buildInitialsAvatar(user);
  }
  /// بناء آڤاتار بالأحرف الأولى
  Widget _buildInitialsAvatar(UserModel user) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.3),
            Colors.white.withOpacity(0.1),
          ],
        ),
      ),
      child: Center(
        child: Text(
          user.initials,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 45,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // ==================== تحميل الصورة المحفوظة ====================

  Future<void> _loadSavedImage() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString('user_avatar');
    if (imagePath != null && imagePath.isNotEmpty) {
      final file = File(imagePath);
      if (await file.exists()) {
        setState(() {
          _selectedImage = file;
        });
      }
    }
  }

// ==================== حفظ الصورة محلياً ====================

  Future<void> _saveImageLocally(File image) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_avatar', image.path);
  }

// ==================== مسح الصورة المحفوظة ====================

  Future<void> _removeSavedImage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_avatar');
  }

  // ==================== قسم معلومات الحساب (Dropdown) ====================

  Widget _buildAccountInfoSection(UserModel user, bool isDark) {
    return Column(
      children: [
        // هيدر قابل للطي
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _buildAccountInfoHeader(user, isDark),
        ),
        // محتوى القائمة
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: _isAccountInfoExpanded
              ? Padding(
            padding: const EdgeInsets.only(top: 10),
            child: _buildAccountInfoContent(user, isDark),
          )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildAccountInfoHeader(UserModel user, bool isDark) {
    return GestureDetector(
      onTap: () => setState(
            () => _isAccountInfoExpanded = !_isAccountInfoExpanded,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              isDark
                  ? const Color(0xFF1E293B)
                  : AppColors.primary.withOpacity(0.05),
              isDark
                  ? const Color(0xFF334155)
                  : AppColors.primary.withOpacity(0.02),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark
                ? Colors.grey.shade700
                : AppColors.primary.withOpacity(0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // أيقونة
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.secondary],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),

            // العنوان + ملخص
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'معلومات الحساب',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${user.name} • ${user.phone ?? 'بدون هاتف'}',
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? Colors.white54 : Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // زر التعديل
            GestureDetector(
              onTap: () => _showEditProfileDialog(user),
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.edit,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
            ),

            // سهم الفتح
            AnimatedRotation(
              turns: _isAccountInfoExpanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.primary,
                size: 28,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountInfoContent(UserModel user, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey.shade900 : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark
                ? Colors.grey.shade700
                : AppColors.primary.withOpacity(0.15),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // الاسم
            _buildInfoRow(
              icon: Icons.person,
              label: 'الاسم',
              value: user.name,
              color: AppColors.primary,
              isDark: isDark,
            ),
            const Divider(height: 24),

            // البريد الإلكتروني
            _buildInfoRow(
              icon: Icons.email_outlined,
              label: 'البريد الإلكتروني',
              value: user.email,
              color: Colors.blue,
              isDark: isDark,
            ),
            const Divider(height: 24),

            // رقم الهاتف
            _buildInfoRow(
              icon: Icons.phone,
              label: 'رقم الهاتف',
              value: user.phone ?? 'غير محدد',
              color: Colors.green,
              isDark: isDark,
            ),
            const Divider(height: 24),

            // تاريخ التسجيل
            _buildInfoRow(
              icon: Icons.calendar_today,
              label: 'تاريخ التسجيل',
              value: _formatDate(user.createdAt),
              color: Colors.orange,
              isDark: isDark,
            ),
          ],
        ),
      ),
    );
  }

  // ==================== صف للمعلومات الثابتة ====================

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required bool isDark,
  }) {
    return Row(
      children: [
        Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.white54 : Colors.grey[600],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==================== قسم النقاط ====================

  Widget _buildPointsSection(UserModel user, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.secondary],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.card_giftcard,
                    color: Colors.amber,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'نقاطي',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildPointItem(
                    icon: Icons.emoji_events,
                    label: 'المكتسبة',
                    value: user.earnedPoints.toStringAsFixed(0),
                    color: Colors.amber,
                  ),
                ),
                Container(
                  width: 1,
                  height: 50,
                  color: Colors.white.withOpacity(0.2),
                ),
                Expanded(
                  child: _buildPointItem(
                    icon: Icons.wallet,
                    label: 'المتاحة',
                    value: user.availablePoints.toStringAsFixed(0),
                    color: Colors.greenAccent,
                  ),
                ),
                Container(
                  width: 1,
                  height: 50,
                  color: Colors.white.withOpacity(0.2),
                ),
                Expanded(
                  child: _buildPointItem(
                    icon: Icons.shopping_cart,
                    label: 'المستخدمة',
                    value: user.usedPoints.toStringAsFixed(0),
                    color: Colors.redAccent,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPointItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  // ==================== قسم الطلبات (Dropdown) ====================

  Widget _buildOrdersSection(UserModel user, bool isDark) {
    return Column(
      children: [
        // هيدر
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _buildOrdersHeader(user, isDark),
        ),
        // محتوى
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: _isOrdersExpanded
              ? Padding(
            padding: const EdgeInsets.only(top: 10),
            child: user.orders.isNotEmpty
                ? _buildOrdersList(user, isDark)
                : _buildEmptyOrders(isDark),
          )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildOrdersHeader(UserModel user, bool isDark) {
    return GestureDetector(
      onTap: () => setState(
            () => _isOrdersExpanded = !_isOrdersExpanded,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              isDark
                  ? const Color(0xFF1E293B)
                  : AppColors.primary.withOpacity(0.05),
              isDark
                  ? const Color(0xFF334155)
                  : AppColors.primary.withOpacity(0.02),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark
                ? Colors.grey.shade700
                : AppColors.primary.withOpacity(0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.secondary],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.receipt_long,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'طلباتي',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${user.orders.length} طلبات',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white54 : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${user.orders.length}',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 10),
            AnimatedRotation(
              turns: _isOrdersExpanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.primary,
                size: 28,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrdersList(UserModel user, bool isDark) {
    return Column(
      children: user.orders.map(
            (order) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _buildOrderCard(order, isDark),
        ),
      ).toList(),
    );
  }

  Widget _buildEmptyOrders(bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade900 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.grey.shade700 : Colors.grey.shade200,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 50,
            color: isDark ? Colors.white24 : Colors.grey[300],
          ),
          const SizedBox(height: 12),
          Text(
            'لا توجد طلبات بعد',
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white54 : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'ستظهر طلباتك هنا بعد إتمام الحجز',
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.white38 : Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }

  // ==================== كارد طلب ====================

  Widget _buildOrderCard(dynamic order, bool isDark) {
    final paymentStatus = order['payment_status'] ?? 'pending';

    // ✅ إضافة حالة "reviewing"
    final statusColor = paymentStatus == 'paid'
        ? Colors.green
        : paymentStatus == 'pending'
        ? Colors.orange
        : paymentStatus == 'reviewing'
        ? Colors.blue           // ✅ لون أزرق للمراجعة
        : Colors.red;

    final statusText = paymentStatus == 'paid'
        ? 'تم الدفع'
        : paymentStatus == 'pending'
        ? 'قيد الانتظار'
        : paymentStatus == 'reviewing'
        ? 'قيد المراجعة'       // ✅ نص جديد
        : 'ملغي';
    final paymentMethod = order['payment_method'] ?? 'غير محدد';
    final totalAmount = order['total_amount'] ?? '0';
    final createdAt = order['created_at'] ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade800 : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? Colors.grey.shade700 : Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.receipt,
                      size: 16,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'طلب #${order['id']}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      if (createdAt.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 10,
                              color: isDark
                                  ? Colors.white38
                                  : Colors.grey[500],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _formatOrderDate(createdAt),
                              style: TextStyle(
                                fontSize: 10,
                                color: isDark
                                    ? Colors.white38
                                    : Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: statusColor.withOpacity(0.3),
                  ),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 11,
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'المبلغ',
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? Colors.white54 : Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$totalAmount ريال',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 1,
                height: 35,
                color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'طريقة الدفع',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? Colors.white54 : Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(
                            Icons.payment,
                            size: 14,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              _getPaymentMethodName(paymentMethod),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: isDark
                                    ? Colors.white70
                                    : Colors.grey[700],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getPaymentMethodName(String code) {
    switch (code) {
      case 'tamara':
        return 'تمارا';
      case 'bank_transfer_alrajhi':
        return 'تحويل بنكي الراجحي';
      case 'bank_transfer_alahli':
        return 'تحويل بنكي الأهلي';
      case 'moyasar':
        return 'مدى / فيزا';
      default:
        return code.replaceAll('_', ' ');
    }
  }

  String _formatOrderDate(String date) {
    try {
      final d = DateTime.parse(date);
      return '${d.year}/${d.month.toString().padLeft(2, '0')}/${d.day.toString().padLeft(2, '0')}';
    } catch (e) {
      return date;
    }
  }

  // ==================== قسم وثائق الرحلات ====================
  Widget _buildTripDocumentsSection(UserProvider userProvider, bool isDark) {
    final docs = userProvider.tripDocuments;
    if (docs.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.folder_special, color: AppColors.primary, size: 22),
              ),
              const SizedBox(width: 12),
              Text(
                'وثائق رحلاتي',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Document cards
          ...docs.map((doc) => _TripDocumentCard(doc: doc, isDark: isDark)),
        ],
      ),
    );
  }

  // ==================== قسم تسجيل الخروج ====================

  Widget _buildLogoutSection(AuthProvider authProvider, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () => _showLogoutDialog(authProvider),
          icon: const Icon(Icons.logout),
          label: const Text('تسجيل الخروج'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.withOpacity(0.1),
            foregroundColor: Colors.red,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text('تسجيل الخروج'),
        content: const Text('هل أنت متأكد من تسجيل الخروج؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await authProvider.signOut();
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

  // ==================== غير مسجل ====================

  Widget _buildNotLoggedIn(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person_outline,
              size: 80,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'أنت الآن زائر',
            style: TextStyle(
              fontSize: 20,
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
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.go(AppRoutes.login),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 14,
              ),
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

  // ==================== دوال مساعدة ====================

  String _formatDate(DateTime date) =>
      '${date.year}/${date.month}/${date.day}';
}

// ==================== كارت وثيقة الرحلة ====================

class _TripDocumentCard extends StatefulWidget {
  final Map<String, dynamic> doc;
  final bool isDark;

  const _TripDocumentCard({required this.doc, required this.isDark});

  @override
  State<_TripDocumentCard> createState() => _TripDocumentCardState();
}

class _TripDocumentCardState extends State<_TripDocumentCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final doc = widget.doc;
    final isDark = widget.isDark;
    final trip = doc['trip'] as Map<String, dynamic>? ?? {};
    final title = trip['title_ar'] ?? trip['title_en'] ?? 'رحلة';
    final details = (doc['details'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final pdfUrl = doc['pdf_url'] as String?;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade900 : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Colors.grey.shade700
              : AppColors.primary.withOpacity(0.12),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header — tap to expand
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.luggage, color: AppColors.primary, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${details.length} محور${pdfUrl != null ? ' · يتضمن PDF' : ''}',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.white54 : Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 250),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColors.primary,
                      size: 26,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Expanded content
          if (_expanded) ...[
            Divider(
              height: 1,
              color: isDark ? Colors.grey.shade700 : Colors.grey.shade100,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Key-value details
                  ...details.map((row) => _buildDetailRow(
                        row['key'] ?? '',
                        row['value'] ?? '',
                        row['location'] as String?,
                        isDark,
                      )),

                  // PDF button
                  if (pdfUrl != null) ...[
                    const SizedBox(height: 8),
                    _buildPdfButton(pdfUrl),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(String key, String value, String? location, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade800 : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            key,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 8),
          Container(width: 1, height: 16, color: AppColors.primary.withOpacity(0.3), margin: const EdgeInsets.only(top: 2)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.5,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),
                if (location != null && location.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: () async {
                      final uri = Uri.tryParse(location);
                      if (uri != null) await launchUrl(uri, mode: LaunchMode.externalApplication);
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.location_on, size: 13, color: Colors.blue),
                        SizedBox(width: 4),
                        Text(
                          'عرض الموقع على الخريطة',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.blue),
                        ),
                      ],
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

  Widget _buildPdfButton(String url) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PdfViewerScreen(url: url, title: 'وثيقة رحلتي'),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.red.shade100),
        ),
        child: Row(
          children: [
            Icon(Icons.picture_as_pdf, color: Colors.red.shade600, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'عرض وثيقة PDF',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Colors.red.shade700,
                    ),
                  ),
                  Text(
                    'اضغط لعرض الملف داخل التطبيق',
                    style: TextStyle(fontSize: 11, color: Colors.red.shade400),
                  ),
                ],
              ),
            ),
            Icon(Icons.visibility_rounded, color: Colors.red.shade400, size: 20),
          ],
        ),
      ),
    );
  }
}