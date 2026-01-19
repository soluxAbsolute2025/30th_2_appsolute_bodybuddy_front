import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../pages/main_page.dart';
import 'welcome_flow_page.dart';
import '../../../common/common.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static const String baseUrl = "http://52.79.228.227:8080";
  final storage = const FlutterSecureStorage();

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  // 온보딩 정보가 있는지 확인하는 함수
  Future<bool> _checkUserHasInfo(String accessToken) async {
    try {
      final url = Uri.parse('$baseUrl/api/users/onboarding');

      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );

      print("🔎 [온보딩 여부 확인] 상태코드: ${response.statusCode}");

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("⚠️ 온보딩 확인 중 에러: $e");
      return false;
    }
  }

  Future<void> _login() async {
    final loginId = _idController.text.trim();
    final password = _passwordController.text.trim();

    if (loginId.isEmpty || password.isEmpty) {
      _showSnackBar("아이디와 비밀번호를 모두 입력해주세요.");
      return;
    }

    setState(() => _isLoading = true);

    final url = Uri.parse('$baseUrl/api/users/login');
    final Map<String, String> requestBody = {
      "loginId": loginId,
      "password": password,
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      print("📩 [로그인 응답] 상태: ${response.statusCode}");

      final String responseString = utf8.decode(response.bodyBytes);
      final responseBody = jsonDecode(responseString);

      if (response.statusCode == 200) {
        String? accessToken;

        // 토큰 파싱
        if (responseBody is Map && responseBody['data'] != null) {
          final data = responseBody['data'];
          if (data is Map) accessToken = data['accessToken'];
        } else if (responseBody is Map && responseBody['accessToken'] != null) {
          accessToken = responseBody['accessToken'];
        }

        if (accessToken != null) {
          // ▼▼▼ [여기서 토큰 출력] ▼▼▼
          print("\n==================================================");
          print("🔑 [발급된 토큰]:");
          print(accessToken);
          print("==================================================\n");
          // ▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲

          // 1. 토큰 저장
          await Common.setToken(accessToken);

          print("✅ 전역 변수에 토큰 저장됨: ${Common.token}");

          // 2. 온보딩 확인
          bool isExistingUser = await _checkUserHasInfo(accessToken);

          if (!mounted) return;

          if (isExistingUser) {
            print("🚀 기존 유저(온보딩 완료) -> 메인 페이지로 이동");
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const MainPage()),
                  (route) => false,
            );
          } else {
            print("🆕 신규 유저(온보딩 미완료) -> 온보딩 페이지로 이동");
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const OnboardingFlowScreen()),
                  (route) => false,
            );
          }

        } else {
          _showSnackBar("토큰을 찾을 수 없습니다.");
        }
      } else {
        String message = "로그인 실패";
        if (responseBody is Map && responseBody.containsKey('message')) {
          message = responseBody['message'];
        }
        _showSnackBar(message);
      }
    } catch (e) {
      print("🔥 에러 발생: $e");
      _showSnackBar("오류가 발생했습니다.");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color pointColor = Color(0xFF00E6BD);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("로그인", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              TextField(
                controller: _idController,
                decoration: InputDecoration(
                  labelText: "아이디",
                  filled: true,
                  fillColor: const Color(0xFFF5F5F5),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "비밀번호",
                  filled: true,
                  fillColor: const Color(0xFFF5F5F5),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: pointColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white))
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