import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  // 🛠️ [방법 1] 토큰(JWT) 내부를 까서 닉네임이 있는지 확인하는 함수
  String? _getNicknameFromToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;

      // JWT의 두 번째 부분(Payload)을 디코딩
      final payload = parts[1];
      String normalized = base64Url.normalize(payload);
      String decoded = utf8.decode(base64Url.decode(normalized));

      final Map<String, dynamic> payloadMap = jsonDecode(decoded);
      print("🕵️ 토큰 내부 데이터 확인: $payloadMap");

      // 토큰 안에 'nickname' 혹은 'sub' 등에 닉네임이 있는지 확인
      return payloadMap['nickname'];
    } catch (e) {
      print("⚠️ 토큰 디코딩 실패: $e");
      return null;
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

    try {
      // 1. 로그인 요청
      final loginUrl = Uri.parse('$baseUrl/api/users/login');
      final loginResponse = await http.post(
        loginUrl,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"loginId": loginId, "password": password}),
      );

      if (loginResponse.statusCode == 200) {
        final loginBody = jsonDecode(utf8.decode(loginResponse.bodyBytes));
        String? accessToken = loginBody['accessToken'] ?? loginBody['data']?['accessToken'];

        if (accessToken != null) {
          await Common.setToken(accessToken);
          print("🔑 토큰 획득: $accessToken");

          // -------------------------------------------------------
          // 🚀 [방법 1 시도] 토큰 자체에 닉네임이 있는지 먼저 확인
          // -------------------------------------------------------
          String? nickname = _getNicknameFromToken(accessToken);

          if (nickname != null && nickname.isNotEmpty) {
            print("🎉 토큰 안에서 닉네임 발견! ($nickname)");
            _navigateBasedOnNickname(nickname);
          } else {
            print("🚫 토큰에 닉네임 없음. [방법 2] 내 정보 조회 API 호출 시도...");
            await _fetchMyPageAndRedirect(accessToken);
          }
        } else {
          _showSnackBar("토큰을 찾을 수 없습니다.");
        }
      } else {
        _showSnackBar("로그인 실패: ${loginResponse.statusCode}");
      }
    } catch (e) {
      print("🔥 에러: $e");
      _showSnackBar("오류가 발생했습니다.");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // 🚀 [방법 2] 이미지(image_faa8e2.png) 구조에 맞춰 내 정보 조회
  Future<void> _fetchMyPageAndRedirect(String accessToken) async {
    try {
      final myPageUrl = Uri.parse('$baseUrl/api/users/my-page');
      final response = await http.get(
        myPageUrl,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );

      print("🔎 내 정보 조회 상태코드: ${response.statusCode}");

      if (response.statusCode == 200) {
        final String bodyString = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> json = jsonDecode(bodyString);

        // 📸 이미지(image_faa8e2.png) 분석 결과에 따른 경로 수정
        // 구조: { "userProfile": { "nickname": "..." } }
        String? nickname;

        if (json['userProfile'] != null) {
          nickname = json['userProfile']['nickname'];
        } else if (json['data'] != null) {
          nickname = json['data']['nickname']; // 혹시 모를 대비
        }

        print("🔎 서버에서 찾은 닉네임: $nickname");
        _navigateBasedOnNickname(nickname);

      } else {
        // 조회 실패 시 일단 온보딩으로 보내서 닉네임 설정 유도
        print("⚠️ 내 정보 조회 실패. 온보딩으로 이동");
        _navigateBasedOnNickname(null);
      }
    } catch (e) {
      print("🔥 내 정보 조회 중 에러: $e");
      _navigateBasedOnNickname(null);
    }
  }

  void _navigateBasedOnNickname(String? nickname) {
    if (!mounted) return;

    if (nickname != null && nickname.isNotEmpty && nickname != "null") {
      print("✅ 닉네임 존재 -> 메인 페이지로 이동");
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MainPage()),
            (route) => false,
      );
    } else {
      print("🆕 닉네임 없음 -> 온보딩(닉네임 설정) 페이지로 이동");
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
    // 기존 UI 코드 유지 (생략)
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("로그인")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(controller: _idController, decoration: const InputDecoration(labelText: "아이디")),
              const SizedBox(height: 16),
              TextField(controller: _passwordController, obscureText: true, decoration: const InputDecoration(labelText: "비밀번호")),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  child: _isLoading ? const CircularProgressIndicator() : const Text("로그인"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}