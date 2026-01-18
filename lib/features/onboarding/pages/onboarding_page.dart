// 파일 위치: lib/features/onboarding/pages/onboarding_page.dart
import 'package:flutter/material.dart';
import '../../../../pages/main_page.dart';
import 'login_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  // false: 초기 화면 (큰 캐릭터 + 터치 유도)
  // true: 메인 화면 (캐릭터 축소 이동 + 버튼 및 문구 등장)
  bool _isConverted = false;

  void _onCharaterTap() {
    if (!_isConverted) {
      setState(() {
        _isConverted = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // 화면 크기에 따른 동적 사이즈 조절 (Code A의 디자인 유지)
    final double initialIconSize = size.width * 0.6; // 초기 캐릭터 크기
    final double finalIconSize = size.width * 0.25; // 줄어든 캐릭터 크기

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.center,
        children: [

          // ---------------------------------------------------------
          // 1. 캐릭터 아이콘 (Code A의 애니메이션 유지)
          // ---------------------------------------------------------
          AnimatedPositioned(
            duration: const Duration(milliseconds: 1000),
            curve: Curves.elasticOut,
            top: _isConverted ? size.height * 0.18 : size.height * 0.35,
            left: 0,
            right: 0,
            child: GestureDetector(
              onTap: _onCharaterTap,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 1000),
                curve: Curves.elasticOut,
                width: _isConverted ? finalIconSize : initialIconSize,
                height: _isConverted ? finalIconSize : initialIconSize,
                child: Image.asset(
                  'assets/images/common/BodyBuddy_icon.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          // ---------------------------------------------------------
          // 2. 터치 유도 텍스트 (초기 화면에만 보임)
          // ---------------------------------------------------------
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            top: size.height * 0.65,
            left: 0,
            right: 0,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: _isConverted ? 0.0 : 1.0,
              child: const Column(
                children: [
                  Text(
                    "캐릭터를 터치해 주세요!",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Icon(Icons.touch_app, color: Color(0xFF00E676)),
                ],
              ),
            ),
          ),

          // ---------------------------------------------------------
          // 3. BodyBuddy 로고 텍스트 (캐릭터 바로 아래)
          // ---------------------------------------------------------
          AnimatedPositioned(
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutBack,
            top: size.height * 0.33,
            left: 0,
            right: 0,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              opacity: _isConverted ? 1.0 : 0.0,
              child: Center(
                child: Image.asset(
                  'assets/images/common/BodyBuddy_logo.png',
                  width: 140,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          // ---------------------------------------------------------
          // 4. 슬로건 이미지 (Code A 디자인 유지)
          // ---------------------------------------------------------
          AnimatedPositioned(
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOut,
            top: size.height * 0.45,
            left: 20,
            right: 20,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 600),
              opacity: _isConverted ? 1.0 : 0.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/common/onboarding_logo.png',
                    height: 40,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
          ),

          // ---------------------------------------------------------
          // 5. 하단 버튼 영역 (기능 및 클래스명 Code B 적용)
          // ---------------------------------------------------------
          AnimatedPositioned(
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOut,
            bottom: _isConverted ? 40 : -150,
            left: 20,
            right: 20,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // [시작하기 버튼] -> LoginMethodScreen으로 이동 (Code B 로직)
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const LoginMethodScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00E676),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: const Text(
                      "시작하기",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // [로그인 텍스트] -> MainPage로 이동 (Code B 로직)
                GestureDetector(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const MainPage()),
                          (route) => false,
                    );
                  },
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                      children: [
                        TextSpan(text: "이미 계정이 있으신가요? "),
                        TextSpan(
                          text: "로그인",
                          style: TextStyle(
                              color: Color(0xFF00E676),
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}