import 'package:flutter/material.dart';
import 'package:bodybuddy_frontend/api/notification_api.dart';

class AlarmSettingScreen extends StatefulWidget {
  const AlarmSettingScreen({super.key});

  @override
  State<AlarmSettingScreen> createState() => _AlarmSettingScreenState();
}

class _AlarmSettingScreenState extends State<AlarmSettingScreen> {
  final Color _primaryColor = const Color(0xFF4BECBE);
  bool _isLoading = true;

  // 데이터 담을 리스트
  List<dynamic> _dietAlarms = [];
  List<dynamic> _medAlarms = [];
  List<dynamic> _workoutAlarms = [];
  List<dynamic> _waterAlarms = [];

  @override
  void initState() {
    super.initState();
    _loadAlarms(); // 화면 켜지면 데이터 로딩
  }

  // API 호출 및 데이터 분류
  Future<void> _loadAlarms() async {
    try {
      final alarms = await NotificationApi.getAlarms();

      if (mounted) {
        setState(() {
          // 서버 데이터의 category 값에 따라 분류 (서버 값 확인 필수: 'DIET', 'MEDICINE' 등)
          _dietAlarms = alarms.where((e) => e['category'] == 'DIET').toList();
          _medAlarms = alarms.where((e) => e['category'] == 'MEDICINE').toList();
          _workoutAlarms = alarms.where((e) => e['category'] == 'WORKOUT').toList();
          _waterAlarms = alarms.where((e) => e['category'] == 'WATER').toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      print('데이터 로딩 실패: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // [수정됨] 알람 추가 로직 (식단 포함 모든 카테고리 공통 사용)
  Future<void> _addAlarm(String category, String title, String time) async {
    try {
      await NotificationApi.addAlarm(category, title, time);

      // 성공 시 목록 새로고침
      await _loadAlarms();

      if (mounted) {
        Navigator.pop(context); // 다이얼로그 닫기 (이제 식단도 닫아야 함)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('알람이 추가되었습니다.')),
        );
      }
    } catch (e) {
      print('추가 실패: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('추가에 실패했습니다.')),
        );
      }
    }
  }

  // 알람 ON/OFF 토글
  Future<void> _toggleAlarm(Map<String, dynamic> alarm, bool newValue) async {
    final int id = alarm['alarmId'];

    // 1. UI 먼저 반응 (낙관적 업데이트)
    setState(() => alarm['isEnabled'] = newValue);

    try {
      // 2. 서버 요청
      await NotificationApi.updateAlarm(id, alarm['alarmTime'], newValue);
    } catch (e) {
      // 3. 실패 시 원상복구
      setState(() => alarm['isEnabled'] = !newValue);
      print('스위치 변경 실패: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('설정 변경에 실패했습니다.')),
        );
      }
    }
  }

  // 알람 삭제
  Future<void> _deleteAlarm(int id) async {
    try {
      await NotificationApi.deleteAlarm(id);
      await _loadAlarms(); // 목록 갱신
    } catch (e) {
      print('삭제 실패: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('삭제에 실패했습니다.')),
        );
      }
    }
  }

  // ----------------------------------------------------------------------
  // ▼ UI 빌드
  // ----------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '알람 설정',
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: _primaryColor))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 1. 식단 알람 (이제 동적 카드로 변경됨)
            _buildDynamicAlarmCard(
              title: '식단 알람',
              icon: Icons.rice_bowl,
              iconColor: Colors.orange,
              alarms: _dietAlarms,
              categoryKey: 'DIET', // 카테고리 키
              emptyMsg: '등록된 식단 알람이 없습니다.',
            ),
            const SizedBox(height: 12),

            // 2. 약/영양제 알람
            _buildDynamicAlarmCard(
              title: '약/영양제 알람',
              icon: Icons.medication,
              iconColor: Colors.deepPurpleAccent,
              alarms: _medAlarms,
              categoryKey: 'MEDICINE',
              emptyMsg: '등록된 영양제가 없습니다.',
            ),
            const SizedBox(height: 12),

            // 3. 운동 알람
            _buildDynamicAlarmCard(
              title: '운동 알람',
              icon: Icons.schedule,
              iconColor: Colors.black87,
              alarms: _workoutAlarms,
              categoryKey: 'WORKOUT',
              emptyMsg: '등록된 운동 알람이 없습니다.',
            ),
            const SizedBox(height: 12),

            // 4. 수분 섭취 알람
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

