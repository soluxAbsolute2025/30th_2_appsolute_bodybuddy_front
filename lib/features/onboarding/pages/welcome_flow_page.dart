import 'dart:convert'; // JSON 처리
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // 키보드 입력 제한용
import 'package:http/http.dart' as http; // API 통신
import '../../../../common/common.dart'; // ✅ Common import
import '../../../../pages/main_page.dart'; // 메인 페이지 경로

class OnboardingFlowScreen extends StatefulWidget {
  const OnboardingFlowScreen({super.key});

  @override
  State<OnboardingFlowScreen> createState() => _OnboardingFlowScreenState();
}

class _OnboardingFlowScreenState extends State<OnboardingFlowScreen> {
  // ★ 서버 주소
  static const String baseUrl = "http://52.79.228.227:8080";

  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isLoading = false;

  // 🎨 [색상 복구] 민트색 제거 -> 블랙으로 변경
  final Color _activeColor = Colors.black;

  // --- 1단계: 닉네임 ---
  final TextEditingController _nicknameController = TextEditingController();
  bool _isNicknameChecked = false; // 닉네임 중복확인 완료 여부

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
    // 닉네임이 바뀌면 중복확인 상태 초기화 (다시 확인해야 함)
    _nicknameController.addListener(() {
      if (_isNicknameChecked) {
        setState(() {
          _isNicknameChecked = false;
        });
      }
      setState(() {});
    });

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

  // 각 단계별 유효성 검사
  bool get _isCurrentStepValid {
    switch (_currentPage) {
      case 0: // 닉네임: 입력되어 있고 + 중복확인까지 마쳐야 함
        return _nicknameController.text.trim().isNotEmpty && _isNicknameChecked;
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

  // ✅ [Helper] 토큰 가져오기
  Future<String?> _getToken() async {
    String? token = Common.token;
    if (token == null) {
      token = await Common.storage.read(key: 'accessToken');
    }
    return token;
  }

  // ✅ [API 1] 닉네임 중복 확인 (버튼 클릭 시 실행)
  Future<void> _checkNickname() async {
    final nickname = _nicknameController.text.trim();
    if (nickname.isEmpty) return;

    // 키보드 내리기
    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);

    String? token = await _getToken();
    if (token == null) {
      _showSnackBar("로그인 정보가 없습니다. 다시 로그인해주세요.");
      setState(() => _isLoading = false);
      return;
    }

    try {
      final url = Uri.parse('$baseUrl/api/users/check-nickname?nickname=$nickname');

      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      print("📩 [닉네임 확인] 상태코드: ${response.statusCode}");

      if (response.statusCode == 200) {
        // ✅ 사용 가능
        setState(() {
          _isNicknameChecked = true;
        });
        _showSnackBar("사용 가능한 닉네임입니다!");
      } else {
        // ❌ 사용 불가 (409 Conflict 등)
        setState(() {
          _isNicknameChecked = false;
        });
        _showSnackBar("이미 사용 중인 닉네임입니다. 다른 이름을 써주세요.");
      }
    } catch (e) {
      print("Error: $e");
      _showSnackBar("서버 연결에 실패했습니다.");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // ✅ [API 2] 온보딩 정보 등록 (최종 제출)
  Future<void> _submitOnboarding() async {
    setState(() => _isLoading = true);

    String? token = await _getToken();

    if (token == null) {
      _showSnackBar("로그인 정보가 없습니다. 다시 로그인해주세요.");
      setState(() => _isLoading = false);
      return;
    }

    try {
      final url = Uri.parse('$baseUrl/api/users/onboarding');

      final bodyData = {
        "nickname": _nicknameController.text.trim(),
        "age": int.parse(_ageController.text),
        "gender": _selectedGender == "Male" ? "MALE" : "FEMALE",
        "height": double.parse(_heightController.text),
        "weight": double.parse(_weightController.text),
        "dailyStepGoal": int.parse(_stepsController.text),
        "dailyWorkoutGoal": int.parse(_exerciseTimeController.text),
        "dailySleepHoursGoal": int.parse(_sleepHourController.text),
        "dailySleepMinutesGoal": int.parse(_sleepMinController.text),
        "dailyWaterGoal": 2000,
        "interests": _selectedInterests.toList(),
        "referrerId": "none"
      };

      print("🚀 [전송 데이터]: $bodyData");

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(bodyData),
      );

      print("📩 [응답 상태]: ${response.statusCode}");

      if (response.statusCode == 200) {
        if (!mounted) return;
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
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _goToNextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
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
            // 상단 인디케이터
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
                            : Colors.grey.shade300,
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
                  _buildNicknameStep(),     // 0
                  _buildPersonalInfoStep(), // 1
                  _buildDailyGoalStep(),    // 2
                  _buildInterestStep(),     // 3
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
                    backgroundColor: _isCurrentStepValid ? _activeColor : Colors.grey.shade300,
                    foregroundColor: _isCurrentStepValid ? Colors.white : Colors.grey,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  // 로딩 중이 아니고 유효할 때만 클릭 가능
                  onPressed: (_isCurrentStepValid && !_isLoading)
                      ? () {
                    // 0페이지에서는 이미 중복확인이 끝났으므로 바로 넘어감
                    if (_currentPage == 3) {
                      _submitOnboarding(); // 최종 등록
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

  // --- 1단계: 닉네임 (수정됨) ---
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

          // ✨ [수정] 입력창 + 중복확인 버튼 Row 배치
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Stack(
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
              ),
              const SizedBox(width: 10),

              // ✨ [추가] 중복 확인 버튼
              SizedBox(
                height: 40,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black, // 버튼 색상
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  onPressed: _nicknameController.text.trim().isEmpty
                      ? null
                      : _checkNickname, // 버튼 누르면 API 호출
                  child: const Text("중복 확인", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // 안내 문구 (확인 여부에 따라 다르게 표시 가능)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_isNicknameChecked)
                const Text("✅ 사용 가능한 닉네임입니다.", style: TextStyle(color: Colors.green, fontSize: 12))
              else
                const Text("닉네임 중복 확인을 해주세요.", style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 12)),

              Text(
                "(${_nicknameController.text.length}/10)",
                style: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 12),
              ),
            ],
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
          _buildBoxTextField(controller: _heightController, hint: "예) 170.5", isNumber: true, isDecimal: true),

          const SizedBox(height: 24),
          _buildLabel("몸무게(kg)"),
          const SizedBox(height: 8),
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
                    color: isSelected ? Colors.black.withOpacity(0.05) : Colors.white,
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
    bool isDecimal = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber
          ? TextInputType.numberWithOptions(decimal: isDecimal)
          : TextInputType.text,
      inputFormatters: isNumber
          ? [
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
          color: isSelected ? Colors.black.withOpacity(0.05) : Colors.white,
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