import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'app_title': 'Task Manager',
      'save': 'Save',
      'cancel': 'Cancel',
      'edit': 'Edit',
      'delete': 'Delete',
      'confirm': 'Confirm',
      'yes': 'Yes',
      'no': 'No',
      'ok': 'OK',
      'loading': 'Loading...',
      'error': 'Error',
      'success': 'Success',
      'folders': 'Folders',
      'add_folder': 'Add Folder',
      'edit_folder': 'Edit Folder',
      'delete_folder': 'Delete Folder',
      'folder_name': 'Folder Name',
      'enter_folder_name': 'Enter folder name',
      'folder_added': 'Folder added successfully',
      'folder_updated': 'Folder updated successfully',
      'folder_deleted': 'Folder deleted',
      'edit_or_delete_folder': 'Do you want to edit or delete this folder?',
      'no_folders': 'No folders yet',
      'add_first_folder': 'Tap + to add your first folder',
      'tasks': 'Tasks',
      'add_task': 'Add Task',
      'edit_task': 'Edit Task',
      'task_title': 'Task Title',
      'task_description': 'Description (optional)',
      'enter_task_title': 'Enter task title',
      'task_added': 'Task added successfully',
      'task_updated': 'Task updated successfully',
      'task_deleted': 'Task deleted',
      'edit_or_delete_task': 'Do you want to edit or delete this task?',
      'no_tasks': 'No tasks yet',
      'add_first_task': 'Tap + to add your first task',
      'completed': 'Completed',
      'not_completed': 'Not Completed',
      'mark_completed': 'Mark as completed',
      'mark_incomplete': 'Mark as incomplete',
      'created_on': 'Created on',
      'completed_on': 'Completed on',
      'login': 'Login',
      'signup': 'Sign Up',
      'email': 'Email',
      'password': 'Password',
      'confirm_password': 'Confirm Password',
      'full_name': 'Full Name',
      'forgot_password': 'Forgot Password?',
      'login_with_google': 'Login with Google',
      'no_account': "Don't have an account?",
      'have_account': 'Already have an account?',
      'register_here': 'Register here',
      'login_here': 'Login here',
      'invalid_email': 'Invalid email address',
      'weak_password': 'Password is too weak',
      'email_already_in_use': 'Email already in use',
      'user_not_found': 'User not found',
      'wrong_password': 'Wrong password',
      'verify_email': 'Please verify your email',
      'reset_password': 'Reset Password',
      'send_reset_link': 'Send Reset Link',
      'settings': 'Settings',
      'language': 'Language',
      'arabic': 'Arabic',
      'english': 'English',
      'theme': 'Theme',
      'light_theme': 'Light Theme',
      'dark_theme': 'Dark Theme',
      'system_theme': 'System Theme',
      'notifications': 'Notifications',
      'enable_notifications': 'Enable Notifications',
      'about': 'About',
      'version': 'Version',
      'logout': 'Logout',
      'logout_confirmation': 'Are you sure you want to logout?',
      'required_field': 'This field is required',
      'password_length': 'Password must be at least 6 characters',
      'passwords_not_match': 'Passwords do not match',
      'enter_valid_email': 'Please enter a valid email',
      'total_tasks': 'Total Tasks',
      'completed_tasks': 'Completed Tasks',
      'pending_tasks': 'Pending Tasks',
      'completion_rate': 'Completion Rate',
      'close': 'Close',
      'delete_failed': 'Delete failed',
      'points': 'Points',
      'add_point': 'Add Point',
      'point_name': 'Point Name',
      'point_added': 'Point added successfully',
      'point_deleted': 'Point deleted',
      'no_points': 'No points yet',
      'add_first_point': 'Add your first point',
      'points_progress': 'Progress',
    },
    'ar': {
      'app_title': 'مدير المهام',
      'save': 'حفظ',
      'cancel': 'إلغاء',
      'edit': 'تعديل',
      'delete': 'حذف',
      'confirm': 'تأكيد',
      'yes': 'نعم',
      'no': 'لا',
      'ok': 'موافق',
      'loading': 'جار التحميل...',
      'error': 'خطأ',
      'success': 'نجاح',
      'folders': 'الفولديرات',
      'add_folder': 'إضافة فولدر',
      'edit_folder': 'تعديل الفولدر',
      'delete_folder': 'حذف الفولدر',
      'folder_name': 'اسم الفولدر',
      'enter_folder_name': 'أدخل اسم الفولدر',
      'folder_added': 'تم إضافة الفولدر بنجاح',
      'folder_updated': 'تم تعديل الفولدر بنجاح',
      'folder_deleted': 'تم حذف الفولدر',
      'edit_or_delete_folder': 'هل تريد تعديل أو حذف هذا الفولدر؟',
      'no_folders': 'لا توجد فولديرات بعد',
      'add_first_folder': 'انقر على + لإضافة فولدرك الأول',
      'tasks': 'المهام',
      'add_task': 'إضافة مهمة',
      'edit_task': 'تعديل المهمة',
      'task_title': 'عنوان المهمة',
      'task_description': 'الوصف (اختياري)',
      'enter_task_title': 'أدخل عنوان المهمة',
      'task_added': 'تم إضافة المهمة بنجاح',
      'task_updated': 'تم تعديل المهمة بنجاح',
      'task_deleted': 'تم حذف المهمة',
      'edit_or_delete_task': 'هل تريد تعديل أو حذف هذه المهمة؟',
      'no_tasks': 'لا توجد مهام بعد',
      'add_first_task': 'انقر على + لإضافة مهمتك الأولى',
      'completed': 'مكتملة',
      'not_completed': 'غير مكتملة',
      'mark_completed': 'تحديد كمكتملة',
      'mark_incomplete': 'تحديد كغير مكتملة',
      'created_on': 'أنشئت في',
      'completed_on': 'اكتملت في',
      'login': 'تسجيل الدخول',
      'signup': 'إنشاء حساب',
      'email': 'البريد الإلكتروني',
      'password': 'كلمة المرور',
      'confirm_password': 'تأكيد كلمة المرور',
      'full_name': 'الاسم الكامل',
      'forgot_password': 'نسيت كلمة المرور؟',
      'login_with_google': 'تسجيل الدخول بـ Google',
      'no_account': 'ليس لديك حساب؟',
      'have_account': 'لديك حساب بالفعل؟',
      'register_here': 'سجل من هنا',
      'login_here': 'سجل الدخول من هنا',
      'invalid_email': 'بريد إلكتروني غير صالح',
      'weak_password': 'كلمة المرور ضعيفة جداً',
      'email_already_in_use': 'البريد الإلكتروني مستخدم بالفعل',
      'user_not_found': 'المستخدم غير موجود',
      'wrong_password': 'كلمة المرور غير صحيحة',
      'verify_email': 'يرجى تأكيد بريدك الإلكتروني',
      'reset_password': 'إعادة تعيين كلمة المرور',
      'send_reset_link': 'إرسال رابط إعادة التعيين',
      'settings': 'الإعدادات',
      'language': 'اللغة',
      'arabic': 'العربية',
      'english': 'الإنجليزية',
      'theme': 'المظهر',
      'light_theme': 'مظهر فاتح',
      'dark_theme': 'مظهر داكن',
      'system_theme': 'تلقائي (حسب النظام)',
      'notifications': 'الإشعارات',
      'enable_notifications': 'تفعيل الإشعارات',
      'about': 'حول التطبيق',
      'version': 'الإصدار',
      'logout': 'تسجيل الخروج',
      'logout_confirmation': 'هل أنت متأكد من تسجيل الخروج؟',
      'required_field': 'هذا الحقل مطلوب',
      'password_length': 'كلمة المرور يجب أن تكون 6 أحرف على الأقل',
      'passwords_not_match': 'كلمات المرور غير متطابقة',
      'enter_valid_email': 'يرجى إدخال بريد إلكتروني صالح',
      'total_tasks': 'إجمالي المهام',
      'completed_tasks': 'المهام المكتملة',
      'pending_tasks': 'المهام المعلقة',
      'completion_rate': 'معدل الإكمال',
      'close': 'إغلاق',
      'delete_failed': 'فشل الحذف',
      'points': 'النقاط',
      'add_point': 'إضافة نقطة',
      'point_name': 'اسم النقطة',
      'point_added': 'تم إضافة النقطة بنجاح',
      'point_deleted': 'تم حذف النقطة',
      'no_points': 'لا توجد نقاط',
      'add_first_point': 'أضف أول نقطة للمهمة',
      'points_progress': 'التقدم',
    },
  };

  String? _getText(String key) {
    return _localizedValues[locale.languageCode]?[key];
  }

  // Getters
  String get appTitle => _getText('app_title') ?? 'Task Manager';
  String get save => _getText('save') ?? 'Save';
  String get cancel => _getText('cancel') ?? 'Cancel';
  String get edit => _getText('edit') ?? 'Edit';
  String get delete => _getText('delete') ?? 'Delete';
  String get confirm => _getText('confirm') ?? 'Confirm';
  String get yes => _getText('yes') ?? 'Yes';
  String get no => _getText('no') ?? 'No';
  String get ok => _getText('ok') ?? 'OK';
  String get loading => _getText('loading') ?? 'Loading...';
  String get error => _getText('error') ?? 'Error';
  String get success => _getText('success') ?? 'Success';
  String get folders => _getText('folders') ?? 'Folders';
  String get addFolder => _getText('add_folder') ?? 'Add Folder';
  String get editFolder => _getText('edit_folder') ?? 'Edit Folder';
  String get deleteFolder => _getText('delete_folder') ?? 'Delete Folder';
  String get folderName => _getText('folder_name') ?? 'Folder Name';
  String get enterFolderName => _getText('enter_folder_name') ?? 'Enter folder name';
  String get folderAdded => _getText('folder_added') ?? 'Folder added successfully';
  String get folderUpdated => _getText('folder_updated') ?? 'Folder updated successfully';
  String get folderDeleted => _getText('folder_deleted') ?? 'Folder deleted';
  String get editOrDeleteFolder => _getText('edit_or_delete_folder') ?? 'Do you want to edit or delete this folder?';
  String get noFolders => _getText('no_folders') ?? 'No folders yet';
  String get addFirstFolder => _getText('add_first_folder') ?? 'Tap + to add your first folder';
  String get tasks => _getText('tasks') ?? 'Tasks';
  String get addTask => _getText('add_task') ?? 'Add Task';
  String get editTask => _getText('edit_task') ?? 'Edit Task';
  String get taskTitle => _getText('task_title') ?? 'Task Title';
  String get taskDescription => _getText('task_description') ?? 'Description (optional)';
  String get enterTaskTitle => _getText('enter_task_title') ?? 'Enter task title';
  String get taskAdded => _getText('task_added') ?? 'Task added successfully';
  String get taskUpdated => _getText('task_updated') ?? 'Task updated successfully';
  String get taskDeleted => _getText('task_deleted') ?? 'Task deleted';
  String get editOrDeleteTask => _getText('edit_or_delete_task') ?? 'Do you want to edit or delete this task?';
  String get noTasks => _getText('no_tasks') ?? 'No tasks yet';
  String get addFirstTask => _getText('add_first_task') ?? 'Tap + to add your first task';
  String get completed => _getText('completed') ?? 'Completed';
  String get notCompleted => _getText('not_completed') ?? 'Not Completed';
  String get markCompleted => _getText('mark_completed') ?? 'Mark as completed';
  String get markIncomplete => _getText('mark_incomplete') ?? 'Mark as incomplete';
  String get createdOn => _getText('created_on') ?? 'Created on';
  String get completedOn => _getText('completed_on') ?? 'Completed on';
  String get login => _getText('login') ?? 'Login';
  String get signup => _getText('signup') ?? 'Sign Up';
  String get email => _getText('email') ?? 'Email';
  String get password => _getText('password') ?? 'Password';
  String get confirmPassword => _getText('confirm_password') ?? 'Confirm Password';
  String get fullName => _getText('full_name') ?? 'Full Name';
  String get forgotPassword => _getText('forgot_password') ?? 'Forgot Password?';
  String get loginWithGoogle => _getText('login_with_google') ?? 'Login with Google';
  String get noAccount => _getText('no_account') ?? "Don't have an account?";
  String get haveAccount => _getText('have_account') ?? 'Already have an account?';
  String get registerHere => _getText('register_here') ?? 'Register here';
  String get loginHere => _getText('login_here') ?? 'Login here';
  String get invalidEmail => _getText('invalid_email') ?? 'Invalid email address';
  String get weakPassword => _getText('weak_password') ?? 'Password is too weak';
  String get emailAlreadyInUse => _getText('email_already_in_use') ?? 'Email already in use';
  String get userNotFound => _getText('user_not_found') ?? 'User not found';
  String get wrongPassword => _getText('wrong_password') ?? 'Wrong password';
  String get verifyEmail => _getText('verify_email') ?? 'Please verify your email';
  String get resetPassword => _getText('reset_password') ?? 'Reset Password';
  String get sendResetLink => _getText('send_reset_link') ?? 'Send Reset Link';
  String get settings => _getText('settings') ?? 'Settings';
  String get language => _getText('language') ?? 'Language';
  String get arabic => _getText('arabic') ?? 'Arabic';
  String get english => _getText('english') ?? 'English';
  String get theme => _getText('theme') ?? 'Theme';
  String get lightTheme => _getText('light_theme') ?? 'Light Theme';
  String get darkTheme => _getText('dark_theme') ?? 'Dark Theme';
  String get systemTheme => _getText('system_theme') ?? 'System Theme';
  String get notifications => _getText('notifications') ?? 'Notifications';
  String get enableNotifications => _getText('enable_notifications') ?? 'Enable Notifications';
  String get about => _getText('about') ?? 'About';
  String get version => _getText('version') ?? 'Version';
  String get logout => _getText('logout') ?? 'Logout';
  String get logoutConfirmation => _getText('logout_confirmation') ?? 'Are you sure you want to logout?';
  String get requiredField => _getText('required_field') ?? 'This field is required';
  String get passwordLength => _getText('password_length') ?? 'Password must be at least 6 characters';
  String get passwordsNotMatch => _getText('passwords_not_match') ?? 'Passwords do not match';
  String get enterValidEmail => _getText('enter_valid_email') ?? 'Please enter a valid email';
  String get totalTasks => _getText('total_tasks') ?? 'Total Tasks';
  String get completedTasks => _getText('completed_tasks') ?? 'Completed Tasks';
  String get pendingTasks => _getText('pending_tasks') ?? 'Pending Tasks';
  String get completionRate => _getText('completion_rate') ?? 'Completion Rate';
  String get close => _getText('close') ?? 'Close';
  String get deleteFailed => _getText('delete_failed') ?? 'Delete failed';
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ar'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}