  // --- [공통] 동적 알람 카드 위젯 (식단, 약, 운동, 수분 모두 이걸 사용) ---
  Widget _buildDynamicAlarmCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required List<dynamic> alarms,
    required String categoryKey,
    required String emptyMsg,
  }) {
    return _buildBaseCard(
      title: title,
      icon: icon,
      iconColor: iconColor,
      // 우측 상단 + 버튼 (누르면 다이얼로그 뜸)
      trailing: IconButton(
        icon: const Icon(Icons.add_circle_outline, color: Colors.grey),
        onPressed: () => _showAddDialog(categoryKey, title),
      ),
      children: alarms.isEmpty
          ? [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            emptyMsg,
            style: const TextStyle(color: Colors.grey, fontSize: 13),
          ),
        )
      ]
          : alarms.asMap().entries.map((entry) {
        final index = entry.key;
        final alarm = entry.value;
        return Column(
          children: [
            _buildDynamicRow(alarm),
            // 마지막 항목이 아니면 구분선 추가
            if (index != alarms.length - 1) _buildDivider(),
          ],
        );
      }).toList(),
    );
  }

  // --- 기본 카드 프레임 ---
  Widget _buildBaseCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    List<Widget> children = const [],
    bool initiallyExpanded = true, // 기본적으로 펼쳐둠
    Widget? trailing,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: initiallyExpanded,
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          childrenPadding: const EdgeInsets.only(bottom: 20),
          leading: Icon(icon, color: iconColor, size: 24),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          iconColor: Colors.grey,
          collapsedIconColor: Colors.grey,
          trailing: trailing,
          children: children,
        ),
      ),
    );
  }

  // --- 동적 알람 Row (내용 + 시간 + 스위치 + 삭제버튼) ---
  Widget _buildDynamicRow(Map<String, dynamic> alarm) {
    final String content = alarm['content'] ?? '알람';
    final String time = alarm['alarmTime'] ?? '00:00';
    final bool isEnabled = alarm['isEnabled'] ?? false;
    final int id = alarm['alarmId'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 텍스트 영역
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  content,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  "매일 $time",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          // 컨트롤 영역
          Row(
            children: [
              Transform.scale(
                scale: 0.9,
                child: Switch(
                  value: isEnabled,
                  onChanged: (v) => _toggleAlarm(alarm, v),
                  activeColor: Colors.white,
                  activeTrackColor: _primaryColor,
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: Colors.grey[200],
                  trackOutlineColor: MaterialStateProperty.all(Colors.transparent),
                ),
              ),
              const SizedBox(width: 8),
              // 삭제 아이콘
              GestureDetector(
                onTap: () => _deleteAlarm(id),
                child: const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Icon(Icons.delete_outline_rounded,
                      color: Colors.grey, size: 20),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
        height: 1,
        thickness: 1,
        color: Colors.grey[100],
        indent: 20,
        endIndent: 20);
  }

  // --- 알람 추가 다이얼로그 ---
  void _showAddDialog(String category, String titlePrefix) {
    final TextEditingController contentController = TextEditingController();
    TimeOfDay selectedTime = const TimeOfDay(hour: 8, minute: 0);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Text('$titlePrefix 추가',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: contentController,
                    decoration: InputDecoration(
                      labelText: '내용 (예: 아침 식사, 비타민)',
                      labelStyle: TextStyle(color: Colors.grey[600]),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: _primaryColor)),
                    ),
                    cursorColor: _primaryColor,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('시간 설정', style: TextStyle(fontSize: 15)),
                      TextButton(
                        onPressed: () async {
                          final TimeOfDay? time = await showTimePicker(
                            context: context,
                            initialTime: selectedTime,
                            builder: (context, child) {
                              return Theme(
                                data: ThemeData.light().copyWith(
                                  colorScheme:
                                  ColorScheme.light(primary: _primaryColor),
                                  timePickerTheme: TimePickerThemeData(
                                    dialHandColor: _primaryColor,
                                    dialBackgroundColor: Colors.grey[200],
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (time != null) {
                            setStateDialog(() => selectedTime = time);
                          }
                        },
                        child: Text(
                          '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}',
                          style: TextStyle(
                              color: _primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('취소', style: TextStyle(color: Colors.grey)),
                ),
                TextButton(
                  onPressed: () {
                    if (contentController.text.isNotEmpty) {
                      final timeStr =
                          '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}';

                      // API 호출
                      _addAlarm(category, contentController.text, timeStr);
                    }
                  },
                  child: Text('등록',
                      style: TextStyle(
                          color: _primaryColor, fontWeight: FontWeight.bold)),
                ),
              ],
            );
          },
        );
      },
    );
  }
}