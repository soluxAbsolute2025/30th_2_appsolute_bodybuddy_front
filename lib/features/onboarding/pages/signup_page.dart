// 파일 위치: lib/features/onboarding/pages/signup_page.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'login_page.dart'; // [수정] 로그인 페이지로 이동하기 위해 임포트

class SignUpFormScreen extends StatefulWidget {
  const SignUpFormScreen({super.key});

  @override
  State<SignUpFormScreen> createState() => _SignUpFormScreenState();
}

class _SignUpFormScreenState extends State<SignUpFormScreen> {
  // 서버 주소
  static const String baseUrl = "http://52.79.228.227:8080";

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  String? _selectedDomain;
  final List<String> _domains = ['naver.com', 'gmail.com', 'daum.net', 'sookmyung.ac.kr'];

  bool _isFormValid = false;
  bool _isIdVerified = false;

  @override
  void initState() {
    super.initState();
    _usernameController.addListener(() {
      if (_isIdVerified) {
        setState(() {
          _isIdVerified = false; // 아이디 수정 시 중복확인 초기화
        });
      }
      _updateFormState();
    });
    _passwordController.addListener(_updateFormState);
    _passwordConfirmController.addListener(_updateFormState);
    _emailController.addListener(_updateFormState);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _updateFormState() {
    setState(() {
      _isFormValid = _usernameController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty &&
          _passwordConfirmController.text.isNotEmpty &&
          _emailController.text.isNotEmpty &&
          _selectedDomain != null &&
          _isIdVerified;
    });
  }

  // [API] 아이디 중복 확인
  Future<void> _checkIdDuplicate() async {
    final loginId = _usernameController.text.trim();

    if (loginId.length < 4 || loginId.length > 12) {
      _showSnackBar("아이디는 4~12자 사이여야 합니다.");
      return;
    }

    final url = Uri.parse('$baseUrl/api/users/check-id?loginId=$loginId');
    print("🛫 [ID 중복확인 요청] URL: $url");

    try {
      // 2. GET 요청 보내기
      final response = await http.get(url);

      // 🔥🔥🔥 [여기가 핵심!] 서버 응답 로그 찍기 🔥🔥🔥
      print("📥 [응답 상태코드] : ${response.statusCode}");


      final dynamic decodedBody = jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode == 200) {
        setState(() {
          _isIdVerified = true;
        });
        _updateFormState();
        _showSnackBar("사용 가능한 아이디입니다.");
      } else if (response.statusCode == 400) {
        setState(() {
          _isIdVerified = false;
        });
        if (decodedBody is Map && decodedBody.containsKey('message')) {
          _showSnackBar(decodedBody['message']);
        } else {
          _showSnackBar("이미 사용 중인 아이디입니다.");
        }
      } else {
        _showSnackBar("오류 발생: ${response.statusCode}");
      }
    } catch (e) {
      print("🔥 [에러] 중복 확인 중 오류: $e");
      _showSnackBar("서버 연결에 실패했습니다.");
    }
  }

  // [API] 회원가입 요청
  Future<void> _signUp() async {
    if (!_isIdVerified) {
      _showSnackBar("아이디 중복 확인을 해주세요.");
      return;
    }
    if (_passwordController.text != _passwordConfirmController.text) {
      _showSnackBar("비밀번호가 일치하지 않습니다.");
      return;
    }

    final fullEmail = "${_emailController.text.trim()}@$_selectedDomain";
    final url = Uri.parse('$baseUrl/api/users/signup');

    final Map<String, dynamic> requestBody = {
      "loginId": _usernameController.text.trim(),
      "password": _passwordController.text,
      "email": fullEmail,
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      final String responseBodyString = utf8.decode(response.bodyBytes);

      // 성공 처리 (200 OK 또는 201 Created)
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("회원가입 완료! 로그인을 진행해주세요.")),
        );

        // [수정] 가입 성공 시 로그인 페이지로 이동 (뒤로가기 시 가입페이지 안 나오게 pushReplacement)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
      } else {
        // 실패 처리
        String errorMessage = "회원가입에 실패했습니다.";
        try {
          final decoded = jsonDecode(responseBodyString);
          if (decoded is Map && decoded.containsKey('message')) {
            errorMessage = decoded['message'];
          }
        } catch (_) {}
        _showSnackBar(errorMessage);
      }
    } catch (e) {
      print("🔥 [에러] 회원가입 중 오류: $e");
      _showSnackBar("서버 연결 중 오류가 발생했습니다.");
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24, top: 12),
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _isFormValid ? _signUp : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isFormValid ? pointColor : const Color(0xFFE0E0E0),
                foregroundColor: _isFormValid ? Colors.white : Colors.grey,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                '가입하기',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '계정 만들기',
                style: TextStyle(
                    fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 30),

              _buildLabel('아이디'),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      hint: '아이디',
                      controller: _usernameController,
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    height: 52,
                    width: 100,
                    child: ElevatedButton(
                      onPressed: _checkIdDuplicate,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF5F5F5),
                        foregroundColor: Colors.black,
                        elevation: 0,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: const BorderSide(color: Color(0xFFE0E0E0)),
                        ),
                      ),
                      child: const Text('중복 확인', style: TextStyle(fontSize: 12)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (_isIdVerified)
                const Text('사용 가능한 아이디입니다.',
                    style: TextStyle(color: pointColor, fontSize: 11))
              else
                _buildHelperText('4~12자/영문 소문자(숫자 조합 가능)'),

              const SizedBox(height: 24),

              _buildLabel('비밀번호'),
              const SizedBox(height: 8),
              _buildTextField(
                  hint: '비밀번호',
                  controller: _passwordController,
                  obscureText: true),
              const SizedBox(height: 8),
              _buildTextField(
                  hint: '비밀번호 확인',
                  controller: _passwordConfirmController,
                  obscureText: true),
              const SizedBox(height: 8),
              _buildHelperText('6~20자/영문 대문자, 소문자, 숫자, 특수문자 중 2가지 이상 조합'),

              const SizedBox(height: 24),

              _buildLabel('이메일'),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                        hint: '이메일', controller: _emailController),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('@',
                        style: TextStyle(fontSize: 16, color: Colors.grey)),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          hint: const Text('선택',
                              style: TextStyle(color: Colors.grey, fontSize: 13)),
                          value: _selectedDomain,
                          isExpanded: true,
                          icon: const Icon(Icons.keyboard_arrow_down,
                              color: Colors.grey),
                          items: _domains.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value,
                                  style: const TextStyle(fontSize: 14)),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedDomain = newValue;
                            });
                            _updateFormState();
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
          fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black),
    );
  }

  Widget _buildTextField({
    required String hint,
    required TextEditingController controller,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 14),
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildHelperText(String text) {
    return Text(
      text,
      style: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 11),
    );
  }
}