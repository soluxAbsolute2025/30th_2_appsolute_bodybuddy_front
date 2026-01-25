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

  late TextEditingController _bedTimeController;
  late TextEditingController _wakeTimeController;

  String _selectedQuality = '좋음';
  final List<String> _qualityOptions = ['매우 좋음', '좋음', '보통', '나쁨', '매우 나쁨'];

  final Map<String, String> _qualityMapping = {
    '매우 좋음': 'VERY_GOOD',
    '좋음': 'GOOD',
    '보통': 'NORMAL',
    '나쁨': 'BAD',
    '매우 나쁨': 'VERY_BAD',
  };

  bool _isAnalyzing = false;
  String? _analyzedMessage;

  @override
  void initState() {
    super.initState();
    // 초기 시간 포맷팅 (HH:mm)
    _bedTimeController = TextEditingController(
        text: _formatTimeDisplay(widget.record?.bedTime) ?? "23:00");
    _wakeTimeController = TextEditingController(
        text: _formatTimeDisplay(widget.record?.wakeTime) ?? "07:00");

    if (widget.record != null) {
      _selectedQuality = widget.record!.qualityKor;
      if (!_qualityOptions.contains(_selectedQuality)) _selectedQuality = '보통';
    }
  }

  String? _formatTimeDisplay(String? time) {
    if (time == null) return null;
    if (time.length >= 5) return time.substring(0, 5);
    return time;
  }

  Future<void> _pickTime(TextEditingController controller) async {
    List<String> parts = controller.text.split(':');
    int initialHour = int.parse(parts[0]);
    int initialMinute = int.parse(parts[1]);

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: initialHour, minute: initialMinute),
    );

    if (picked != null) {
      String formattedTime =
          '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      setState(() {
        controller.text = formattedTime;
      });
    }
  }

  Future<void> _fetchSleepAnalysis() async {
    setState(() {
      _isAnalyzing = true;
      _analyzedMessage = null;
    });

    try {
      String dateStr = DateFormat('yyyy-MM-dd').format(widget.selectedDate);
      final result = await _apiService.getSleepQuality(dateStr, dateStr);

      double avgHours = 0.0;
      if (result['averageSleepHours'] != null) {
        avgHours = (result['averageSleepHours'] as num).toDouble();
      }

      String qualityFromServer = result['sleepQuality'] ?? 'NORMAL';
      String korQuality = '보통';
      _qualityMapping.forEach((key, value) {
        if (value == qualityFromServer) korQuality = key;
      });

      setState(() {
        _analyzedMessage = "AI 분석 결과: 평균 $avgHours시간 / 품질 '$korQuality'";
        if (_qualityOptions.contains(korQuality)) {
          _selectedQuality = korQuality;
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('분석 실패')));
    } finally {
      setState(() => _isAnalyzing = false);
    }
  }

  Future<void> _save() async {
    try {
      final String date = DateFormat('yyyy-MM-dd').format(widget.selectedDate);
      final String bed = _bedTimeController.text;
      final String wake = _wakeTimeController.text;
      final String quality = _qualityMapping[_selectedQuality] ?? 'NORMAL';

      if (widget.record == null) {
        await _apiService.createSleepLog(date, bed, wake, quality);
      } else {
        await _apiService.updateSleepLog(
            widget.record!.sleepRecordId, bed, wake, quality);
      }

      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('기록 저장에 실패했습니다.')));
    }
  }

  Future<void> _delete() async {
    if (widget.record == null) return;

    bool? confirm = await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('기록 삭제'),
        content: const Text('정말 이 수면 기록을 삭제하시겠습니까?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('취소')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('삭제', style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await _apiService.deleteSleepLog(widget.record!.sleepRecordId);
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('삭제 실패')));
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isEditMode = widget.record != null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(isEditMode ? '수면 기록 수정' : '수면 기록 추가',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel('취침 시간'),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () => _pickTime(_bedTimeController),
              child: AbsorbPointer(child: _buildTextField(_bedTimeController)),
            ),
            const SizedBox(height: 30),
            _buildLabel('기상 시간'),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () => _pickTime(_wakeTimeController),
              child: AbsorbPointer(child: _buildTextField(_wakeTimeController)),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildLabel('수면 품질'),
                TextButton.icon(
                  onPressed: _isAnalyzing ? null : _fetchSleepAnalysis,
                  icon: _isAnalyzing
                      ? const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.analytics_outlined, size: 18),
                  label: Text(_isAnalyzing ? '분석 중...' : 'AI 분석'),
                  style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF4BECBE)),
                ),
              ],
            ),
            if (_analyzedMessage != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                    color: const Color(0xFFE0F7FA),
                    borderRadius: BorderRadius.circular(8)),
                child: Text(_analyzedMessage!,
                    style: const TextStyle(
                        color: Color(0xFF006064),
                        fontSize: 13,
                        fontWeight: FontWeight.w600)),
              ),
            ],
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(12)),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedQuality,
                  isExpanded: true,
                  items: _qualityOptions
                      .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedQuality = v!),
                ),
              ),
            ),
            const SizedBox(height: 80), // Spacer 대신 명확한 간격 사용
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4BECBE),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
                child: Text(isEditMode ? '수정 완료' : '기록하기',
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
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
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                  child: const Text('삭제하기',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFFFF6B6B))),
                ),
              ),
            ],
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) =>
      Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15));

  Widget _buildTextField(TextEditingController controller) => TextField(
    controller: controller,
    readOnly: true,
    textAlign: TextAlign.center,
    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
    decoration: InputDecoration(
      filled: true,
      fillColor: const Color(0xFFF8F9FA),
      suffixIcon: const Icon(Icons.access_time, color: Color(0xFF4BECBE)),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
    ),
  );
}