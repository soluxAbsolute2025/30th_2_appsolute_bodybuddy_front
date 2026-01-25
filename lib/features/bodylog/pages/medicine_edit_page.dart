import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/medicine_api_service.dart';
import '../data/medicine_model.dart';

class MedicineEditPage extends StatefulWidget {
  final DateTime selectedDate;
  final MedicineRecord? record; // 수정할 때만 데이터가 넘어옴

  const MedicineEditPage({
    super.key,
    required this.selectedDate,
    this.record,
  });

  @override
  State<MedicineEditPage> createState() => _MedicineEditPageState();
}

class _MedicineEditPageState extends State<MedicineEditPage> {
  final MedicineApiService _apiService = MedicineApiService();
  late TextEditingController _nameController;

  // [수정 1] 시간 관리용 변수 추가 (에러 해결)
  TimeOfDay _selectedTime = const TimeOfDay(hour: 9, minute: 0);

  // UI 상태값
  String _selectedTiming = '식후';
  String _selectedTimeOfDay = '아침';

  // [2] 서버 전송용 매핑 (한글 -> 영어 Enum)
  final Map<String, String> _timeOfDayMap = {
    '아침': 'BREAKFAST',
    '점심': 'LUNCH',
    '저녁': 'DINNER',
    '취침 전': 'BEFORE_SLEEP',
  };

  final List<String> _timingList = ['식후', '식전', '공복', '취침 전'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.record?.name ?? '');

    if (widget.record != null) {
      // 기존 데이터가 있다면 UI에 반영
      if (widget.record!.timeKor.contains('점심')) {
        _updateTimeSlot('점심');
      } else if (widget.record!.timeKor.contains('저녁')) {
        _updateTimeSlot('저녁');
      } else {
        _updateTimeSlot('아침');
      }
    } else {
      // 추가 모드일 때 기본값 설정
      _updateTimeSlot('아침');
    }
  }

  // [수정 3] 라디오 버튼 선택 시 시간도 같이 세팅해주는 함수
  void _updateTimeSlot(String slot) {
    setState(() {
      _selectedTimeOfDay = slot;
      // 편의를 위해 시간도 자동으로 맞춰줌 (사용자가 나중에 바꿀 수도 있게 확장 가능)
      if (slot == '아침') _selectedTime = const TimeOfDay(hour: 9, minute: 0);
      else if (slot == '점심') _selectedTime = const TimeOfDay(hour: 13, minute: 0);
      else if (slot == '저녁') _selectedTime = const TimeOfDay(hour: 19, minute: 0);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  // ✅ 저장 (추가/수정) 로직
  Future<void> _save() async {
    // 1. 빈 값 방지
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('약 이름을 입력해주세요')),
      );
      return;
    }

    // 2. 입력값 확인 (로그 창을 보세요! 이게 찍혀야 합니다)
    print("🔥 [저장 시도] 입력한 이름: ${_nameController.text}");

    bool isMorning = _selectedTimeOfDay == '아침';
    bool isLunch = _selectedTimeOfDay == '점심';
    bool isDinner = _selectedTimeOfDay == '저녁';

    // 3. 데이터 생성
    // ✅ [핵심 전략] 서버가 거절 못하게 다 넣어버리기
    final Map<String, dynamic> data = {
      // 1. 가장 유력한 후보들
      "medicineName": _nameController.text,   // 문서상 유력
      "medicationName": _nameController.text, // 이전 로그 기반
      "name": _nameController.text,           // 일반적인 관례

      // 2. 혹시 언더바(_)를 쓸까?
      "medicine_name": _nameController.text,
      "medication_name": _nameController.text,

      // 3. 나머지 데이터
      "timing": _selectedTiming,
      "takeMorning": isMorning,
      "takeLunch": isLunch,
      "takeDinner": isDinner,
    };

    try {
      print("🚀 [저장 시도] 데이터: $data"); // 한글이 잘 찍히는지 콘솔 확인!

      if (widget.record == null) {
        await _apiService.createMedicine(data);
      } else {
        await _apiService.updateMedicine(widget.record!.id, data);
      }

      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      print("❌ 저장 실패: $e");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('저장 실패')));
    }
  }

  // ✅ 삭제 로직
  Future<void> _delete() async {
    if (widget.record == null) return;
    try {
      await _apiService.deleteMedicine(widget.record!.id);
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('삭제 실패')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isEdit = widget.record != null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(isEdit ? '약 & 영양제 수정' : '약 & 영양제 추가',
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. 이름 입력
                  _buildLabel('약/영양제 이름'),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _nameController,
                    decoration: _inputDecoration('예: 비타민 C, 혈압약'),
                  ),
                  const SizedBox(height: 25),

                  // 2. 복용 타이밍 (식전/식후)
                  _buildLabel('복용 방법'),
                  const SizedBox(height: 10),
                  _buildDropdown(),

                  const SizedBox(height: 25),

                  // 3. 복용 시간대 (아침/점심/저녁)
                  _buildLabel('언제 드시나요?'),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _buildRadioOption('아침'),
                      const SizedBox(width: 20),
                      _buildRadioOption('점심'),
                      const SizedBox(width: 20),
                      _buildRadioOption('저녁'),
                    ],
                  ),

                  // [추가] 현재 설정된 시간 표시 (디버깅 및 사용자 확인용)
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Text(
                      "설정된 시간: ${_selectedTime.format(context)}",
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 하단 버튼 영역
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4BECBE),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(isEdit ? '수정완료' : '추가하기',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),

                if (isEdit) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: TextButton(
                      onPressed: _delete,
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFFFF6B6B),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('삭제하기',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) => Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15));

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[300]!)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[300]!)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF4BECBE))),
    );
  }

  // 드롭다운 (식전/식후)
  Widget _buildDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedTiming,
          isExpanded: true,
          items: _timingList.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (v) => setState(() => _selectedTiming = v!),
        ),
      ),
    );
  }

  // 라디오 버튼 (아침/점심/저녁)
  Widget _buildRadioOption(String value) {
    bool isSelected = _selectedTimeOfDay == value;
    return GestureDetector(
      onTap: () => _updateTimeSlot(value), // [수정] 클릭 시 시간 업데이트 함수 호출
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4BECBE).withOpacity(0.1) : Colors.transparent,
          border: Border.all(color: isSelected ? const Color(0xFF4BECBE) : Colors.grey[300]!),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.check_circle : Icons.circle_outlined,
              size: 18,
              color: isSelected ? const Color(0xFF4BECBE) : Colors.grey[400],
            ),
            const SizedBox(width: 8),
            Text(value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? const Color(0xFF4BECBE) : Colors.black,
                )
            ),
          ],
        ),
      ),
    );
  }
}