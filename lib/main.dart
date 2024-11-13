import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'config/theme.dart';
import 'screens/onboarding_screen.dart';
import 'screens/home_screen.dart';
import 'models/user_settings.dart';
import 'dart:convert';

void main() async {
  // 플러터 바인딩 초기화
  WidgetsFlutterBinding.ensureInitialized();

  // 알림 서비스 초기화
  //await NotificationService.initialize();

  // 사용자 설정 로드
  final prefs = await SharedPreferences.getInstance();
  final userSettingsJson = prefs.getString('userSettings');

  // 앱 실행
  runApp(MyApp(
    initialSettings: userSettingsJson != null
        ? UserSettings.fromJson(jsonDecode(userSettingsJson))
        : null,
  ));
}

class MyApp extends StatelessWidget {
  final UserSettings? initialSettings;

  const MyApp({Key? key, this.initialSettings}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '금연 도우미',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: initialSettings != null
          ? HomeScreen(settings: initialSettings!)
          : const OnboardingScreen(),
    );
  }
}