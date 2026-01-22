import 'dart:convert'; // JSON 처리
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // 키보드 입력 제한용
import 'package:http/http.dart' as http; // API 통신
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // 토큰 관리
import '../../../../pages/main_page.dart'; // 메인 페이지 경로 (프로젝트 구조에 맞게 유지)

class OnboardingFlowScreen extends StatefulWidget {
  const OnboardingFlowScreen({super.key});

  @override
  State<OnboardingFlowScreen> createState() => _OnboardingFlowScreenState();
}

class _OnboardingFlowScreenState extends State<OnboardingFlowScreen> {
  // ★ 서버 주소
  static const String baseUrl = "http://52.79.228.227:8080";
  final storage = const FlutterSecureStorage();

  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isLoading = false;

  // ✨ 디자인 컬러 (민트)
  final Color _activeColor = const Color(0xFF4BECBE);

  // --- 1단계: 닉네임 ---
  final TextEditingController _nicknameController = TextEditingController();

  // --- 2단계: 신체 정보 ---
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  String? _selectedGender;

  // --- 3단계: 일일 목표 ---
  final TextEditingController _stepsController = TextEditingController();
  final TextEditingController _exerciseTimeController = TextEditingController();
  final TextEditingController _sleepHourController = TextEditingController();
  final TextEditingController _sleepMinController = TextEditingController();

  // --- 4단계: 관심사 ---
  final Set<String> _selectedInterests = {};
  final List<String> _interests = ['운동', '다이어트', '수면', '영양관리', '스트레스 관리'];

  @override
  void initState() {
    super.initState();
    // 상태 변경 감지 리스너 등록
    _nicknameController.addListener(_updateState);
    _ageController.addListener(_updateState);
    _heightController.addListener(_updateState);
    _weightController.addListener(_updateState);
    _stepsController.addListener(_updateState);
    _exerciseTimeController.addListener(_updateState);
    _sleepHourController.addListener(_updateState);
    _sleepMinController.addListener(_updateState);
  }

  void _updateState() => setState(() {});

  @override
  void dispose() {
    _nicknameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _stepsController.dispose();
    _exerciseTimeController.dispose();
    _sleepHourController.dispose();
    _sleepMinController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  // 각 단계별 유효성 검사 (버튼 활성화용)
  bool get _isCurrentStepValid {
    switch (_currentPage) {
      case 0: // 닉네임
        return _nicknameController.text.trim().isNotEmpty;
      case 1: // 신체정보
        return _ageController.text.isNotEmpty &&
            _heightController.text.isNotEmpty &&
            _weightController.text.isNotEmpty &&
            _selectedGender != null;
      case 2: // 목표설정
        return _stepsController.text.isNotEmpty &&
            _exerciseTimeController.text.isNotEmpty &&
            _sleepHourController.text.isNotEmpty &&
            _sleepMinController.text.isNotEmpty;
      case 3: // 관심사
        return _selectedInterests.isNotEmpty;
      default:
        return false;
    }
  }

  // [API 1] 닉네임 중복 확인
  Future<void> _checkNicknameAndNext() async {
    final nickname = _nicknameController.text.trim();
    if (nickname.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      // 쿼리 파라미터로 전송
      final url = Uri.parse('$baseUrl/api/users/check-nickname?nickname=$nickname');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        _goToNextPage();
      } else {
        _showSnackBar("이미 사용 중인 닉네임입니다. 다른 이름을 써주세요!");
      }
    } catch (e) {
      print("Error: $e");
      _showSnackBar("서버 연결에 실패했습니다.");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // [API 2] 온보딩 정보 등록 (최종 제출)
  Future<void> _submitOnboarding() async {
    setState(() => _isLoading = true);

    // 저장된 토큰 가져오기
    String? token = await storage.read(key: 'ACCESS_TOKEN');

    if (token == null) {
      _showSnackBar("로그인 정보가 없습니다. 다시 로그인해주세요.");
      setState(() => _isLoading = false);
      // 필요하다면 로그인 페이지로 이동 로직 추가 가능
      return;
    }

    try {
      final url = Uri.parse('$baseUrl/api/users/onboarding');

      final bodyData = {
        "nickname": _nicknameController.text.trim(),
        "age": int.parse(_ageController.text), // 나이는 정수
        "gender": _selectedGender == "Male" ? "MALE" : "FEMALE",
        "height": double.parse(_heightController.text), // 키는 실수
        "weight": double.parse(_weightController.text), // 몸무게는 실수
        "dailyStepGoal": int.parse(_stepsController.text),
        "dailyWorkoutGoal": int.parse(_exerciseTimeController.text),
        "dailySleepHoursGoal": int.parse(_sleepHourController.text),
        "dailySleepMinutesGoal": int.parse(_sleepMinController.text),
        "interests": _selectedInterests.toList(),
        "referrerId": "none"
      };

      print("🚀 [전송 데이터]: $bodyData");

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          // ★ [핵심 수정] Bearer + 공백 + 토큰
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(bodyData),
      );

      print("📩 [응답 상태]: ${response.statusCode}");
      print("📩 [응답 내용]: ${utf8.decode(response.bodyBytes)}");

      if (response.statusCode == 200) {
        if (!mounted) return;
        // 성공 시 메인 페이지로 이동 (이전 기록 제거)
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const MainPage()),
              (route) => false,
        );
      } else {
        _showSnackBar("저장에 실패했습니다. (코드: ${response.statusCode})");
      }
    } catch (e) {
      print("🔥 [에러] $e");
      _showSnackBar("오류가 발생했습니다: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _goToNextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
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
          onPressed: () {
            if (_currentPage > 0) {
              _pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.ease,
              );
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 상단 인디케이터 (1단계 제외)
            if (_currentPage > 0)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  children: List.generate(3, (index) {
                    return Container(
                      margin: const EdgeInsets.only(right: 8),
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: (_currentPage - 1) == index
                            ? _activeColor
                            : const Color(0xFFEEEEEE),
                      ),
                    );
                  }),
                ),
              ),

