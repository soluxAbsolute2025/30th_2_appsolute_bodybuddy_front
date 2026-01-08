import 'package:flutter/material.dart';
import 'signup_page.dart'; // 회원가입 폼 연결

class LoginMethodScreen extends StatelessWidget {
  const LoginMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(), // 뒤로가기 버튼 자동 생성
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '안녕하세요\nBodyBuddy 입니다',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              '건강한 라이프스타일을 함께\n만들어 가볼까요?',
              style: TextStyle(color: Colors.grey, height: 1.5),
            ),
            const Spacer(),

            // 이메일로 시작하기
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SignUpFormScreen())
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[400], // 회색 버튼
              ),
              child: const Text('이메일로 시작하기'),
            ),
            const SizedBox(height: 12),

            // 구글 로그인 (껍데기)
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.g_mobiledata, size: 30),
                  SizedBox(width: 8),
                  Text('Google로 시작하기', style: TextStyle(color: Colors.black)),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}