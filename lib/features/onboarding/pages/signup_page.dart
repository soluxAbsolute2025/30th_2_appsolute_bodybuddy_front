// 파일 위치: lib/features/onboarding/pages/signup_page.dart
import 'package:flutter/material.dart';
import 'welcome_flow_page.dart';

class SignUpFormScreen extends StatefulWidget {
  const SignUpFormScreen({super.key});

  @override
  State<SignUpFormScreen> createState() => _SignUpFormScreenState();
}

class _SignUpFormScreenState extends State<SignUpFormScreen> {
  // 1. 입력 감지를 위한 컨트롤러 생성
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  // 이메일 도메인 선택 변수
  String? _selectedDomain;
  final List<String> _domains = ['naver.com', 'gmail.com', 'daum.net', '직접 입력'];

  // 2. 버튼 활성화 상태 변수
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    // 입력값이 변경될 때마다 상태 확인
    _usernameController.addListener(_updateFormState);
    _passwordController.addListener(_updateFormState);
    _passwordConfirmController.addListener(_updateFormState);
    _emailController.addListener(_updateFormState);
  }

  @override
  void dispose() {
    // 메모리 누수 방지를 위해 컨트롤러 해제
    _usernameController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // 3. 모든 항목이 채워졌는지 확인하는 함수
  void _updateFormState() {
    setState(() {
      _isFormValid = _usernameController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty &&
          _passwordConfirmController.text.isNotEmpty &&
          _emailController.text.isNotEmpty &&
          _selectedDomain != null; // 도메인까지 선택되어야 함
    });
  }

  @override
  Widget build(BuildContext context) {
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '계정 만들기',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 30),

              // 아이디 섹션
              _buildLabel('아이디'),
              const SizedBox(height: 8),
              _buildTextField(hint: '아이디', controller: _usernameController),
              const SizedBox(height: 8),
              _buildHelperText('4~12자/영문 소문자(숫자 조합 가능)'),

              const SizedBox(height: 24),

              // 비밀번호 섹션
              _buildLabel('비밀번호'),
              const SizedBox(height: 8),
              _buildTextField(hint: '비밀번호', controller: _passwordController, obscureText: true),
              const SizedBox(height: 8),
              _buildTextField(hint: '비밀번호 확인', controller: _passwordConfirmController, obscureText: true),
              const SizedBox(height: 8),
              _buildHelperText('6~20자/영문 대문자, 소문자, 숫자, 특수문자 중 2가지 이상 조합'),

              const SizedBox(height: 24),

              // 이메일 섹션
              _buildLabel('이메일'),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(hint: '이메일', controller: _emailController),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('@', style: TextStyle(fontSize: 16, color: Colors.grey)),
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
                          hint: const Text('선택', style: TextStyle(color: Colors.grey)),
                          value: _selectedDomain,
                          isExpanded: true,
                          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                          items: _domains.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value, style: const TextStyle(fontSize: 14)),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedDomain = newValue;
                            });
                            _updateFormState(); // 도메인 선택 시에도 검사 수행
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 60),

              // 4. 가입하기 버튼 (상태에 따라 색상 변경)
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    // _isFormValid가 true면 초록색, 아니면 회색
                    backgroundColor: _isFormValid ? Colors.green : const Color(0xFFE0E0E0),
                    // 텍스트 색상도 활성화 시 흰색, 아니면 진한 회색
                    foregroundColor: _isFormValid ? Colors.white : const Color(0xFF9E9E9E),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  // 비활성 상태일 때 버튼 클릭을 막으려면 onPressed에 null을 주면 되지만,
                  // 색상 제어를 위해 클릭 이벤트는 두되 동작만 안 하게 처리할 수도 있습니다.
                  // 여기서는 디자인 요구사항(색상 변경)에 맞춰 null 처리합니다.
                  onPressed: _isFormValid
                      ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const OnboardingFlowScreen()),
                    );
                  }
                      : null, // null이면 버튼이 기본 disabled 스타일을 따르려 하므로, 위 styleFrom에서 disabledBackgroundColor 등을 설정하거나
                  // 단순히 조건문으로 처리하는 게 깔끔합니다. 위 style 코드가 우선 적용되도록 아래처럼 수정 가능합니다.
                  child: const Text(
                    '가입하기',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black),
    );
  }

  // Controller를 인자로 받도록 수정
  Widget _buildTextField({
    required String hint,
    required TextEditingController controller,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller, // 컨트롤러 연결
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 14),
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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