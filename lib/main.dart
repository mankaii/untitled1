import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './provider/profile_provider.dart';
import 'screens/home_screen.dart';
import 'screens/onboarding_screen.dart';
import 'models/user_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final notificationService = NotificationService();
  await notificationService.initialize();
  await notificationService.scheduleDailyNotifications();

  final prefs = await SharedPreferences.getInstance();
  final userSettingsJson = prefs.getString('userSettings');

  runApp(
    ChangeNotifierProvider(
      create: (_) => ProfileProvider(),
      child: MyApp(
        initialSettings: userSettingsJson != null
            ? UserSettings.fromJson(jsonDecode(userSettingsJson))
            : null,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final UserSettings? initialSettings;

  const MyApp({Key? key, this.initialSettings}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '금연 도우미',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: initialSettings != null
          ? HomeScreen(settings: initialSettings!)
          : const OnboardingScreen(),
    );
  }
}