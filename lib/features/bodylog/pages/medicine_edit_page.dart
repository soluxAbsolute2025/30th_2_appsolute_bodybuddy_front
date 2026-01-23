// lib/features/bodylog/pages/medicine_edit_page.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/medicine_api_service.dart';
import '../data/medicine_model.dart';

class MedicineEditPage extends StatefulWidget {
  final DateTime selectedDate;
  final MedicineRecord? record; // 수정할 때만 넘어옴

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

  // 화면 UI값 (한글)
  String _selectedTime = '식후';
  String _selectedFrequency = '아침';

  // 서버 전송용 매핑 (한글 <-> 영어)
  final Map<String, String> _frequencyMap = {
    '아침': 'BREAKFAST', '점심': 'LUNCH', '저녁': 'DINNER'
  };
  final Map<String, String> _timeMap = {
    '식후': 'AFTER_MEAL', '식전': 'BEFORE_MEAL',
    '공복': 'EMPTY_STOMACH', '취침 전': 'BEFORE_SLEEP'
  };

  @override
  void initState() {
    super.initState();
    // 수정 모드면 기존 데이터 채워넣기
    _nameController = TextEditingController(text: widget.record?.name ?? '');
    if (widget.record != null) {
      _selectedFrequency = widget.record!.frequencyKor;
      _selectedTime = widget.record!.timeKor;
    }
  }

  // 저장 (추가/수정) 로직
  Future<void> _save() async {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('이름을 입력해주세요')));
      return;
    }

    try {
      final data = {
        "date": DateFormat('yyyy-MM-dd').format(widget.selectedDate),
        "name": _nameController.text,
        "frequency": _frequencyMap[_selectedFrequency], // 영어로 변환 전송
        "time": _timeMap[_selectedTime],               // 영어로 변환 전송
      };

      if (widget.record == null) {
        await _apiService.createMedicine(data); // 추가
      } else {
        await _apiService.updateMedicine(widget.record!.id, data); // 수정
      }

      if (mounted) Navigator.pop(context, true); // 성공 시 뒤로가기
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('저장 실패')));
    }
  }

  // 삭제 로직
  Future<void> _delete() async {
    if (widget.record == null) return;
    try {
      await _apiService.deleteMedicine(widget.record!.id);
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('삭제 실패')));
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
                  _buildLabel('약/영양제 이름'),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _nameController,
                    decoration: _inputDecoration('약 이름을 입력해주세요'),
                  ),
                  const SizedBox(height: 25),

                  _buildLabel('복용 시간'),
                  const SizedBox(height: 10),
                  _buildDropdown(),

                  const SizedBox(height: 25),

                  _buildLabel('1일 복용 횟수'),
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
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // 저장 버튼
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4BECBE),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(isEdit ? '수정하기' : '추가하기',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),

                // 수정 모드일 때만 삭제 버튼 표시
                if (isEdit) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton(
                      onPressed: _delete,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFFF6B6B)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('삭제하기',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFFFF6B6B))),
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

  Widget _buildLabel(String text) => Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14));

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

  Widget _buildDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedTime,
          isExpanded: true,
          items: _timeMap.keys.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (v) => setState(() => _selectedTime = v!),
        ),
      ),
    );
  }

  Widget _buildRadioOption(String value) {
    bool isSelected = _selectedFrequency == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedFrequency = value),
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
          Text(value, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}