import 'package:flutter/material.dart';
import '../data/alarm_setting_api.dart';

class AlarmSettingScreen extends StatefulWidget {
  const AlarmSettingScreen({super.key});

  @override
  State<AlarmSettingScreen> createState() => _AlarmSettingScreenState();
}

class _AlarmSettingScreenState extends State<AlarmSettingScreen> {
  final Color _primaryColor = const Color(0xFF4BECBE);
  bool _isLoading = true;

  // 데이터 담을 리스트 (서버 JSON 키값에 맞춰 초기화)
  List<dynamic> _dietAlarms = [];
  List<dynamic> _medAlarms = [];
  List<dynamic> _workoutAlarms = [];
  List<dynamic> _waterAlarms = [];

  @override
  void initState() {
    super.initState();
    _loadAlarms();
  }

  // [수정] 데이터 로딩 및 분류
  Future<void> _loadAlarms() async {
    try {
      // 이제 API가 Map을 반환하므로 타입 에러가 발생하지 않습니다.
      final Map<String, dynamic> data = await AlarmSettingApi.getAlarms();

      if (mounted) {
        setState(() {
          // 서버 JSON 키값(meal, medicine, exercise, water)에 맞춰 데이터 분리
          _dietAlarms = data['meal'] ?? [];
          _medAlarms = data['medicine'] ?? [];
          _workoutAlarms = data['exercise'] ?? [];
          _waterAlarms = data['water'] ?? [];
          _isLoading = false;
        });
      }
    } catch (e) {
      print('데이터 분류 실패: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // [수정] 알람 토글 (인자 4개 전달)
  Future<void> _toggleAlarm(Map<String, dynamic> alarm, bool newValue) async {
    final int id = alarm['notificationId'] ?? 0;
    final String label = alarm['title'] ?? '알람';
    final String time = alarm['time'] ?? '00:00:00';

    setState(() => alarm['checked'] = newValue);

    try {
      // 수정된 API 인자(4개)와 호출부를 일치시켰습니다.
      await AlarmSettingApi.updateAlarm(id, label, time, newValue);
    } catch (e) {
      setState(() => alarm['checked'] = !newValue);
      print('스위치 변경 실패: $e');
    }
  }

  // 알람 추가 로직 (Swagger 필드명 label 반영)
  Future<void> _addAlarm(String category, String title, String time) async {
    try {
      // 서버 전송 시 HH:mm:ss 형식을 맞추기 위해 :00 추가 가능
      await AlarmSettingApi.addAlarm(category, title, "$time:00");
      await _loadAlarms();

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('알람이 추가되었습니다.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('추가에 실패했습니다.')),
        );
      }
    }
  }



  // 알람 삭제
  Future<void> _deleteAlarm(int id) async {
    try {
      // await AlarmSettingApi.updateAlarm(id, label, time, newValue);
      await _loadAlarms();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('삭제에 실패했습니다.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text('알람 설정', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: _primaryColor))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildDynamicAlarmCard(
              title: '식단 알람',
              icon: Icons.rice_bowl,
              iconColor: Colors.orange,
              alarms: _dietAlarms,
              categoryKey: 'MEAL', // Swagger Enum 값
              emptyMsg: '등록된 식단 알람이 없습니다.',
            ),
            const SizedBox(height: 12),
            _buildDynamicAlarmCard(
              title: '약/영양제 알람',
              icon: Icons.medication,
              iconColor: Colors.deepPurpleAccent,
              alarms: _medAlarms,
              categoryKey: 'MEDICINE',
              emptyMsg: '등록된 영양제가 없습니다.',
            ),
            const SizedBox(height: 12),
            _buildDynamicAlarmCard(
              title: '운동 알람',
              icon: Icons.schedule,
              iconColor: Colors.black87,
              alarms: _workoutAlarms,
              categoryKey: 'EXERCISE',
              emptyMsg: '등록된 운동 알람이 없습니다.',
            ),
            const SizedBox(height: 12),
            _buildDynamicAlarmCard(
              title: '수분 섭취 알람',
              icon: Icons.water_drop_outlined,
              iconColor: _primaryColor,
              alarms: _waterAlarms,
              categoryKey: 'WATER',
              emptyMsg: '수분 섭취 알람이 없습니다.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDynamicAlarmCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required List<dynamic> alarms,
    required String categoryKey,
    required String emptyMsg,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: ExpansionTile(
        initiallyExpanded: true,
        leading: Icon(icon, color: iconColor),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: IconButton(
          icon: const Icon(Icons.add_circle_outline),
          onPressed: () => _showAddDialog(categoryKey, title),
        ),
        children: alarms.isEmpty
            ? [ListTile(title: Text(emptyMsg, style: const TextStyle(color: Colors.grey, fontSize: 13)))]
            : alarms.map((alarm) => _buildDynamicRow(alarm as Map<String, dynamic>)).toList(),
      ),
    );
  }

  Widget _buildDynamicRow(Map<String, dynamic> alarm) {
    // 서버 응답 필드명(title, time, checked, notificationId) 매핑
    final String content = alarm['title'] ?? '알람';
    final String time = alarm['time']?.substring(0, 5) ?? '00:00'; // HH:mm만 표시
    final bool isEnabled = alarm['checked'] ?? false;
    final int id = alarm['notificationId'] ?? 0;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      title: Text(content, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text("매일 $time"),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Switch(
            value: isEnabled,
            onChanged: (v) => _toggleAlarm(alarm, v),
            activeColor: _primaryColor,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.grey),
            onPressed: () => _deleteAlarm(id),
          ),
        ],
      ),
    );
  }

  void _showAddDialog(String category, String titlePrefix) {
    final TextEditingController contentController = TextEditingController();
    TimeOfDay selectedTime = const TimeOfDay(hour: 8, minute: 0);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          title: Text('$titlePrefix 추가'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: contentController, decoration: const InputDecoration(labelText: '내용')),
              ListTile(
                title: const Text("시간 설정"),
                trailing: Text("${selectedTime.hour}:${selectedTime.minute}"),
                onTap: () async {
                  final time = await showTimePicker(context: context, initialTime: selectedTime);
                  if (time != null) setStateDialog(() => selectedTime = time);
                },
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('취소')),
            TextButton(
              onPressed: () => _addAlarm(category, contentController.text, "${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}"),
              child: const Text('등록'),
            ),
          ],
        ),
      ),
    );
  }
}