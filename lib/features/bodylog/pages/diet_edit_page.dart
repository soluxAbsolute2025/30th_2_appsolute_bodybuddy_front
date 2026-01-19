import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../../common/common.dart';


class DietEditPage extends StatefulWidget {
  final bool isEditMode;
  final DateTime? selectedDate;
  final String? initialMealType; // "BREAKFAST", "LUNCH", "DINNER"
  final Map<String, dynamic>? existingData; // 수정 시 넘어오는 데이터

  const DietEditPage({
    super.key,
    this.isEditMode = false,
    this.selectedDate,
    this.initialMealType,
    this.existingData
  });

  @override
  State<DietEditPage> createState() => _DietEditPageState();
}

class _DietEditPageState extends State<DietEditPage> {
  // 컨트롤러
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _memoController = TextEditingController();
  final TextEditingController _foodController = TextEditingController(); // 음식 입력

  String _selectedMealType = 'LUNCH'; // 기본값 (API용: BREAKFAST/LUNCH/DINNER)

  final String _baseUrl = "http://52.79.228.227:8080";

  @override
  void initState() {
    super.initState();
    // 1. 넘어온 데이터 초기화
    if (widget.isEditMode && widget.existingData != null) {
      final data = widget.existingData!;
      _selectedMealType = data['mealType']; // "LUNCH"
      _timeController.text = _formatTime(data['intakeTime']); // "12:30"
      _memoController.text = data['memo'] ?? "";

      // 리스트 ["닭", "밥"] -> 문자열 "닭, 밥" 으로 변환해 표시
      List<dynamic> foods = data['foods'] ?? [];
      _foodController.text = foods.join(", ");
    } else {
      // 2. 신규 생성 시
      if (widget.initialMealType != null) {
        _selectedMealType = widget.initialMealType!;
      }
      _timeController.text = DateFormat('HH:mm').format(DateTime.now());
    }
  }

  // HH:mm:ss -> HH:mm 로 변환
  String _formatTime(String? time) {
    if (time == null || time.length < 5) return "12:00";
    return time.substring(0, 5);
  }

  // --- [API] 식단 기록 추가 (POST /api/meal-log) ---
  Future<void> _saveMealLog() async {
    if (Common.token == null) return;

    // 1. 날짜 처리
    DateTime date = widget.selectedDate ?? DateTime.now();
    String dateStr = DateFormat('yyyy-MM-dd').format(date);

    // 2. 음식 리스트 처리 (콤마로 구분해서 리스트로 변환)
    List<String> foodList = _foodController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

    // 3. 바디 구성 (명세서 참고)
    final Map<String, dynamic> body = {
      "mealType": _selectedMealType,    // "LUNCH"
      "intakeDate": dateStr,            // "2026-01-17"
      "intakeTime": _timeController.text, // "12:30"
      "foods": foodList,                // ["닭가슴살", "고구마"]
      "memo": _memoController.text,
    };

    try {
      final url = Uri.parse('$_baseUrl/api/meal-log');

      // 수정인 경우 ID가 필요할 수 있으나, 명세상 POST로 덮어쓰거나,
      // PATCH가 있다면 /api/meal-log/{id} 로 보내야 함.
      // 여기서는 우선 명세서에 있는 POST(추가) 로직을 기본으로 함.
      // (만약 수정 API가 따로 있다면 분기 처리 필요)

      // ※ 수정 시나리오: ID가 있다면 PATCH, 없으면 POST
      http.Response response;

      if (widget.isEditMode && widget.existingData != null) {
        // 수정 (PATCH /api/meal-log/{id})
        final int id = widget.existingData!['mealLogId'] ?? widget.existingData!['id']; // ID 키값 확인 필요
        final updateUrl = Uri.parse('$_baseUrl/api/meal-log/$id');
        response = await http.patch(
          updateUrl,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${Common.token}",
          },
          body: jsonEncode(body),
        );
      } else {
        // 신규 (POST /api/meal-log)
        response = await http.post(
          url,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${Common.token}",
          },
          body: jsonEncode(body),
        );
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        if(mounted) {
          Navigator.pop(context); // 성공 시 뒤로 가기
        }
      } else {
        print("❌ 저장 실패: ${utf8.decode(response.bodyBytes)}");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("저장 실패: ${response.statusCode}")));
      }
    } catch (e) {
      print("❌ 네트워크 에러: $e");
    }
  }

  // --- [API] 식단 삭제 (DELETE /api/meal-log/{id}) ---
  Future<void> _deleteMealLog() async {
    if (widget.existingData == null) return;

    // ID 추출 (서버 응답 키값에 따라 'mealLogId' 또는 'id' 사용)
    final int id = widget.existingData!['mealLogId'] ?? widget.existingData!['id'] ?? 0;

    try {
      final url = Uri.parse('$_baseUrl/api/meal-log/$id');
      final response = await http.delete(
        url,
        headers: {
          "Authorization": "Bearer ${Common.token}",
        },
      );

      if (response.statusCode == 200) {
        if(mounted) Navigator.pop(context);
      } else {
        print("❌ 삭제 실패: ${response.body}");
      }
    } catch (e) {
      print("삭제 에러: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.isEditMode ? '기록 편집' : '식단 기록', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        leading: IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // (1) 시간 입력
                  _buildLabel('시간'),
                  const SizedBox(height: 10),
                  _buildTextField(
                    controller: _timeController,
                    hint: '예: 12:30',
                  ),

                  const SizedBox(height: 25),

                  // (2) 메뉴 입력 (Foods)
                  _buildLabel('메뉴 (콤마 , 로 구분)'),
                  const SizedBox(height: 10),
                  _buildTextField(
                    controller: _foodController,
                    hint: '예: 닭가슴살, 현미밥, 김치',
                  ),

                  const SizedBox(height: 25),

                  // (3) 메모 입력
                  _buildLabel('메모'),
                  const SizedBox(height: 10),
                  _buildTextField(
                    controller: _memoController,
                    hint: '메모를 입력해주세요',
                    maxLines: 3,
                  ),

                  const SizedBox(height: 25),

                  // (4) 식사 시간 선택 (라디오 버튼)
                  _buildLabel('식사 구분'),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _buildRadioOption('아침', 'BREAKFAST'),
                      const SizedBox(width: 20),
                      _buildRadioOption('점심', 'LUNCH'),
                      const SizedBox(width: 20),
                      _buildRadioOption('저녁', 'DINNER'),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // 하단 버튼들
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _saveMealLog, // 저장 함수 연결
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4BECBE),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(widget.isEditMode ? '수정하기' : '기록하기', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
                if (widget.isEditMode) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton(
                      onPressed: _deleteMealLog, // 삭제 함수 연결
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFFF6B6B)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('삭제하기', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFFFF6B6B))),
                    ),
                  ),
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14));
  }

  Widget _buildTextField({
    required TextEditingController controller,
    String? hint,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[300]!)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[300]!)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF4BECBE))),
      ),
    );
  }

  Widget _buildRadioOption(String label, String value) {
    bool isSelected = _selectedMealType == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedMealType = value),
      child: Row(
        children: [
          Container(
            width: 18, height: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? const Color(0xFF4BECBE) : Colors.white,
              border: Border.all(color: isSelected ? const Color(0xFF4BECBE) : Colors.grey[300]!),
            ),
            child: isSelected ? const Icon(Icons.check, size: 12, color: Colors.white) : null,
          ),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}