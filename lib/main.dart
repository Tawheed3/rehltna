import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'data/services/notification_service.dart';
import 'data/services/settings_service.dart';
import 'core/localization/app_localizations.dart';
import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';
import 'data/providers/auth_provider.dart';
import 'data/providers/items_provider.dart';
import 'data/providers/features_provider.dart';
import 'data/providers/slider_provider.dart';
import 'data/providers/settings_provider.dart';
import 'data/providers/user_provider.dart';
import 'data/providers/search_provider.dart';
import 'data/providers/payment_methods_provider.dart';
import 'data/providers/pixel_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة Firebase
  await Firebase.initializeApp();

  // تهيئة الإشعارات
  final notificationService = NotificationService();
  await notificationService.init();

  final settingsService = SettingsService();
  await settingsService.init();

  final authProvider = AuthProvider();
  await authProvider.loadToken();

  // إنشاء UserProvider وتمرير AuthProvider له
  final userProvider = UserProvider(authProvider: authProvider);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<SettingsService>.value(value: settingsService),
        ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
        ChangeNotifierProvider<UserProvider>.value(value: userProvider),
        ChangeNotifierProvider(create: (context) => ItemsProvider()),
        ChangeNotifierProvider(create: (context) => FeaturesProvider()),
        ChangeNotifierProvider(create: (context) => SliderProvider()),
        ChangeNotifierProvider(create: (context) => SettingsProvider()),
        ChangeNotifierProvider(create: (context) => SearchProvider()),
        ChangeNotifierProvider(create: (context) => PaymentMethodsProvider()),
        ChangeNotifierProvider(create: (context) => PixelProvider()),
      ],
      child: MyApp(authProvider: authProvider),
    ),
  );
}

class MyApp extends StatelessWidget {
  final AuthProvider authProvider;
  const MyApp({Key? key, required this.authProvider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settingsService = Provider.of<SettingsService>(context);

    return MaterialApp.router(
      title: 'تطبيق رحلات',
      debugShowCheckedModeBanner: false,
      locale: settingsService.locale,
      supportedLocales: const [Locale('ar'), Locale('en')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: settingsService.themeMode,
      routerConfig: AppRouter(authProvider: authProvider).router,
    );
  }
}