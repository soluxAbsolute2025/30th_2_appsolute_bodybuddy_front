// 파일 위치: lib/features/onboarding/pages/start_page.dart
import 'package:flutter/material.dart';
import 'signup_page.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    const TextStyle baseTextStyle = TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // 텍스트 + 이미지 로고
            RichText(
              text: TextSpan(
                style: baseTextStyle,
                children: [
                  const TextSpan(text: '안녕하세요\n'),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Image.asset(
                      'assets/images/common/BodyBuddy_logo.png',
                      height: 32,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const TextSpan(text: ' 입니다'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              '건강한 라이프스타일을 함께\n만들어 가볼까요?',
              style: TextStyle(color: Colors.grey, height: 1.5, fontSize: 16),
            ),

            // [수정됨] Spacer를 사용하여 버튼을 아래로 밀어내되...
            const Spacer(),

            // [이메일로 시작하기]
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const SignUpFormScreen()));
                },
                style: ElevatedButton.styleFrom(
                  // [수정됨] 다시 회색으로 변경
                  backgroundColor: Colors.grey[400],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  '이메일로 시작하기',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // [Google로 시작하기]
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                side: const BorderSide(color: Colors.grey),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.g_mobiledata, size: 32, color: Colors.black),
                  SizedBox(width: 8),
                  Text(
                    'Google로 시작하기',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }
}