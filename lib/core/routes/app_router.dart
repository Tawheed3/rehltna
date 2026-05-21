// ==================== app_router.dart ====================
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/providers/auth_provider.dart';
import '../../data/providers/base_provider.dart';
import '../../data/services/notification_service.dart';
import '../../screens/auth/forgot_password_screen.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/signup_screen.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/home/search_screen.dart';
import '../../screens/home/special_offers_screen.dart';
import '../../screens/past_trips/past_trips_screen.dart';
import '../../screens/posts/item_details_screen.dart';
import '../../screens/profile/profile_screen.dart';
import '../../screens/settings/settings_screen.dart';
import '../../screens/dashboard/admin_dashboard_screen.dart';
import '../../screens/category/category_screen.dart';
import '../../screens/category/subcategory_screen.dart';
import '../../screens/splash/splash_screen.dart';
import '../constants/app_colors.dart';
import 'app_routes.dart';

class AppRouter {
  final AuthProvider authProvider;

  AppRouter({required this.authProvider});

  late final GoRouter router = GoRouter(
    navigatorKey: NotificationService.navigatorKey,
    initialLocation: AppRoutes.splash,
    refreshListenable: authProvider,

    redirect: (BuildContext context, GoRouterState state) {
      final isLoggedIn = authProvider.isLoggedIn;
      final location = state.matchedLocation;

      // الصفحات العامة التي لا تحتاج تسجيل دخول
      final publicPages = [
        AppRoutes.splash,
        AppRoutes.login,
        AppRoutes.signup,
        AppRoutes.forgotPassword,
        AppRoutes.about,
        AppRoutes.contact,
      ];

      final isPublicPage = publicPages.contains(location);

      developer.log('[Router] location=$location | loggedIn=$isLoggedIn | public=$isPublicPage', name: BaseProvider.logTag);

      // إذا لم يكن مسجل دخول ويحاول دخول صفحة خاصة → يروح للوجين
      if (!isLoggedIn && !isPublicPage) {
        developer.log('[Router] Redirecting to login', name: BaseProvider.logTag);
        return AppRoutes.login;
      }

      // إذا كان مسجل دخول ويحاول دخول صفحة عامة (ما عدا السبيلاش) → يروح للهوم
      if (isLoggedIn && isPublicPage && location != AppRoutes.splash) {
        developer.log('[Router] Already logged in — redirecting to home', name: BaseProvider.logTag);
        return AppRoutes.home;
      }

      return null;
    },

    routes: [
      // ==================== صفحات عامة ====================
      GoRoute(
        path: AppRoutes.splash,
        name: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        name: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.signup,
        name: AppRoutes.signup,
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        name: AppRoutes.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      // ==================== صفحات رئيسية (تتطلب تسجيل دخول) ====================
      GoRoute(
        path: AppRoutes.home,
        name: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        name: AppRoutes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.profile,
        name: AppRoutes.profile,
        pageBuilder: (context, state) {
          return MaterialPage(
            key: state.pageKey,
            child: const ProfileScreen(),
          );
        },
      ),

      GoRoute(
        path: AppRoutes.adminDashboard,
        name: AppRoutes.adminDashboard,
        builder: (context, state) => const AdminDashboardScreen(),
      ),

      // ==================== صفحات البحث والرحلات ====================
      GoRoute(
        path: AppRoutes.search,
        name: AppRoutes.search,
        pageBuilder: (context, state) {
          return MaterialPage(
            key: state.pageKey,
            child: const SearchScreen(),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.pastTrips,
        name: AppRoutes.pastTrips,
        pageBuilder: (context, state) {
          return MaterialPage(
            key: state.pageKey,
            child: const PastTripsScreen(),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.specialOffers,
        name: AppRoutes.specialOffers,
        pageBuilder: (context, state) {
          return MaterialPage(
            key: state.pageKey,
            child: const SpecialOffersScreen(),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.groupTours,
        name: AppRoutes.groupTours,
        pageBuilder: (context, state) {
          return MaterialPage(
            key: state.pageKey,
            child: const Scaffold(
              body: Center(child: Text('الرحلات الجماعية - قريباً')),
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.posts,
        name: AppRoutes.posts,
        pageBuilder: (context, state) {
          return MaterialPage(
            key: state.pageKey,
            child: const Scaffold(
              body: Center(child: Text('المقالات - قريباً')),
            ),
          );
        },
      ),

      // ==================== صفحات ديناميكية ====================
      // تفاصيل الرحلة (تستقبل itemId)
      GoRoute(
        path: '${AppRoutes.details}/:itemId',
        name: AppRoutes.details,
        builder: (context, state) {
          final itemId = int.tryParse(state.pathParameters['itemId'] ?? '0') ?? 0;
          return ItemDetailsScreen(
            itemId: itemId,
            categoryColor: AppColors.primary,
          );
        },
      ),

      // صفحة القسم (تستقبل sectionId)
      GoRoute(
        path: '${AppRoutes.category}/:sectionId',
        name: AppRoutes.category,
        builder: (context, state) {
          final sectionId = state.pathParameters['sectionId'] ?? '';
          final extra = state.extra as Map<String, dynamic>?;

          return CategoryScreen(
            sectionId: sectionId,
            title: extra?['title'] ?? 'القسم',
            color: Color(extra?['colorValue'] ?? AppColors.primary.value),
          );
        },
      ),
    ],

    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'حدث خطأ في التوجيه',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              '${state.error}',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                router.go(AppRoutes.home);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('العودة للرئيسية'),
            ),
          ],
        ),
      ),
    ),
  );
}