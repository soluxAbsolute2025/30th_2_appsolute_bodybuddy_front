import 'package:flutter/material.dart';
import '../../../../pages/main_page.dart';
import 'login_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  // false: 초기 화면 (로고 + 심플 시작 버튼)
  // true: 메뉴 화면 (로고 위로 이동 + 민트색 버튼 등장)
  bool _isConverted = false;

  void _onStartPressed() {
    setState(() {
      _isConverted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double iconSize = _isConverted ? 200 : 100;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.center,
        children: [
          // 1. 로고 텍스트 (위치 이동 애니메이션)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOutBack,
            top: _isConverted ? size.height * 0.30 : size.height * 0.40,
            left: 0, right: 0,
            child: Center(
              child: Image.asset(
                'assets/images/common/BodyBuddy_logo.png',
                width: 150,
                fit: BoxFit.contain,
              ),
            ),
          ),

          // 2. 캐릭터 아이콘 (위치 이동 & 크기 변경)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 1000),
            curve: Curves.elasticOut,
            top: _isConverted ? size.height * 0.38 : size.height * 0.28,
            left: 0, right: 0,
            height: iconSize,
            child: Center(
              child: Image.asset(
                'assets/images/common/BodyBuddy_icon.png',
                width: iconSize,
                fit: BoxFit.contain,
              ),
            ),
          ),

          // 3. 텍스트 (페이드 효과)
          Positioned(
            top: size.height * 0.58,
            left: 0, right: 0,
            child: Column(
              children: [
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: _isConverted ? 1.0 : 0.0,
                  child: const Text(
                    "나의 바디, 너의 버디와 함께",
                    style: TextStyle(fontSize: 16, color: Colors.black54, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),

          // 4. [1단계] 초기 '시작하기' 버튼 (수정됨: 2단계와 디자인/위치 통일)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut,
            // 2단계 버튼 위치(bottom 40)와 동일하게 설정
            bottom: 40,
            // 2단계와 똑같이 좌우 꽉 차게 설정
            left: 20,
            right: 20,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              // 변환되면 투명해지면서 사라짐 (뒤에서 2단계 버튼이 올라옴)
              opacity: _isConverted ? 0.0 : 1.0,
              child: IgnorePointer(
                ignoring: _isConverted, // 사라지면 클릭 안되게
                child: SizedBox(
                  width: double.infinity,
                  height: 56, // 2단계 높이와 동일
                  child: ElevatedButton(
                    onPressed: _onStartPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00E676), // 민트색 배경
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // 둥근 모서리
                      elevation: 0,
                    ),
                    child: const Text(
                      "시작하기",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white // 흰색 텍스트
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 5. [2단계] 진짜 메뉴 버튼들 (민트색 버튼 + 로그인)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOut,
            bottom: _isConverted ? 40 : -200, // 2단계 활성화 시 제자리로 올라옴
            left: 20,
            right: 20,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 1단계 버튼과 시각적으로 동일한 버튼 (누르면 페이지 이동)
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginMethodScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00E676),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: const Text(
                      "시작하기",
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 로그인 텍스트
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
                          style: TextStyle(color: Color(0xFF00E676), fontWeight: FontWeight.bold),
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