import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'features/onboarding/pages/onboarding_page.dart'; // 맨 처음 화면
import 'common/common.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ko_KR', null);

  // 토큰 저장소 초기화 (토큰을 불러오긴 하지만, 앱 시작 때 검사하진 않음)
  await Common.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BodyBuddy',
      theme: ThemeData(
        // ... (기존 테마 설정 유지) ...
        primaryColor: const Color(0xFF00E676),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
        fontFamily: 'Pretendard',
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      // ✅ [중요] 토큰 확인 없이 무조건 온보딩 페이지로 시작!
      home: const OnboardingPage(),
    );
  }
}