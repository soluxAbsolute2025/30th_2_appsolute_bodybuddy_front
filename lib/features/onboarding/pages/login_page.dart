import 'package:flutter/material.dart';
import 'package:dio/dio.dart'; // Dio 패키지 사용
import '../../../../api/dio_client.dart'; // ✅ DioClient import (경로 확인해주세요!)
import '../../../../pages/main_page.dart';
import 'welcome_flow_page.dart'; // 혹은 onboarding_page.dart
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

  // ✅ [핵심] DioClient 사용 (토큰 자동 관리)
  final Dio _dio = DioClient.dio;

  Future<void> _login() async {
    final loginId = _idController.text.trim();
    final password = _passwordController.text.trim();

    if (loginId.isEmpty || password.isEmpty) {
      _showSnackBar("아이디와 비밀번호를 모두 입력해주세요.");
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 1. 로그인 요청
      // (로그인은 토큰이 필요 없으므로 DioClient 써도 되고 그냥 Dio 써도 되지만 통일성 위해 사용)
      final response = await _dio.post(
        '/api/users/login',
        data: {
          "loginId": loginId,
          "password": password
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        // 응답 구조에 따라 accessToken 위치 확인 (data['accessToken'] 또는 data['data']['accessToken'])
        String? accessToken = data['accessToken'] ?? data['data']?['accessToken'];

        if (accessToken != null) {
          // 2. 토큰 저장 (필수!)
          await Common.setToken(accessToken);
          print("🔑 로그인 성공! 토큰 저장 완료.");

          // 3. 회원 정보 조회하여 갈 곳 정하기
          await _checkUserInfoAndRedirect();
        } else {
          _showSnackBar("로그인 성공했으나 토큰이 없습니다.");
        }
      }
    } on DioException catch (e) {
      // 400, 401, 500 에러 등 처리
      print("🔥 로그인 실패: ${e.response?.statusCode} / ${e.response?.data}");
      String msg = "로그인에 실패했습니다.";
      if (e.response?.statusCode == 400 || e.response?.statusCode == 401) {
        msg = "아이디 또는 비밀번호를 확인해주세요.";
      }
      _showSnackBar(msg);
    } catch (e) {
      print("🔥 기타 에러: $e");
      _showSnackBar("알 수 없는 오류가 발생했습니다.");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // 🚀 [회원 정보 조회 및 분기 처리]
  // 명세서 이미지(d7cd14.png)에 따라 '/api/users' 호출
  Future<void> _checkUserInfoAndRedirect() async {
    try {
      print("🔎 회원 정보 조회 시작 (/api/users)...");

      // ✅ DioClient가 헤더에 토큰을 자동으로 넣어줍니다.
      final response = await _dio.get('/api/users');

      if (response.statusCode == 200) {
        // ✅ JSON 구조 이미지(d7cfc0.png)에 맞춘 파싱
        // { "status": 200, "data": { "nickname": "김눈송", ... } }
        final Map<String, dynamic> responseData = response.data;
        final Map<String, dynamic>? dataObj = responseData['data'];

        // nickname 확인
        final String? nickname = dataObj?['nickname'];

        print("🔎 조회된 닉네임: $nickname");

        _navigateBasedOnNickname(nickname);
      } else {
        // 200이 아닌 경우 (예: 정보 없음) -> 온보딩으로
        print("⚠️ 회원 정보 조회 실패 (Status: ${response.statusCode})");
        _navigateBasedOnNickname(null);
      }
    } catch (e) {
      print("🔥 회원 정보 조회 중 에러: $e");
      // 에러가 나면 안전하게 온보딩으로 보내거나, 재시도 안내
      _navigateBasedOnNickname(null);
    }
  }

  void _navigateBasedOnNickname(String? nickname) {
    if (!mounted) return;

    if (nickname != null && nickname.isNotEmpty && nickname != "null") {
      print("✅ 닉네임 있음 ($nickname) -> 메인 페이지로 이동");
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MainPage()),
            (route) => false,
      );
    } else {
      print("🆕 닉네임 없음 -> 온보딩(프로필 설정) 페이지로 이동");
      // WelcomeFlowPage 또는 OnboardingFlowScreen 등 본인 파일명에 맞게 수정
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingFlowScreen()),
            (route) => false,
      );
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("로그인")),
      body: SafeArea(
        child: Padding(
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
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _login,
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
      ),
    );
  }
}