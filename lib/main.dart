import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'features/onboarding/pages/onboarding_page.dart'; // 경로 확인
import 'pages/main_page.dart'; // 경로 확인
import 'common/common.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 한국어 날짜 데이터 초기화
  await initializeDateFormatting('ko_KR', null);

  // ❌ [삭제 필] 이 줄을 지우거나 주석 처리해야 합니다!
  // await Common.storage.deleteAll();

  // ✅ [필수] 이제 토큰을 지우지 말고 '불러오기'만 합니다.
  await Common.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 저장된 토큰이 있는지 확인
    bool isLoggedIn = Common.token != null && Common.token!.isNotEmpty;
    print("🚀 [앱 시작] 로그인 상태: $isLoggedIn (토큰: ${Common.token == null ? '없음' : '있음'})");

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BodyBuddy',
      theme: ThemeData(
        // ... 기존 테마 설정 유지 ...
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
      // 토큰이 있으면 메인, 없으면 온보딩
      home: isLoggedIn ? const MainPage() : const OnboardingPage(),
    );
  }
}