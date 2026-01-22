import 'package:flutter/material.dart';

class AlarmSettingScreen extends StatefulWidget {
  const AlarmSettingScreen({super.key});

  @override
  State<AlarmSettingScreen> createState() => _AlarmSettingScreenState();
}

class _AlarmSettingScreenState extends State<AlarmSettingScreen> {
  // 스위치 상태 관리 변수들
  bool _isBreakfastOn = true; // 아침 식사 (켜짐)
  bool _isLunchOn = false;    // 점심 식사
  bool _isDinnerOn = false;   // 저녁 식사

  // 테마 색상 (WaterTab에서 사용된 민트색)
  final Color _primaryColor = const Color(0xFF4BECBE);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // 전체 배경색 (연한 회색)
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true, // 타이틀 중앙 정렬
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 1. 식단 알람 (기본적으로 펼쳐져 있는 상태로 구현)
            _buildAlarmCard(
              title: '식단 알람',
              icon: Icons.rice_bowl, // 식사 아이콘 대체
              iconColor: Colors.orange,
              initiallyExpanded: true,
              children: [
                _buildSwitchRow(
                  title: '아침 식사 알람',
                  time: '매일 07:00',
                  value: _isBreakfastOn,
                  onChanged: (v) => setState(() => _isBreakfastOn = v),
                ),
                _buildDivider(),
                _buildSwitchRow(
                  title: '점심 식사 알람',
                  time: '매일 12:30',
                  value: _isLunchOn,
                  onChanged: (v) => setState(() => _isLunchOn = v),
                ),
                _buildDivider(),
                _buildSwitchRow(
                  title: '저녁 식사 알람',
                  time: '매일 18:00',
                  value: _isDinnerOn,
                  onChanged: (v) => setState(() => _isDinnerOn = v),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // 2. 약/영양제 알람
            _buildAlarmCard(
              title: '약/영양제 알람',
              icon: Icons.medication, // 알약 아이콘 대체
              iconColor: Colors.deepPurpleAccent,
              children: [], // 내용은 비워둠
            ),
            const SizedBox(height: 12),

            // 3. 운동 알람
            _buildAlarmCard(
              title: '운동 알람',
              icon: Icons.schedule, // 시계 아이콘 대체
              iconColor: Colors.black87,
              children: [],
            ),
            const SizedBox(height: 12),

            // 4. 수분 섭취 알람
            _buildAlarmCard(
              title: '수분 섭취 알람',
              icon: Icons.water_drop_outlined, // 물방울 아이콘
              iconColor: _primaryColor,
              children: [],
            ),
          ],
        ),
      ),
    );
  }

  // --- 위젯 빌더 헬퍼 메서드들 ---

  /// 흰색 둥근 배경의 확장 가능한 타일(Card)을 만드는 메서드
  Widget _buildAlarmCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    List<Widget> children = const [],
    bool initiallyExpanded = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Theme(
        // ExpansionTile의 위아래 구분선 제거를 위한 테마 설정
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: initiallyExpanded,
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          childrenPadding: const EdgeInsets.only(bottom: 20),
          // 아이콘
          leading: Icon(icon, color: iconColor, size: 24),
          // 제목
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          // 확장 아이콘 색상
          iconColor: Colors.grey,
          collapsedIconColor: Colors.grey,
          // 내부 컨텐츠
          children: children,
        ),
      ),
    );
  }

  /// 내부 스위치 행(Row)을 만드는 메서드
  Widget _buildSwitchRow({
    required String title,
    required String time,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                time,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          // 스위치 디자인 커스텀
          Transform.scale(
            scale: 0.9, // 스위치 크기를 살짝 줄임
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeColor: Colors.white, // 활성화 시 동그라미 색
              activeTrackColor: _primaryColor, // 활성화 시 배경 색 (민트)
              inactiveThumbColor: Colors.white, // 비활성화 시 동그라미 색
              inactiveTrackColor: Colors.grey[200], // 비활성화 시 배경 색
              trackOutlineColor: MaterialStateProperty.all(Colors.transparent), // 테두리 제거
            ),
          ),
        ],
      ),
    );
  }

  /// 항목 사이의 얇은 구분선
  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.grey[100],
      indent: 20,
      endIndent: 20,
    );
  }
}