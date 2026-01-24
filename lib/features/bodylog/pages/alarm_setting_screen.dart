import 'package:flutter/material.dart';
import '../data/alarm_setting_api.dart'; // 경로 확인

class AlarmSettingScreen extends StatefulWidget {
  const AlarmSettingScreen({super.key});

  @override
  State<AlarmSettingScreen> createState() => _AlarmSettingScreenState();
}

class _AlarmSettingScreenState extends State<AlarmSettingScreen> {
  bool _isLoading = true;

  // 카테고리별 데이터
  Map<String, List<dynamic>> _alarmData = {
    'MEAL': [],
    'MEDICINE': [],
    'EXERCISE': [],
    'WATER': [],
  };

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final data = await AlarmSettingApi.getAlarms();
    if (mounted) {
      setState(() {
        _alarmData = data;
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleSwitch(Map<String, dynamic> alarm, bool newVal) async {
    final int id = alarm['alarmId'] ?? 0;
    final String category = alarm['category'] ?? 'MEAL';
    final String label = alarm['label'] ?? '';
    final String time = alarm['parsedTime'] ?? '00:00:00';

    setState(() {
      alarm['isEnabled'] = newVal;
    });

    try {
      final String timeToSend = time.length > 5 ? time.substring(0, 5) : time;
      await AlarmSettingApi.updateAlarm(id, category, label, timeToSend, newVal);
    } catch (e) {
      setState(() => alarm['isEnabled'] = !newVal);
      print("스위치 에러: $e");
    }
  }

  void _showAlarmModal({required String categoryKey, Map<String, dynamic>? alarm}) {
    final bool isEditMode = alarm != null;
    final TextEditingController textController = TextEditingController(
        text: isEditMode ? (alarm['label'] ?? '') : ''
    );

    TimeOfDay selectedTime = const TimeOfDay(hour: 8, minute: 0);

    if (isEditMode) {
      final String rawTime = alarm['parsedTime'] ?? '08:00:00';
      try {
        final parts = rawTime.split(':');
        if (parts.length >= 2) {
          selectedTime = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
        }
      } catch (_) {}
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Text(isEditMode ? '알람 수정' : '알람 추가'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("알람 이름", style: TextStyle(fontSize: 12, color: Colors.grey)),
                  TextField(
                    controller: textController,
                    decoration: const InputDecoration(
                      hintText: '예: 점심 약 먹기',
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text("시간 설정", style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () async {
                      final TimeOfDay? time = await showTimePicker(
                        context: context,
                        initialTime: selectedTime,
                      );
                      if (time != null) {
                        setStateDialog(() => selectedTime = time);
                      }
                    },
                    child: Row(
                      children: [
                        Text(
                          "${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}",
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.edit, size: 16, color: Colors.grey),
                      ],
                    ),
                  ),
                ],
              ),
              actions: [
                if (isEditMode)
                  TextButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      await _deleteAction(alarm['alarmId'] ?? 0);
                    },
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                    child: const Text('삭제'),
                  ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('취소', style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (textController.text.isEmpty) return;
                    // [중요] API 요구사항에 맞춰 :00 추가
                    final String formattedTime =
                        "${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}:00";

                    Navigator.pop(context);

                    if (isEditMode) {
                      await AlarmSettingApi.updateAlarm(
                        alarm['alarmId'] ?? 0,
                        categoryKey,
                        textController.text,
                        formattedTime,
                        alarm['isEnabled'] ?? true,
                      );
                    } else {
                      await AlarmSettingApi.addAlarm(
                        categoryKey,
                        textController.text,
                        formattedTime,
                      );
                    }
                    await _loadData();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4BECBE),
                    foregroundColor: Colors.white,
                    elevation: 0,
                  ),
                  child: const Text('저장'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _deleteAction(int id) async {
    try {
      await AlarmSettingApi.deleteAlarm(id);
      await _loadData();
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("삭제되었습니다.")));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("삭제 실패")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('알람 설정', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF4BECBE)))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // [수정] IconData 대신 이미지 경로를 전달합니다.
            const SizedBox(height: 3),
            _buildCategoryCard('식단 알람', 'MEAL', 'assets/bodylog/meal_alarm_icon.png'),
            const SizedBox(height: 3),
            _buildCategoryCard('약/영양제 알람', 'MEDICINE', 'assets/bodylog/medicine_alarm_icon.png'),
            const SizedBox(height: 3),
            _buildCategoryCard('운동 알람', 'EXERCISE', 'assets/bodylog/clock_alarm_icon.png'),
            const SizedBox(height: 3),
            _buildCategoryCard('수분 섭취 알람', 'WATER', 'assets/bodylog/water_alarm_icon.png'),
          ],
        ),
      ),
    );
  }

  // [수정] 인자를 IconData -> String imagePath로 변경
  Widget _buildCategoryCard(String title, String categoryKey, String imagePath) {
    final List<dynamic> alarms = _alarmData[categoryKey] ?? [];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: true,
          // [수정] Icon 위젯을 Image.asset으로 변경
          leading: Image.asset(
            imagePath,
            width: 16,  // 이미지 크기 조절 (필요시 수정)
            height: 16,
            fit: BoxFit.contain,
            // 이미지가 없을 경우 깨짐 방지용
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.image_not_supported, color: Colors.grey);
            },
          ),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          trailing: IconButton(
            icon: const Icon(Icons.add_circle_outline, color: Colors.grey),
            onPressed: () => _showAlarmModal(categoryKey: categoryKey),
          ),
          children: [
            if (alarms.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text("등록된 알람이 없습니다.", style: TextStyle(color: Colors.grey)),
              ),

            ...alarms.map((alarm) {
              final String label = alarm['label'] ?? '알람';
              final String timeStr = alarm['parsedTime'] ?? '00:00:00';
              final String displayTime = timeStr.length >= 5 ? timeStr.substring(0, 5) : timeStr;
              final bool isEnabled = alarm['isEnabled'] ?? true;

              return InkWell(
                onTap: () => _showAlarmModal(categoryKey: categoryKey, alarm: alarm),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                            const SizedBox(height: 4),
                            Text("매일 $displayTime", style: const TextStyle(color: Colors.grey, fontSize: 13)),
                          ],
                        ),
                      ),
                      Switch(
                        value: isEnabled,
                        onChanged: (val) => _toggleSwitch(alarm, val),
                        activeColor: const Color(0xFF4BECBE),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}