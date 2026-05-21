import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routes/app_routes.dart';
import '../../data/providers/auth_provider.dart';
import '../../data/providers/items_provider.dart';
import '../../data/providers/settings_provider.dart';
import '../../data/providers/features_provider.dart';
import '../../data/services/settings_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  bool _showButton = false;

  @override
  void initState() {
    super.initState();

    // تهيئة الأنيميشن
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // ✅ تحميل البيانات في الخلفية (من غير ما نستنى)
    Future.microtask(() {
      _loadDataInBackground();
    });

    // ✅ إظهار الزر بعد 2 ثواني بالظبط
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _showButton = true;
        });
      }
    });
  }

  Future<void> _loadDataInBackground() async {
    try {
      final itemsProvider = Provider.of<ItemsProvider>(context, listen: false);
      final settingsProvider =
      Provider.of<SettingsProvider>(context, listen: false);
      final featuresProvider =
      Provider.of<FeaturesProvider>(context, listen: false);

      // ✅ تحميل كل البيانات بالتوازي
      await Future.wait([
        itemsProvider.fetchItems(),
        itemsProvider.fetchItemTypes(),
        settingsProvider.fetchSettings(),
        featuresProvider.fetchFeatures(),
      ]);

      // ✅ توزيع الرحلات على الأقسام
      await itemsProvider.loadAllItemsIntoCategories();

      developer.log('[Splash] All data loaded and distributed', name: 'Response-output');
    } catch (e) {
      developer.log('[Splash] Error loading data: $e', name: 'Response-output', level: 900);
    }
  }

  void _goToNextScreen() {
    if (mounted) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      if (authProvider.isLoggedIn) {
        context.go(AppRoutes.home);
      } else {
        context.go(AppRoutes.login);
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final settingsService = Provider.of<SettingsService>(context);
    final isDark = settingsService.isDarkMode;
    final siteName =
        settingsProvider.settings?.getSiteName(settingsService.languageCode) ??
            'رحلتنا';

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // اللوجو النابض
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/rehlatnalogo.jpeg',
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.travel_explore,
                            size: 80,
                            color: AppColors.primary,
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 40),

            // جملة تشويقية
            Text(
              'رحلتك تبدأ من هنا',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
                letterSpacing: 1,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              siteName,
              style: TextStyle(
                fontSize: 16,
                color: isDark ? Colors.white70 : Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 80),

            // زر ابدأ رحلتك - يظهر بعد 5 ثواني
            if (_showButton)
              ElevatedButton(
                onPressed: _goToNextScreen,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 4,
                ),
                child: const Text(
                  'ابدأ رحلتك',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}