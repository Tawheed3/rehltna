import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routes/app_routes.dart';
import '../../data/models/user_model.dart';
import '../../data/providers/auth_provider.dart';
import '../../data/providers/user_provider.dart';

// ==================== ProfileScreen ====================

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Controllers
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  // حالة التعديل لكل حقل
  bool _isEditingName = false;
  bool _isEditingEmail = false;
  bool _isEditingPhone = false;
  bool _isLoading = false;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  // ✅ حالة توسيع الأقسام
  bool _isOrdersExpanded = false;
  bool _isAccountInfoExpanded = false;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<UserProvider>(context, listen: false).user;
    _nameController = TextEditingController(text: user?.name ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      if (userProvider.user == null) userProvider.fetchProfile();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // ==================== تغيير الصورة ====================

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 20),
            const Text('تغيير الصورة الشخصية', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ListTile(
              leading: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), shape: BoxShape.circle), child: const Icon(Icons.camera_alt, color: AppColors.primary)),
              title: const Text('التقاط صورة'),
              onTap: () async { Navigator.pop(ctx); final XFile? image = await _picker.pickImage(source: ImageSource.camera, imageQuality: 80); if (image != null) setState(() => _selectedImage = File(image.path)); },
            ),
            ListTile(
              leading: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), shape: BoxShape.circle), child: const Icon(Icons.photo_library, color: Colors.orange)),
              title: const Text('اختيار من المعرض'),
              onTap: () async { Navigator.pop(ctx); final XFile? image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80); if (image != null) setState(() => _selectedImage = File(image.path)); },
            ),
            if (_selectedImage != null)
              ListTile(
                leading: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), shape: BoxShape.circle), child: const Icon(Icons.delete, color: Colors.red)),
                title: const Text('إزالة الصورة', style: TextStyle(color: Colors.red)),
                onTap: () { Navigator.pop(ctx); setState(() => _selectedImage = null); },
              ),
          ]),
        ),
      ),
    );
  }

  // ==================== تحديث البيانات ====================

  Future<void> _updateField(String field, String value) async {
    setState(() => _isLoading = true);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final success = await userProvider.updateProfile({field: value});
    if (mounted) {
      setState(() {
        _isLoading = false;
        _isEditingName = false;
        _isEditingEmail = false;
        _isEditingPhone = false;
      });
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم التحديث بنجاح'), backgroundColor: Colors.green));
      }
    }
  }

  // ==================== الواجهة الرئيسية ====================

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final userProvider = Provider.of<UserProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final user = userProvider.user ?? authProvider.currentUser;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF8FAFC),
      body: userProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : user == null
          ? _buildNotLoggedIn(isDark)
          : SafeArea(
        child: SingleChildScrollView(
          child: Column(children: [
            _buildHeader(user, isDark),
            const SizedBox(height: 20),

            // 📝 معلومات الحساب (قابلة للطي)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildAccountInfoHeader(user, isDark),
            ),
            // القائمة القابلة للطي
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
            const SizedBox(height: 20),

            // 🎫 بطاقة النقاط
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildPointsCard(user, isDark),
            ),
            const SizedBox(height: 20),

            // 📦 طلباتي (قابلة للطي)
            if (user.orders.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildOrdersHeader(user, isDark),
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: _isOrdersExpanded
                    ? Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(
                    children: user.orders.map((order) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: _buildOrderCard(order, isDark),
                    )).toList(),
                  ),
                )
                    : const SizedBox.shrink(),
              ),
            ],
            const SizedBox(height: 20),

            // تسجيل الخروج
            Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: _buildLogoutButton(authProvider, isDark)),
            const SizedBox(height: 30),
          ]),
        ),
      ),
    );
  }

  // ==================== هيدر ====================

  Widget _buildHeader(UserModel user, bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 30),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [AppColors.primary, AppColors.secondary], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
        boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Container(decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle), child: IconButton(icon: const Icon(Icons.arrow_back_ios, size: 18, color: Colors.white), onPressed: () => Navigator.pop(context))),
          const Text('الملف الشخصي', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(width: 48),
        ]),
        const SizedBox(height: 30),
        GestureDetector(
          onTap: _pickImage,
          child: Stack(children: [
            Container(
              width: 120, height: 120,
              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 4), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 15)]),
              child: ClipOval(
                child: _selectedImage != null
                    ? Image.file(_selectedImage!, width: 120, height: 120, fit: BoxFit.cover)
                    : user.avatarUrl != null && user.avatarUrl!.isNotEmpty
                    ? Image.network(user.avatarUrl!, width: 120, height: 120, fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.white.withOpacity(0.3), Colors.white.withOpacity(0.1)])), child: Center(child: Text(user.initials, style: const TextStyle(color: Colors.white, fontSize: 45, fontWeight: FontWeight.bold)))))
                    : Container(decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.white.withOpacity(0.3), Colors.white.withOpacity(0.1)])), child: Center(child: Text(user.initials, style: const TextStyle(color: Colors.white, fontSize: 45, fontWeight: FontWeight.bold)))),
              ),
            ),
            Positioned(bottom: 0, right: 0, child: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: AppColors.primary, width: 3)), child: const Icon(Icons.camera_alt, color: AppColors.primary, size: 22))),
          ]),
        ),
        const SizedBox(height: 16),
        Text(user.name, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(user.email, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14)),
      ]),
    );
  }

  // ==================== هيدر معلومات الحساب القابل للطي ====================

  Widget _buildAccountInfoHeader(UserModel user, bool isDark) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isAccountInfoExpanded = !_isAccountInfoExpanded;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              isDark ? const Color(0xFF1E293B) : AppColors.primary.withOpacity(0.05),
              isDark ? const Color(0xFF334155) : AppColors.primary.withOpacity(0.02),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? Colors.grey.shade700 : AppColors.primary.withOpacity(0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(children: [
          // 👤 أيقونة معلومات الحساب
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.person, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 14),

          // 📝 العنوان + ملخص
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
                  '${user.name} • ${user.email}',
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

          // ▶️ السهم المتحرك
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
        ]),
      ),
    );
  }

  // ==================== محتوى معلومات الحساب ====================

  Widget _buildAccountInfoContent(UserModel user, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey.shade900 : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? Colors.grey.shade700 : AppColors.primary.withOpacity(0.15),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(children: [
          // ✅ الاسم
          _buildEditableRow(
            icon: Icons.person, label: 'الاسم', value: user.name,
            controller: _nameController, isEditing: _isEditingName,
            onEdit: () => setState(() { _isEditingName = true; _isEditingEmail = false; _isEditingPhone = false; }),
            onSave: () => _updateField('name', _nameController.text),
            onCancel: () { setState(() { _isEditingName = false; _nameController.text = user.name; }); },
            color: AppColors.primary, isDark: isDark,
          ),
          const Divider(height: 24),

          // ✅ البريد الإلكتروني
          _buildEditableRow(
            icon: Icons.email_outlined, label: 'البريد الإلكتروني', value: user.email,
            controller: _emailController, isEditing: _isEditingEmail,
            onEdit: () => setState(() { _isEditingEmail = true; _isEditingName = false; _isEditingPhone = false; }),
            onSave: () => _updateField('email', _emailController.text),
            onCancel: () { setState(() { _isEditingEmail = false; _emailController.text = user.email; }); },
            color: Colors.blue, isDark: isDark,
          ),
          const Divider(height: 24),

          // ✅ رقم الهاتف
          _buildEditableRow(
            icon: Icons.phone, label: 'رقم الهاتف', value: user.phone ?? 'غير محدد',
            controller: _phoneController, isEditing: _isEditingPhone,
            onEdit: () => setState(() { _isEditingPhone = true; _isEditingName = false; _isEditingEmail = false; }),
            onSave: () => _updateField('phone', _phoneController.text),
            onCancel: () { setState(() { _isEditingPhone = false; _phoneController.text = user.phone ?? ''; }); },
            color: Colors.green, isDark: isDark,
          ),
          const Divider(height: 24),

          // ✅ تاريخ التسجيل (غير قابل للتعديل)
          _buildInfoRow(Icons.calendar_today, 'تاريخ التسجيل', _formatDate(user.createdAt), Colors.orange, isDark),
        ]),
      ),
    );
  }

  // ✅ صف قابل للتعديل
  Widget _buildEditableRow({
    required IconData icon, required String label, required String value,
    required TextEditingController controller, required bool isEditing,
    required VoidCallback onEdit, required VoidCallback onSave, required VoidCallback onCancel,
    required Color color, required bool isDark,
  }) {
    return Column(children: [
      Row(children: [
        Container(width: 45, height: 45, decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: color, size: 22)),
        const SizedBox(width: 14),
        Expanded(
          child: isEditing
              ? TextFormField(
            controller: controller,
            autofocus: true,
            style: TextStyle(color: isDark ? Colors.white : Colors.black, fontSize: 15),
            decoration: InputDecoration(isDense: true, contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10), border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
            onFieldSubmitted: (_) => onSave(),
          )
              : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: TextStyle(fontSize: 12, color: isDark ? Colors.white54 : Colors.grey[600])),
            const SizedBox(height: 2),
            Text(value, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: isDark ? Colors.white : Colors.black87)),
          ]),
        ),
        if (isEditing) ...[
          IconButton(icon: const Icon(Icons.check, color: Colors.green), onPressed: onSave, tooltip: 'حفظ'),
          IconButton(icon: const Icon(Icons.close, color: Colors.red), onPressed: onCancel, tooltip: 'إلغاء'),
        ] else
          IconButton(icon: Icon(Icons.edit_outlined, color: color.withOpacity(0.7), size: 20), onPressed: onEdit, tooltip: 'تعديل'),
      ]),
    ]);
  }

  // ✅ صف للمعلومات الثابتة
  Widget _buildInfoRow(IconData icon, String label, String value, Color color, bool isDark) {
    return Row(children: [
      Container(width: 45, height: 45, decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: color, size: 22)),
      const SizedBox(width: 14),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: TextStyle(fontSize: 12, color: isDark ? Colors.white54 : Colors.grey[600])),
        const SizedBox(height: 2),
        Text(value, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: isDark ? Colors.white : Colors.black87)),
      ])),
    ]);
  }

  // ==================== 🎫 بطاقة النقاط ====================

  Widget _buildPointsCard(UserModel user, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [AppColors.primary, AppColors.secondary]),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.card_giftcard, color: Colors.amber, size: 24),
            ),
            const SizedBox(width: 12),
            const Text('نقاطي', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          ]),
          const SizedBox(height: 20),
          Row(children: [
            Expanded(child: _buildPointItem(icon: Icons.emoji_events, label: 'المكتسبة', value: user.earnedPoints.toStringAsFixed(0), color: Colors.amber)),
            Container(width: 1, height: 50, color: Colors.white.withOpacity(0.2)),
            Expanded(child: _buildPointItem(icon: Icons.wallet, label: 'المتاحة', value: user.availablePoints.toStringAsFixed(0), color: Colors.greenAccent)),
            Container(width: 1, height: 50, color: Colors.white.withOpacity(0.2)),
            Expanded(child: _buildPointItem(icon: Icons.shopping_cart, label: 'المستخدمة', value: user.usedPoints.toStringAsFixed(0), color: Colors.redAccent)),
          ]),
        ],
      ),
    );
  }

  Widget _buildPointItem({required IconData icon, required String label, required String value, required Color color}) {
    return Column(children: [
      Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: color.withOpacity(0.2), shape: BoxShape.circle), child: Icon(icon, color: color, size: 22)),
      const SizedBox(height: 8),
      Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      const SizedBox(height: 2),
      Text(label, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 11)),
    ]);
  }

  // ==================== هيدر طلباتي القابل للطي ====================

  Widget _buildOrdersHeader(UserModel user, bool isDark) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isOrdersExpanded = !_isOrdersExpanded;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              isDark ? const Color(0xFF1E293B) : AppColors.primary.withOpacity(0.05),
              isDark ? const Color(0xFF334155) : AppColors.primary.withOpacity(0.02),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? Colors.grey.shade700 : AppColors.primary.withOpacity(0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(children: [
          Container(
            width: 45, height: 45,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [AppColors.primary, AppColors.secondary], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.receipt_long, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('طلباتي', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
              const SizedBox(height: 2),
              Text('${user.orders.length} طلبات', style: TextStyle(fontSize: 12, color: isDark ? Colors.white54 : Colors.grey[600])),
            ]),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Text('${user.orders.length}', style: const TextStyle(color: AppColors.primary, fontSize: 14, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 10),
          AnimatedRotation(
            turns: _isOrdersExpanded ? 0.5 : 0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: Icon(Icons.keyboard_arrow_down, color: AppColors.primary, size: 28),
          ),
        ]),
      ),
    );
  }

  // ==================== كارد طلب ====================

  Widget _buildOrderCard(dynamic order, bool isDark) {
    final paymentStatus = order['payment_status'] ?? 'pending';
    final statusColor = paymentStatus == 'paid' ? Colors.green : paymentStatus == 'pending' ? Colors.orange : Colors.red;
    final statusText = paymentStatus == 'paid' ? 'تم الدفع' : paymentStatus == 'pending' ? 'قيد الانتظار' : 'ملغي';
    final paymentMethod = order['payment_method'] ?? 'غير محدد';
    final totalAmount = order['total_amount'] ?? '0';
    final createdAt = order['created_at'] ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade800 : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.receipt, size: 16, color: AppColors.primary),
            ),
            const SizedBox(width: 8),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('طلب #${order['id']}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
              if (createdAt.isNotEmpty) ...[
                const SizedBox(height: 2),
                Row(children: [
                  Icon(Icons.access_time, size: 10, color: isDark ? Colors.white38 : Colors.grey[500]),
                  const SizedBox(width: 4),
                  Text(_formatOrderDate(createdAt), style: TextStyle(fontSize: 10, color: isDark ? Colors.white38 : Colors.grey[500])),
                ]),
              ],
            ]),
          ]),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: statusColor.withOpacity(0.3))),
            child: Text(statusText, style: TextStyle(fontSize: 11, color: statusColor, fontWeight: FontWeight.bold)),
          ),
        ]),
        const SizedBox(height: 12),
        const Divider(height: 1),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('المبلغ', style: TextStyle(fontSize: 11, color: isDark ? Colors.white54 : Colors.grey[600])),
              const SizedBox(height: 2),
              Text('$totalAmount ريال', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary)),
            ]),
          ),
          Container(width: 1, height: 35, color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('طريقة الدفع', style: TextStyle(fontSize: 11, color: isDark ? Colors.white54 : Colors.grey[600])),
                const SizedBox(height: 2),
                Row(children: [
                  Icon(Icons.payment, size: 14, color: AppColors.primary),
                  const SizedBox(width: 4),
                  Expanded(child: Text(_getPaymentMethodName(paymentMethod), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: isDark ? Colors.white70 : Colors.grey[700]), maxLines: 1, overflow: TextOverflow.ellipsis)),
                ]),
              ]),
            ),
          ),
        ]),
      ]),
    );
  }

  String _getPaymentMethodName(String code) {
    switch (code) {
      case 'tamara': return 'تمارا';
      case 'bank_transfer_alrajhi': return 'تحويل بنكي الراجحي';
      case 'bank_transfer_alahli': return 'تحويل بنكي الأهلي';
      case 'moyasar': return 'مدى / فيزا';
      default: return code.replaceAll('_', ' ');
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

  // ==================== تسجيل الخروج ====================

  Widget _buildLogoutButton(AuthProvider authProvider, bool isDark) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _showLogoutDialog(authProvider),
        icon: const Icon(Icons.logout),
        label: const Text('تسجيل الخروج'),
        style: ElevatedButton.styleFrom(backgroundColor: Colors.red.withOpacity(0.1), foregroundColor: Colors.red, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0),
      ),
    );
  }

  void _showLogoutDialog(AuthProvider authProvider) {
    showDialog(context: context, builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('تسجيل الخروج'), content: const Text('هل أنت متأكد من تسجيل الخروج؟'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
        ElevatedButton(onPressed: () async { Navigator.pop(ctx); await authProvider.signOut(); if (mounted) context.go(AppRoutes.login); }, style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white), child: const Text('تسجيل الخروج')),
      ],
    ));
  }

  // ==================== غير مسجل ====================

  Widget _buildNotLoggedIn(bool isDark) {
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(padding: const EdgeInsets.all(30), decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), shape: BoxShape.circle), child: const Icon(Icons.person_outline, size: 80, color: AppColors.primary)),
      const SizedBox(height: 24),
      Text('أنت الآن زائر', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
      const SizedBox(height: 8),
      Text('سجل دخول للاستفادة من جميع المميزات', style: TextStyle(fontSize: 14, color: isDark ? Colors.white70 : Colors.grey[600])),
      const SizedBox(height: 24),
      ElevatedButton(onPressed: () => context.go(AppRoutes.login), style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))), child: const Text('تسجيل الدخول')),
    ]));
  }

  String _formatDate(DateTime date) => '${date.year}/${date.month}/${date.day}';
}