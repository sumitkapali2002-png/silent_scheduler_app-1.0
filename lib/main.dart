import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'services/localization_service.dart';
import 'services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalizationService.loadLanguage();
  await NotificationService.initialize();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = LocalizationService.currentLocale;

  Future<void> changeLanguage(String code) async {
    await LocalizationService.setLanguage(code);
    if (mounted) {
      setState(() {
        _locale = LocalizationService.currentLocale;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Silent Scheduler',
      locale: _locale,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF3EFF7),
        cardTheme: CardThemeData(
          elevation: 2,
          color: const Color(0xFFF1EEF5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
        ),
      ),
      home: HomeScreen(
        onLanguageChanged: changeLanguage,
      ),
    );
  }
}