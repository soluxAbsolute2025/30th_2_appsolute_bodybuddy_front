// 파일 위치: lib/features/onboarding/pages/welcome_flow_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // 숫자 입력 제한
import '../../../../pages/main_page.dart';

class OnboardingFlowScreen extends StatefulWidget {
  const OnboardingFlowScreen({super.key});

  @override
  State<OnboardingFlowScreen> createState() => _OnboardingFlowScreenState();
}

class _OnboardingFlowScreenState extends State<OnboardingFlowScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // ✨ [디자인] 요청하신 민트색 적용 완료!
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
    // 상태 감지를 위한 리스너 등록
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

  // 버튼 활성화 여부 체크
  bool get _isCurrentStepValid {
    switch (_currentPage) {
      case 0: // 닉네임
        return _nicknameController.text.trim().isNotEmpty;
      case 1: // 신체 정보
        return _ageController.text.isNotEmpty &&
            _heightController.text.isNotEmpty &&
            _weightController.text.isNotEmpty &&
            _selectedGender != null;
      case 2: // 일일 목표
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
            // 상단 인디케이터 (점)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: List.generate(4, (index) {
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      // 현재 페이지일 때 지정해주신 민트색 적용
                      color: _currentPage == index
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
                  _buildNicknameStep(),     // 1단계
                  _buildPersonalInfoStep(), // 2단계
                  _buildDailyGoalStep(),    // 3단계
                  _buildInterestStep(),     // 4단계
                ],
              ),
            ),

            // 하단 버튼
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    // 활성화되면 지정해주신 민트색, 아니면 회색
                    backgroundColor: _isCurrentStepValid ? _activeColor : const Color(0xFFE0E0E0),
                    foregroundColor: _isCurrentStepValid ? Colors.white : const Color(0xFF9E9E9E),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _isCurrentStepValid
                      ? () {
                    if (_currentPage < 3) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );
                    } else {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const MainPage()),
                            (route) => false,
                      );
                    }
                  }
                      : null,
                  child: Text(
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

  // --- 1단계: 닉네임 ---
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

  // --- 2단계: 신체 정보 ---
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
          _buildBoxTextField(controller: _ageController, hint: "예) 28살", isNumber: true),
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
          _buildBoxTextField(controller: _heightController, hint: "예) 170", isNumber: true),
          const SizedBox(height: 24),
          _buildLabel("몸무게(kg)"),
          const SizedBox(height: 8),
          _buildBoxTextField(controller: _weightController, hint: "예) 65", isNumber: true),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // --- 3단계: 일일 목표 ---
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

  // --- 4단계: 관심사 ---
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
                    // 선택 시 연한 배경 (지정해주신 색상 + 투명도)
                    color: isSelected ? _activeColor.withOpacity(0.1) : Colors.white,
                    // 선택 시 테두리 색상
                    border: Border.all(
                      color: isSelected ? _activeColor : const Color(0xFFE0E0E0),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    interest,
                    style: TextStyle(
                      // 선택 시 텍스트 색상
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

  // --- 공통 위젯 ---
  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
    );
  }

  Widget _buildBoxTextField({
    required TextEditingController controller,
    required String hint,
    bool isNumber = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      inputFormatters: isNumber ? [FilteringTextInputFormatter.digitsOnly] : [],
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
          // 선택 시 연한 배경 (지정해주신 색상 + 투명도)
          color: isSelected ? _activeColor.withOpacity(0.1) : Colors.white,
          // 선택 시 테두리 색상
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