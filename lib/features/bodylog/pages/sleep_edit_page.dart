// lib/features/bodylog/pages/sleep_edit_page.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/sleep_api_service.dart';
import '../data/sleep_model.dart';

class SleepEditPage extends StatefulWidget {
  final SleepRecord? record;
  final DateTime selectedDate;

  const SleepEditPage({
    super.key,
    this.record,
    required this.selectedDate,
  });

  @override
  State<SleepEditPage> createState() => _SleepEditPageState();
}

class _SleepEditPageState extends State<SleepEditPage> {
  final SleepApiService _apiService = SleepApiService();

  late TextEditingController _sleepTimeController;
  late TextEditingController _wakeTimeController;

  String _selectedQuality = '좋음';
  final List<String> _qualityOptions = ['매우 좋음', '좋음', '보통', '나쁨', '매우 나쁨'];

  // 서버로 보낼 매핑 값
  final Map<String, String> _qualityMapping = {
    '매우 좋음': 'VERY_GOOD',
    '좋음': 'GOOD',
    '보통': 'NORMAL',
    '나쁨': 'BAD',
    '매우 나쁨': 'VERY_BAD',
  };

  @override
  void initState() {
    super.initState();
    // 데이터가 있으면 채워넣고, 없으면 기본값
    _sleepTimeController = TextEditingController(text: widget.record?.sleepTime ?? "23:00");
    _wakeTimeController = TextEditingController(text: widget.record?.wakeTime ?? "07:00");

    if (widget.record != null) {
      // 기존 품질값을 한글로 역매핑 (여기서는 간단히 처리)
      _selectedQuality = widget.record!.qualityKor;
      if (!_qualityOptions.contains(_selectedQuality)) _selectedQuality = '보통';
    }
  }

  // 시간 선택 팝업
  Future<void> _pickTime(TextEditingController controller) async {
    // 현재 입력된 시간 파싱
    List<String> parts = controller.text.split(':');
    int initialHour = int.parse(parts[0]);
    int initialMinute = int.parse(parts[1]);

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: initialHour, minute: initialMinute),
    );

    if (picked != null) {
      // 24시간 형식으로 변환 (HH:mm)
      String formattedTime = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      setState(() {
        controller.text = formattedTime;
      });
    }
  }

  // 저장 (추가/수정)
  Future<void> _save() async {
    try {
      final data = {
        "sleepDate": DateFormat('yyyy-MM-dd').format(widget.selectedDate),
        "sleepTime": _sleepTimeController.text,
        "wakeTime": _wakeTimeController.text,
        "sleepQuality": _qualityMapping[_selectedQuality] ?? 'NORMAL',
        // totalSleepMinute은 보통 서버에서 계산하거나, 여기서 계산해서 보냄
      };

      if (widget.record == null) {
        await _apiService.createSleepLog(data);
      } else {
        await _apiService.updateSleepLog(widget.record!.sleepId, data);
      }

      if (mounted) Navigator.pop(context, true); // 성공
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('저장 실패')));
    }
  }

  // 삭제
  Future<void> _delete() async {
    if (widget.record == null) return;
    try {
      await _apiService.deleteSleepLog(widget.record!.sleepId);
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('삭제 실패')));
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isEditMode = widget.record != null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(isEditMode ? '수면 기록 수정' : '수면 기록 추가', style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel('취침 시간'),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _pickTime(_sleepTimeController),
              child: AbsorbPointer(
                child: _buildTextField(_sleepTimeController),
              ),
            ),

            const SizedBox(height: 24),

            _buildLabel('기상 시간'),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _pickTime(_wakeTimeController),
              child: AbsorbPointer(
                child: _buildTextField(_wakeTimeController),
              ),
            ),

            const SizedBox(height: 24),

            _buildLabel('수면 품질'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedQuality,
                  isExpanded: true,
                  items: _qualityOptions.map((String value) {
                    return DropdownMenuItem<String>(value: value, child: Text(value));
                  }).toList(),
                  onChanged: (newValue) => setState(() => _selectedQuality = newValue!),
                ),
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4BECBE),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(isEditMode ? '수정하기' : '기록하기', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),

            if (isEditMode) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: _delete,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFFF6B6B)),
                    foregroundColor: const Color(0xFFFF6B6B),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('삭제하기', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ],
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14));
  }

  Widget _buildTextField(TextEditingController controller) {
    return TextField(
      controller: controller,
      readOnly: true, // 직접 입력 방지, 팝업 사용
      decoration: InputDecoration(
        suffixIcon: const Icon(Icons.access_time, color: Colors.grey),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
      ),
    );
  }
}