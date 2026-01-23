// lib/features/bodylog/pages/sleep_tab.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/sleep_api_service.dart';
import '../data/sleep_model.dart';
import 'sleep_edit_page.dart';

class SleepTab extends StatefulWidget {
  const SleepTab({super.key});

  @override
  State<SleepTab> createState() => _SleepTabState();
}

class _SleepTabState extends State<SleepTab> {
  final SleepApiService _apiService = SleepApiService();

  DateTime _selectedDate = DateTime.now();
  SleepRecord? _todaySleep;       // 오늘 하루 데이터
  WeeklySleepStats? _weeklyStats; // 주간 데이터 (그래프용)
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSleepData(); // 앱 시작 시 데이터 로드
  }

  // 데이터 불러오기 (하루 기록 + 주간 기록 동시에)
  Future<void> _loadSleepData() async {
    setState(() => _isLoading = true);

    try {
      // 1. 선택된 날짜의 하루 기록 가져오기
      String dateStr = DateFormat('yyyy-MM-dd').format(_selectedDate);
      final dayData = await _apiService.getSleepLog(dateStr);

      // 2. 주간 데이터 가져오기 (해당 주 월요일 ~ 일요일 계산)
      DateTime monday = _selectedDate.subtract(Duration(days: _selectedDate.weekday - 1));
      DateTime sunday = monday.add(const Duration(days: 6));

      String startStr = DateFormat('yyyy-MM-dd').format(monday);
      String endStr = DateFormat('yyyy-MM-dd').format(sunday);

      final weekData = await _apiService.getWeeklySleepLog(startStr, endStr);

      setState(() {
        _todaySleep = dayData;
        _weeklyStats = weekData;
        _isLoading = false;
      });
    } catch (e) {
      print("데이터 로드 중 오류 발생: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildTopBanner(),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDateHeader(),
                const SizedBox(height: 20),
                const Text('수면 기록', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 15),

                // 로딩 중이거나 데이터 유무에 따른 화면 처리
                if (_isLoading)
                  const SizedBox(height: 100, child: Center(child: CircularProgressIndicator()))
                else if (_todaySleep == null)
                  _buildEmptyState()
                else
                  _buildSleepDetailCard(),

                const SizedBox(height: 20),

                // 수면 품질 카드
                if (_todaySleep != null)
                  _buildQualityCard(),

                const SizedBox(height: 40),

                // 주간 차트 (데이터가 있을 때만 표시)
                if (_weeklyStats != null)
                  _buildWeeklyChart(),

                const SizedBox(height: 80),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 상단 배너
  Widget _buildTopBanner() {
    bool isToday = DateFormat('yyyy-MM-dd').format(_selectedDate) ==
        DateFormat('yyyy-MM-dd').format(DateTime.now());

    String dateText = isToday
        ? '오늘은'
        : DateFormat('M월 d일은').format(_selectedDate);

    String timeText = _todaySleep?.durationString ?? '0시간';
    String suffixText = (_todaySleep == null) ? '기록이 없어요' : '잤어요';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 40),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFFFBE6), Color(0xFFE0FCF6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(dateText, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
          const SizedBox(height: 5),

          if (_todaySleep == null)
            Text(suffixText, style: const TextStyle(fontSize: 24, color: Colors.grey, fontWeight: FontWeight.bold))
          else
            RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 24, color: Colors.black, height: 1.3),
                children: [
                  TextSpan(
                    text: timeText,
                    style: const TextStyle(color: Color(0xFF4BECBE), fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: '\n$suffixText', style: const TextStyle(fontWeight: FontWeight.w500)),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // 날짜 이동 헤더
  Widget _buildDateHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 18),
          onPressed: () {
            setState(() => _selectedDate = _selectedDate.subtract(const Duration(days: 1)));
            _loadSleepData();
          },
        ),
        Text(
          DateFormat('yyyy년 MM월 dd일').format(_selectedDate),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward_ios, size: 18),
          onPressed: () {
            setState(() => _selectedDate = _selectedDate.add(const Duration(days: 1)));
            _loadSleepData();
          },
        ),
      ],
    );
  }

  // 데이터 없을 때 표시
  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(30),
      width: double.infinity,
      decoration: _boxDecoration(),
      child: Column(
        children: [
          const Text('기록된 수면 데이터가 없어요.', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => _navigateAndRefresh(),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4BECBE),
              foregroundColor: Colors.white,
            ),
            child: const Text('수면 기록하기'),
          ),
        ],
      ),
    );
  }

  // 상세 정보 카드
  Widget _buildSleepDetailCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.nightlight_round, color: Color(0xFF4BECBE), size: 20),
              const SizedBox(width: 8),
              const Text('간밤의 수면', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const Spacer(),
              GestureDetector(
                onTap: () => _navigateAndRefresh(record: _todaySleep),
                child: const Icon(Icons.edit, size: 20, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(_todaySleep!.durationString,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF4BECBE))),
          const SizedBox(height: 20),
          const Divider(color: Colors.grey, thickness: 0.2),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _SleepTimeItem(
                title: '취침 시간',
                time: _formatTime(_todaySleep!.bedTime),
              ),
              _SleepTimeItem(
                title: '기상 시간',
                time: _formatTime(_todaySleep!.wakeTime),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 수면 품질 카드
  Widget _buildQualityCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: _boxDecoration(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('수면 품질', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFE0FCF6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(_todaySleep!.qualityKor,
                style: const TextStyle(color: Color(0xFF4BECBE), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // 주간 차트
  Widget _buildWeeklyChart() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('주간 수면 패턴', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              // 평균 시간 표시
              if (_weeklyStats != null)
                Text(
                  '평균 ${_weeklyStats!.averageSleepHours}시간',
                  style: const TextStyle(color: Color(0xFF4BECBE), fontWeight: FontWeight.bold),
                ),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildRealBar('월', 1),
              _buildRealBar('화', 2),
              _buildRealBar('수', 3),
              _buildRealBar('목', 4),
              _buildRealBar('금', 5),
              _buildRealBar('토', 6),
              _buildRealBar('일', 7),
            ],
          ),
        ],
      ),
    );
  }

  // 요일별 막대 생성 로직
  Widget _buildRealBar(String dayLabel, int targetWeekday) {
    SleepRecord? record;
    if (_weeklyStats != null) {
      try {
        record = _weeklyStats!.dailyLogs.firstWhere((log) {
          DateTime logDate = DateTime.parse(log.sleepDate);
          return logDate.weekday == targetWeekday;
        });
      } catch (e) {
        record = null;
      }
    }

    double totalMinutes = record?.totalSleepMinute.toDouble() ?? 0;
    double maxMinutes = 600.0;
    double heightRatio = (totalMinutes / maxMinutes).clamp(0.0, 1.0);

    if (totalMinutes > 0 && heightRatio < 0.1) heightRatio = 0.1;

    bool isSelectedDay = _selectedDate.weekday == targetWeekday;

    return Column(
      children: [
        if (totalMinutes > 0)
          Text(
            "${(totalMinutes / 60).toStringAsFixed(1)}h",
            style: const TextStyle(fontSize: 10, color: Colors.grey),
          ),
        const SizedBox(height: 4),
        Container(
          width: 8,
          height: 100 * heightRatio,
          decoration: BoxDecoration(
            color: isSelectedDay ? const Color(0xFF4BECBE) : const Color(0xFFE0E0E0),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        const SizedBox(height: 8),
        Text(dayLabel, style: TextStyle(fontSize: 12, color: isSelectedDay ? Colors.black : Colors.grey)),
      ],
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.grey[200]!),
      boxShadow: [
        BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5)),
      ],
    );
  }

  String _formatTime(String time) {
    if (time.length >= 5) {
      return time.substring(0, 5);
    }
    return time;
  }

  Future<void> _navigateAndRefresh({SleepRecord? record}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SleepEditPage(
          record: record,
          selectedDate: _selectedDate,
        ),
      ),
    );

    if (result == true) {
      _loadSleepData();
    }
  }
} // ★ _SleepTabState 여기서 닫힘 (중요!)

// ★ _SleepTimeItem은 클래스 밖에서 정의
class _SleepTimeItem extends StatelessWidget {
  final String title;
  final String time;
  const _SleepTimeItem({required this.title, required this.time});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(time, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      ],
    );
  }
}