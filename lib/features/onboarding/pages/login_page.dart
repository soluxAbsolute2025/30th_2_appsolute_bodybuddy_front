import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../../../api/dio_client.dart'; // DioClient 경로 확인
import '../../../../pages/main_page.dart'; // 메인 페이지 경로 확인
import 'welcome_flow_page.dart';
import '../../../common/common.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  final Dio _dio = DioClient.dio;

  // 🖐️ [로그인 버튼 클릭 시 실행]
  Future<void> _login() async {
    final loginId = _idController.text.trim();
    final password = _passwordController.text.trim();

    if (loginId.isEmpty || password.isEmpty) {
      _showSnackBar("아이디와 비밀번호를 입력해주세요.");
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 1. 로그인 요청 (ID/PW 전송)
      final response = await _dio.post(
        '/api/users/login',
        data: {"loginId": loginId, "password": password},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        // 토큰 파싱 (구조에 따라 수정: data['accessToken'] 등)
        String? accessToken = data['accessToken'] ?? data['data']?['accessToken'];

        if (accessToken != null) {
          // 2. 토큰 저장 (필수!)
          await Common.setToken(accessToken);
          print("🔑 [로그인 성공] 토큰 발급 완료.");

          // 3. 🔥 [핵심 분기점] 닉네임 있는지 확인하러 감!
          await _checkUserInfoAndRedirect();
        } else {
          _showSnackBar("토큰이 반환되지 않았습니다.");
        }
      }
    } on DioException catch (e) {
      // 로그인 실패 (비번 틀림 등)
      print("🔥 로그인 실패: ${e.response?.statusCode}");
      if (e.response?.statusCode == 400 || e.response?.statusCode == 401) {
        _showSnackBar("아이디 또는 비밀번호를 확인해주세요.");
      } else {
        _showSnackBar("로그인 중 오류가 발생했습니다.");
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // 🚀 [회원 정보 조회 및 납치 로직]
  Future<void> _checkUserInfoAndRedirect() async {
    try {
      print("🔎 [분기 확인] 닉네임 정보 조회 중...");

      // 토큰은 헤더에 자동 포함됨
      final response = await _dio.get('/api/users');

      if (response.statusCode == 200) {
        final data = response.data;
        final String? nickname = data['data']?['nickname'];

        // A. 닉네임이 있다 -> 메인 화면으로
        if (nickname != null && nickname.isNotEmpty && nickname != "null") {
          print("✅ 닉네임 있음($nickname) -> 메인 페이지로 이동");
          _moveToPage(const MainPage());
        }
        // B. 닉네임이 없다 -> 플로우 화면으로
        else {
          print("🆕 닉네임 없음 -> 온보딩 플로우(입력) 화면으로 이동");
          _moveToPage(const OnboardingFlowScreen());
        }
      }
    } on DioException catch (e) {
      // 🚨 C. 500 에러 (정보가 없어서 서버가 터짐) -> 플로우 화면으로
      if (e.response?.statusCode == 500) {
        print("🔥 [서버 500] 정보 없음으로 간주 -> 온보딩 플로우 화면으로 이동");
        _moveToPage(const OnboardingFlowScreen());
      } else {
        // 그 외 에러는 로그만 찍고, 일단 플로우로 보내거나 에러 표시 (여기선 안전하게 플로우로)
        print("⚠️ 기타 에러 -> 온보딩 플로우 화면으로 이동");
        _moveToPage(const OnboardingFlowScreen());
      }
    }
  }

  void _moveToPage(Widget page) {
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => page),
          (route) => false, // 뒤로가기 다 지워버림
    );
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("로그인")),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _idController,
              decoration: const InputDecoration(labelText: "아이디"),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "비밀번호"),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _login, // 로딩 중이면 버튼 비활성
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00E676),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("로그인", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}