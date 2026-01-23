import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'features/onboarding/pages/onboarding_page.dart';
import 'features/bodylog/pages/diet_tab.dart'; // 혹은 MainPage import
import 'pages/main_page.dart'; // 실제 메인 페이지 import
import 'common/common.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 한국어 날짜 데이터 초기화
  await initializeDateFormatting('ko_KR', null);

  // 👇 [핵심] 여기서 저장된 토큰을 불러옵니다.
  await Common.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 토큰이 잘 로드되었는지 로그로 확인
    bool isLoggedIn = Common.token != null && Common.token!.isNotEmpty;
    print("\n [앱 시작 상태] 토큰 존재 여부: $isLoggedIn / 토큰값: ${Common.token}\n");

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BodyBuddy',

      // ... (ThemeData 부분은 기존 코드 그대로 유지) ...
      theme: ThemeData(
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
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00E676),
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF5F6F8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          hintStyle: const TextStyle(color: Color(0xFFB0B8C1)),
        ),
      ),

      // 👇 [여기가 핵심 변경 포인트!]
      // 토큰이 있으면(로그인 상태면) MainPage, 없으면 OnboardingPage 보여주기
      home: isLoggedIn ? const MainPage() : const OnboardingPage(),
    );
  }
}