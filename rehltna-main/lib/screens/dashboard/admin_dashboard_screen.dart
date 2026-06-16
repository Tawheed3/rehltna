import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import '../../core/constants/app_colors.dart';
import '../../data/providers/auth_provider.dart';
import '../../data/providers/user_provider.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  List<Map<String, dynamic>> _users = [];
  List<Map<String, dynamic>> _filteredUsers = [];
  bool _isLoading = true;
  String? _errorMessage;
  String _searchQuery = '';
  String _selectedFilter = 'الكل'; // الكل, فضة, ذهب, ألماس

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadUsers() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final token = authProvider.token;

      if (token == null) {
        setState(() {
          _errorMessage = 'لا يوجد توكن. الرجاء تسجيل الدخول مرة أخرى';
          _isLoading = false;
        });
        return;
      }

      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final response = await userProvider.getRequest('users-info', token: token);

      if (response != null && response['code'] == 200 && response['data'] != null) {
        setState(() {
          _users = List<Map<String, dynamic>>.from(response['data']);
          _applyFilter();
        });
      } else {
        setState(() {
          _errorMessage = 'فشل في تحميل بيانات المستخدمين';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'حدث خطأ: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _applyFilter() {
    List<Map<String, dynamic>> filtered = List.from(_users);

    // إزالة التكرارات بناءً على رقم الهاتف (مع الاحتفاظ بالأعلى رتبة)
    final Map<String, Map<String, dynamic>> uniqueUsers = {};

    for (var user in filtered) {
      final phone = user['phone']?.toString() ?? '';
      if (phone.isEmpty) continue; // تجاهل المستخدمين بدون رقم هاتف

      final package = user['package']?.toString().toLowerCase() ?? '';
      final currentPriority = _getPackagePriority(package);

      if (!uniqueUsers.containsKey(phone)) {
        // أول مرة نشوف هذا الرقم
        uniqueUsers[phone] = user;
      } else {
        // الرقم موجود مسبقاً، نقارن الرتبة
        final existingUser = uniqueUsers[phone]!;
        final existingPackage = existingUser['package']?.toString().toLowerCase() ?? '';
        final existingPriority = _getPackagePriority(existingPackage);

        // إذا كان المستخدم الجديد له رتبة أعلى، نستبدل القديم
        if (currentPriority > existingPriority) {
          uniqueUsers[phone] = user;
        }
        // إذا كانت الرتبة متساوية، نحتفظ بالأول (أو ممكن نحتفظ بأي واحد)
      }
    }

    filtered = uniqueUsers.values.toList();

    // تطبيق البحث
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((user) {
        final name = user['name']?.toString().toLowerCase() ?? '';
        final phone = user['phone']?.toString().toLowerCase() ?? '';
        final query = _searchQuery.toLowerCase();
        return name.contains(query) || phone.contains(query);
      }).toList();
    }

    // تطبيق فلتر الرتبة
    if (_selectedFilter != 'الكل') {
      filtered = filtered.where((user) {
        final package = user['package']?.toString().toLowerCase() ?? '';
        if (_selectedFilter == 'فضي') return package == 'silver';
        if (_selectedFilter == 'ذهبي') return package == 'gold';
        if (_selectedFilter == 'ألماسي') return package == 'diamond';
        return false;
      }).toList();
    }

    setState(() {
      _filteredUsers = filtered;
    });
  }

  // دالة لحساب أولوية الرتبة
  int _getPackagePriority(String? package) {
    switch (package?.toLowerCase()) {
      case 'diamond':
        return 3;
      case 'gold':
        return 2;
      case 'silver':
        return 1;
      default:
        return 0;
    }
  }

  // دالة لتنظيف رقم الهاتف (إزالة المسافات والرموز غير الرقمية)
  String _cleanPhoneNumber(String phone) {
    // إزالة كل ما ليس رقم
    return phone.replaceAll(RegExp(r'[^0-9]'), '');
  }

  Future<void> _saveToContacts(String name, String phone, String? package) async {
    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('رقم الهاتف غير متوفر لهذا المستخدم'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // تنظيف رقم الهاتف
    final cleanPhone = _cleanPhoneNumber(phone);

    // إضافة كلمة "app" مع الاسم
    final contactName = '$name (app)';

    // طلب صلاحية الوصول لجهات الاتصال
    if (!await FlutterContacts.requestPermission()) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('الرجاء السماح بالوصول إلى جهات الاتصال'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    try {
      // البحث عن جهات الاتصال الموجودة بنفس الرقم (تطابق تام)
      final allContacts = await FlutterContacts.getContacts();

      // البحث الدقيق عن الرقم (وليس مجرد contains)
      final existingContacts = allContacts.where((contact) {
        return contact.phones.any((p) {
          final contactPhone = _cleanPhoneNumber(p.number);
          return contactPhone == cleanPhone;
        });
      }).toList();

      if (existingContacts.isNotEmpty) {
        // الرقم موجود بالفعل
        if (mounted) {
          _showDuplicateContactDialog(contactName, phone, package, existingContacts, cleanPhone);
        }
        return;
      }

      // الرقم غير موجود، نقوم بحفظه مباشرة
      await _createNewContact(contactName, phone);

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('حدث خطأ: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _createNewContact(String name, String phone) async {
    try {
      final newContact = Contact(
        name: Name(first: name),
        phones: [Phone(phone)],
      );

      await newContact.insert();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('تم حفظ $name في جهات الاتصال'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('حدث خطأ في حفظ جهة الاتصال: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showDuplicateContactDialog(
      String name,
      String phone,
      String? package,
      List<Contact> existingContacts,
      String cleanPhone,
      ) {
    final currentPriority = _getPackagePriority(package);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // فحص رتبة جهات الاتصال الموجودة
    bool hasHigherPriority = false;
    String higherPriorityNames = '';

    // هذا للعرض فقط - لا يمكننا معرفة رتبة جهات الاتصال الموجودة من التطبيق
    // لكننا نفترض أن المستخدم يريد استبدالها

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('رقم موجود مسبقاً'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('هذا الرقم موجود بالفعل في جهات الاتصال:'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'الرقم: $phone',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  ...existingContacts.take(3).map((contact) => Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text('• ${contact.name?.first ?? 'بدون اسم'}'),
                  )),
                  if (existingContacts.length > 3)
                    Text('...و ${existingContacts.length - 3} آخرين'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'هل تريد حفظ هذا المستخدم (رتبته: ${_getPackageName(package)}) بدلاً من الموجود؟',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogContext);

              // حذف جميع جهات الاتصال القديمة بهذا الرقم
              for (var contact in existingContacts) {
                await contact.delete();
              }

              // حفظ المستخدم الجديد
              await _createNewContact(name, phone);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: const Text('استبدال'),
          ),
        ],
      ),
    );
  }

  Color _getPackageColor(String? package) {
    switch (package?.toLowerCase()) {
      case 'silver':
        return const Color(0xFFC0C0C0);
      case 'gold':
        return const Color(0xFFFFD700);
      case 'diamond':
        return const Color(0xFFB9F2FF);
      default:
        return Colors.grey;
    }
  }

  String _getPackageName(String? package) {
    switch (package?.toLowerCase()) {
      case 'silver':
        return 'فضي';
      case 'gold':
        return 'ذهبي';
      case 'diamond':
        return 'ألماسي';
      default:
        return package ?? 'عادي';
    }
  }

  IconData _getPackageIcon(String? package) {
    switch (package?.toLowerCase()) {
      case 'silver':
        return Icons.emoji_events_outlined;
      case 'gold':
        return Icons.emoji_events;
      case 'diamond':
        return Icons.diamond;
      default:
        return Icons.person;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'لوحة تحكم الأدمن',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
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
        actions: [
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: _loadUsers,
            ),
          ),
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: () => _showLogoutDialog(context, authProvider),
            ),
          ),
        ],
      ),
      body: SafeArea(child:  Column(
        children: [
          // شريط البحث والفلاتر
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey.shade900 : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'بحث بالاسم أو رقم الهاتف...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                  ),
                  style: TextStyle(color: isDark ? Colors.white : Colors.black),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                      _applyFilter();
                    });
                  },
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('الكل', Colors.blue),
                      const SizedBox(width: 8),
                      _buildFilterChip('فضي', const Color(0xFFC0C0C0)),
                      const SizedBox(width: 8),
                      _buildFilterChip('ذهبي', const Color(0xFFFFD700)),
                      const SizedBox(width: 8),
                      _buildFilterChip('ألماسي', const Color(0xFFB9F2FF)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // إحصائيات سريعة
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.people,
                    value: '${_users.length}',
                    label: 'إجمالي المستخدمين',
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.emoji_events,
                    value: '${_users.where((u) => u['package'] != null).length}',
                    label: 'باقات مميزة',
                    color: Colors.amber,
                  ),
                ),
              ],
            ),
          ),

          // قائمة المستخدمين
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                ? _buildErrorState()
                : _filteredUsers.isEmpty
                ? _buildEmptyState(isDark)
                : RefreshIndicator(
              onRefresh: _loadUsers,
              color: AppColors.primary,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _filteredUsers.length,
                itemBuilder: (context, index) {
                  final user = _filteredUsers[index];
                  return _buildUserCard(user, isDark);
                },
              ),
            ),
          ),
        ],
      ),
      )
    );
  }

  Widget _buildFilterChip(String label, Color color) {
    final isSelected = _selectedFilter == label;

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) {
        setState(() {
          _selectedFilter = label;
          _applyFilter();
        });
      },
      backgroundColor: Colors.grey.shade200,
      selectedColor: color.withOpacity(0.3),
      checkmarkColor: color,
      labelStyle: TextStyle(
        color: isSelected ? color : Colors.grey.shade700,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade800 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.white60 : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard(Map<String, dynamic> user, bool isDark) {
    final name = user['name'] ?? 'بدون اسم';
    final phone = user['phone'] ?? '';
    final package = user['package'];
    final packageColor = _getPackageColor(package);
    final packageName = _getPackageName(package);
    final packageIcon = _getPackageIcon(package);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade900 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [packageColor, packageColor.withOpacity(0.7)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      name.isNotEmpty ? name[0].toUpperCase() : '?',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: packageColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: packageColor.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(packageIcon, size: 12, color: packageColor),
                            const SizedBox(width: 4),
                            Text(
                              packageName,
                              style: TextStyle(
                                fontSize: 10,
                                color: packageColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.phone,
                          size: 16,
                          color: phone.isNotEmpty ? Colors.green : Colors.grey,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            phone.isNotEmpty ? phone : 'رقم غير متوفر',
                            style: TextStyle(
                              fontSize: 14,
                              color: phone.isNotEmpty
                                  ? (isDark ? Colors.white : Colors.black87)
                                  : Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                if (phone.isNotEmpty)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.save_alt, color: Colors.green),
                      onPressed: () => _saveToContacts(name, phone, package),
                      tooltip: 'حفظ في جهات الاتصال',
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 80,
            color: isDark ? Colors.white24 : Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'لا يوجد مستخدمين',
            style: TextStyle(
              fontSize: 18,
              color: isDark ? Colors.white70 : Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'لم يتم العثور على أي مستخدم',
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white54 : Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _loadUsers,
            icon: const Icon(Icons.refresh),
            label: const Text('تحديث'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'حدث خطأ',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              _errorMessage ?? 'حاول مرة أخرى',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _loadUsers,
            icon: const Icon(Icons.refresh),
            label: const Text('إعادة المحاولة'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, AuthProvider authProvider) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('تسجيل الخروج'),
        content: const Text('هل أنت متأكد من تسجيل الخروج؟'),
        backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              await authProvider.signOut();
              if (mounted) {
                Navigator.pop(context);
              }
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
}