            const SizedBox(height: 10),

            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (idx) => setState(() => _currentPage = idx),
                children: [
                  _buildNicknameStep(),     // 0: 닉네임
                  _buildPersonalInfoStep(), // 1: 신체정보
                  _buildDailyGoalStep(),    // 2: 목표
                  _buildInterestStep(),     // 3: 관심사
                ],
              ),
            ),

            // 하단 '다음' / '시작하기' 버튼
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isCurrentStepValid ? _activeColor : const Color(0xFFE0E0E0),
                    foregroundColor: _isCurrentStepValid ? Colors.white : const Color(0xFF9E9E9E),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: (_isCurrentStepValid && !_isLoading)
                      ? () {
                    if (_currentPage == 0) {
                      _checkNicknameAndNext();
                    } else if (_currentPage == 3) {
                      _submitOnboarding();
                    } else {
                      _goToNextPage();
                    }
                  }
                      : null,
                  child: _isLoading
                      ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                  )
                      : Text(
                    _currentPage == 3 ? '바디버디 시작하기' : '다음',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- 1단계 UI ---
  Widget _buildNicknameStep() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Text(
            "어떻게\n불러드릴까요?",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, height: 1.4),
          ),
          const SizedBox(height: 100),
          Stack(
            alignment: Alignment.centerRight,
            children: [
              TextField(
                controller: _nicknameController,
                maxLength: 10,
                style: const TextStyle(fontSize: 18),
                decoration: const InputDecoration(
                  hintText: "닉네임을 입력해주세요",
                  hintStyle: TextStyle(color: Color(0xFFBDBDBD), fontSize: 16),
                  counterText: "",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  contentPadding: EdgeInsets.only(right: 30, bottom: 8),
                ),
              ),
              if (_nicknameController.text.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.cancel, color: Color(0xFFBDBDBD), size: 20),
                  onPressed: () => _nicknameController.clear(),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "(${_nicknameController.text.length}/10)",
            style: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 12),
          ),
        ],
      ),
    );
  }

  // --- 2단계 UI ---
  Widget _buildPersonalInfoStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Text(
            "버디님에 대해\n알려주세요",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, height: 1.4),
          ),
          const SizedBox(height: 8),
          const Text(
            "개인 맞춤 건강 관리를 위해 필요해요",
            style: TextStyle(fontSize: 14, color: Color(0xFF9E9E9E)),
          ),
          const SizedBox(height: 40),
          _buildLabel("나이"),
          const SizedBox(height: 8),
          _buildBoxTextField(controller: _ageController, hint: "예) 28", isNumber: true),

          const SizedBox(height: 24),
          _buildLabel("성별"),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _buildGenderButton("남성", "Male")),
              const SizedBox(width: 8),
              Expanded(child: _buildGenderButton("여성", "Female")),
            ],
          ),

          const SizedBox(height: 24),
          _buildLabel("키(cm)"),
          const SizedBox(height: 8),
          // 키: 소수점 허용 (isDecimal: true)
          _buildBoxTextField(controller: _heightController, hint: "예) 170.5", isNumber: true, isDecimal: true),

          const SizedBox(height: 24),
          _buildLabel("몸무게(kg)"),
          const SizedBox(height: 8),
          // 몸무게: 소수점 허용 (isDecimal: true)
          _buildBoxTextField(controller: _weightController, hint: "예) 65.4", isNumber: true, isDecimal: true),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // --- 3단계 UI ---
  Widget _buildDailyGoalStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Text(
            "일일 목표를\n설정해주세요",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, height: 1.4),
          ),
          const SizedBox(height: 8),
          const Text(
            "개인 맞춤 건강 관리를 위해 필요해요",
            style: TextStyle(fontSize: 14, color: Color(0xFF9E9E9E)),
          ),

          const SizedBox(height: 40),
          _buildLabel("걸음 수"),
          const SizedBox(height: 8),
          _buildBoxTextField(controller: _stepsController, hint: "입력해주세요", isNumber: true),

          const SizedBox(height: 24),
          _buildLabel("운동 시간(분)"),
          const SizedBox(height: 8),
          _buildBoxTextField(controller: _exerciseTimeController, hint: "입력해주세요", isNumber: true),

          const SizedBox(height: 24),
          _buildLabel("수면 시간"),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildBoxTextField(controller: _sleepHourController, hint: "시간", isNumber: true),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildBoxTextField(controller: _sleepMinController, hint: "분", isNumber: true),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // --- 4단계 UI ---
  Widget _buildInterestStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Text(
            "관심 분야를\n선택해주세요",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, height: 1.4),
          ),
          const SizedBox(height: 40),

          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: _interests.map((interest) {
              final isSelected = _selectedInterests.contains(interest);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedInterests.remove(interest);
                    } else {
                      _selectedInterests.add(interest);
                    }
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? _activeColor.withOpacity(0.1) : Colors.white,
                    border: Border.all(
                      color: isSelected ? _activeColor : const Color(0xFFE0E0E0),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    interest,
                    style: TextStyle(
                      color: isSelected ? _activeColor : const Color(0xFF9E9E9E),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // Helper Widgets
  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
    );
  }

  // ✨ [수정] 소수점 입력 지원 (isDecimal 추가)
  Widget _buildBoxTextField({
    required TextEditingController controller,
    required String hint,
    bool isNumber = false,
    bool isDecimal = false, // 소수점 허용 여부
  }) {
    return TextFormField(
      controller: controller,
      // 숫자 키패드: 소수점 옵션 활성화
      keyboardType: isNumber
          ? TextInputType.numberWithOptions(decimal: isDecimal)
          : TextInputType.text,
      inputFormatters: isNumber
          ? [
        // isDecimal이면 소수점 포함 허용, 아니면 숫자만 허용
        FilteringTextInputFormatter.allow(
          isDecimal ? RegExp(r'^\d+\.?\d*') : RegExp(r'^\d+'),
        )
      ]
          : [],
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFFBDBDBD), fontSize: 14),
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  Widget _buildGenderButton(String label, String value) {
    bool isSelected = _selectedGender == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGender = value;
        });
      },
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: isSelected ? _activeColor.withOpacity(0.1) : Colors.white,
          border: Border.all(
            color: isSelected ? _activeColor : const Color(0xFFE0E0E0),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? _activeColor : const Color(0xFF9E9E9E),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}