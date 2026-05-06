import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/providers/auth_provider.dart';
import '../../data/providers/base_provider.dart';
import '../../screens/auth/forgot_password_screen.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/signup_screen.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/home/search_screen.dart';
import '../../screens/home/special_offers_screen.dart';
import '../../screens/past_trips/past_trips_screen.dart';
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
    // ✅ المسار الأولي هو splash
    initialLocation: AppRoutes.splash,
    refreshListenable: authProvider,

    redirect: (BuildContext context, GoRouterState state) {
      final isLoggedIn = authProvider.isLoggedIn;
      final location = state.matchedLocation;

      // الصفحات التي لا تحتاج تسجيل دخول
      final publicPages = [
        AppRoutes.splash,
        AppRoutes.login,
        AppRoutes.signup,
        AppRoutes.forgotPassword,
      ];

      final isPublicPage = publicPages.contains(location);

      developer.log('[Router] location=$location | loggedIn=$isLoggedIn | public=$isPublicPage', name: BaseProvider.logTag);

      if (!isLoggedIn && !isPublicPage) {
        developer.log('[Router] Redirecting to login', name: BaseProvider.logTag);
        return AppRoutes.login;
      }

      if (isLoggedIn && isPublicPage && location != AppRoutes.splash) {
        developer.log('[Router] Already logged in — redirecting to home', name: BaseProvider.logTag);
        return AppRoutes.home;
      }

      return null;
    },

    routes: [
      // Splash route - المسار الأول
      GoRoute(
        path: AppRoutes.splash,
        name: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        name: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
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

      GoRoute(
        path: AppRoutes.settings,
        name: AppRoutes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
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
        name: 'pastTrips',
        pageBuilder: (context, state) {
          return MaterialPage(
            key: state.pageKey,
            child: const PastTripsScreen(),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.specialOffers,
        name: 'specialOffers',
        pageBuilder: (context, state) {
          return MaterialPage(
            key: state.pageKey,
            child: const SpecialOffersScreen(),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.profile,
        name: 'profile',
        pageBuilder: (context, state) {
          return MaterialPage(
            key: state.pageKey,
            child: const ProfileScreen(),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.adminDashboard,
        name: 'adminDashboard',
        builder: (context, state) => const AdminDashboardScreen(),
      ),
      GoRoute(
        path: '/category/:sectionId',
        name: 'category',
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
      GoRoute(
        path: '/subcategory/:categoryId',
        name: 'subcategory',
        builder: (context, state) {
          final categoryId = int.tryParse(state.pathParameters['categoryId'] ?? '0') ?? 0;
          final extra = state.extra as Map<String, dynamic>?;

          return SubcategoryScreen(
            categoryId: categoryId,
            title: extra?['title'] ?? 'القسم',
            color: Color(extra?['colorValue'] ?? AppColors.primary.value),
          );
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Error: ${state.error}'),
      ),
    ),
  );
}