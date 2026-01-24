import 'package:flutter/material.dart';
import 'features/onboarding/pages/onboarding_page.dart';
import 'pages/main_page.dart';
import 'common/common.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Common.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    print("\n [앱 시작 토큰 확인]: ${Common.token}\n");
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BodyBuddy',

      // 👇 설정해주신 예쁜 테마 디자인
      theme: ThemeData(
        primaryColor: const Color(0xFF00E676), // 바디버디 시그니처 민트색
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
        fontFamily:
            'Pretendard', // (참고: pubspec.yaml에 폰트 등록이 안 되어 있으면 기본 폰트로 나옵니다)
        // 상단 앱바 스타일
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

        // 버튼 스타일 (모든 버튼에 공통 적용됨)
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00E676),
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 56), // 버튼 높이 56으로 통일
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // 입력창 스타일 (회원가입/로그인 시 사용)
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

      // 👇 앱 시작 페이지를 'OnboardingPage'로 설정
      home: const OnboardingPage(),
    );
  }
}
