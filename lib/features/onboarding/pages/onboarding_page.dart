// 파일 위치: lib/features/onboarding/pages/onboarding_page.dart
import 'package:flutter/material.dart';
import '../../../../pages/main_page.dart';
import 'login_page.dart';
import 'start_page.dart';

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

    // 화면 크기에 따른 동적 사이즈 조절
    final double initialIconSize = size.width * 0.6; // 초기 캐릭터 크기
    final double finalIconSize = size.width * 0.20; // 줄어든 캐릭터 크기

    // 로고와 동일한 민트색 포인트 컬러
    const Color pointColor = Color(0xFF00E6BD);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.center,
        children: [

          // ---------------------------------------------------------
          // 1. 캐릭터 아이콘
          // ---------------------------------------------------------
          AnimatedPositioned(
            duration: const Duration(milliseconds: 1000),
            curve: Curves.elasticOut,
            // [수정] 초기 상태일 때(false) 화면 정중앙(세로) 위치 계산
            // (전체 높이 - 아이콘 크기) / 2 = 정중앙 Top 좌표
            top: _isConverted
                ? size.height * 0.22
                : (size.height - initialIconSize) / 2,

            // [수정] 초기 상태일 때(false) 화면 정중앙(가로) 위치 계산
            left: _isConverted
                ? 40
                : (size.width - initialIconSize) / 2,

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
                  // [수정] 이미지가 컨테이너 안에서 한쪽으로 쏠리지 않게 center로 변경
                  alignment: Alignment.center,
                ),
              ),
            ),
          ),

          // ---------------------------------------------------------
          // 2. 터치 유도 텍스트 (초기 화면)
          // ---------------------------------------------------------
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            // 캐릭터 밑에 적당히 위치하도록 조정 (화면의 75% 지점)
            top: size.height * 0.75,
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
                  Icon(Icons.touch_app, color: pointColor),
                ],
              ),
            ),
          ),

          // ---------------------------------------------------------
          // 3. BodyBuddy 로고 텍스트 (변환 후 등장)
          // ---------------------------------------------------------
          AnimatedPositioned(
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutBack,
            top: size.height * 0.33,
            left: 40,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              opacity: _isConverted ? 1.0 : 0.0,
              child: Image.asset(
                'assets/images/common/BodyBuddy_logo.png',
                width: 180,
                fit: BoxFit.contain,
                alignment: Alignment.centerLeft,
              ),
            ),
          ),

          // ---------------------------------------------------------
          // 4. 슬로건 이미지 (변환 후 등장)
          // ---------------------------------------------------------
          AnimatedPositioned(
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOut,
            top: size.height * 0.41,
            left: 40,
            right: 20,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 600),
              opacity: _isConverted ? 1.0 : 0.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/common/onboarding_logo.png',
                    height: 80,
                    fit: BoxFit.contain,
                    alignment: Alignment.centerLeft,
                  ),
                ],
              ),
            ),
          ),

          // ---------------------------------------------------------
          // 5. 하단 버튼 영역 (변환 후 등장)
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
                // [시작하기 버튼] -> StartPage로 이동
                SizedBox(
                  height: 56,
                  width: 600,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const StartPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: pointColor,
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

                // [로그인 텍스트] -> LoginPage로 이동
                GestureDetector(
                  onTap: () {
                    // [수정] MainPage 대신 LoginPage로 이동하도록 변경
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginPage()),
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
                              color: pointColor,
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