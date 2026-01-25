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
  SleepRecord? _todaySleep;
  WeeklySleepStats? _weeklyStats;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSleepData();
  }

  Future<void> _loadSleepData() async {
    setState(() => _isLoading = true);
    try {
      String dateStr = DateFormat('yyyy-MM-dd').format(_selectedDate);
      final dayData = await _apiService.getSleepLog(dateStr);

      // 월요일 ~ 일요일 계산
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
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildTopBanner(), // 가이드 디자인 반영
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDateHeader(),
                  const SizedBox(height: 20),
                  const Text('수면 기록', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),

                  if (_isLoading)
                    const SizedBox(height: 150, child: Center(child: CircularProgressIndicator(color: Color(0xFF4BECBE))))
                  else if (_todaySleep == null)
                    _buildEmptyState()
                  else
                    _buildSleepDetailCard(), // 가이드 디자인 반영

                  const SizedBox(height: 15),
                  if (_todaySleep != null) _buildQualityCard(),

                  const SizedBox(height: 40),
                  _buildWeeklyChart(), // 주간 패턴 디자인 반영
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
      // 이미지 하단에 있는 AI 케어 버튼 재현
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: const Color(0xFFE0FCF6),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        icon: const Icon(Icons.auto_awesome, size: 18, color: Color(0xFF4BECBE)),
        label: const Text('AI 케어', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
      ),
    );
  }

  // --- 가이드의 파스텔 톤 배너 디자인 ---
  Widget _buildTopBanner() {
    String timeText = _todaySleep?.durationString ?? '0시간 0분';

    return Container(
      width: double.infinity,
      height: 240,
      padding: const EdgeInsets.fromLTRB(30, 60, 20, 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFFFBE6), Color(0xFFE0FCF6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('오늘은', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(
            timeText,
            style: const TextStyle(fontSize: 36, color: Color(0xFF4BECBE), fontWeight: FontWeight.bold),
          ),
          const Text('잤어요', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildDateHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(icon: const Icon(Icons.chevron_left), onPressed: () {
            setState(() => _selectedDate = _selectedDate.subtract(const Duration(days: 1)));
            _loadSleepData();
          }),
          Text(DateFormat('MM월 dd일').format(_selectedDate), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          IconButton(icon: const Icon(Icons.chevron_right), onPressed: () {
            setState(() => _selectedDate = _selectedDate.add(const Duration(days: 1)));
            _loadSleepData();
          }),
        ],
      ),
    );
  }

  // --- 수면 기록 상세 카드 ---
  Widget _buildSleepDetailCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.nightlight_outlined, color: Color(0xFF4BECBE), size: 22),
              const SizedBox(width: 8),
              const Text('어젯밤 수면', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(width: 6),
              GestureDetector(
                onTap: () => _navigateAndRefresh(record: _todaySleep),
                child: const Icon(Icons.edit_outlined, size: 18, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            _todaySleep!.durationString,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF4BECBE)),
          ),
          const SizedBox(height: 20),
          const Divider(height: 1, color: Color(0xFFF0F0F0)),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _SleepTimeItem(title: '취침 시간', time: _formatTime(_todaySleep!.bedTime))),
              Expanded(child: _SleepTimeItem(title: '기상 시간', time: _formatTime(_todaySleep!.wakeTime))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQualityCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: _boxDecoration(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('수면 품질', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(color: const Color(0xFFE0FCF6), borderRadius: BorderRadius.circular(10)),
            child: Text(_todaySleep!.qualityKor, style: const TextStyle(color: Color(0xFF4BECBE), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // --- 주간 차트 디자인 ---
  Widget _buildWeeklyChart() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('주간 수면 패턴', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildRealBar('25', 1),
              _buildRealBar('26', 2),
              _buildRealBar('27', 3),
              _buildRealBar('28', 4),
              _buildRealBar('29', 5),
              _buildRealBar('30', 6),
              _buildRealBar('31', 7),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRealBar(String dayLabel, int targetWeekday) {
    double totalMinutes = 0;
    if (_weeklyStats != null) {
      try {
        final log = _weeklyStats!.dailyLogs.firstWhere((l) => DateTime.parse(l.sleepDate).weekday == targetWeekday);
        totalMinutes = log.totalSleepMinute.toDouble();
      } catch (_) {}
    }

    double heightRatio = (totalMinutes / 600.0).clamp(0.05, 1.0);
    bool isSelected = _selectedDate.weekday == targetWeekday;

    return Column(
      children: [
        Container(
          width: 10,
          height: 120 * heightRatio,
          decoration: BoxDecoration(
            color: const Color(0xFF4BECBE), // 가이드 이미지처럼 민트색 막대
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        const SizedBox(height: 8),
        Text(dayLabel, style: TextStyle(fontSize: 12, color: isSelected ? Colors.black : Colors.grey)),
      ],
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: const Color(0xFFF0F0F0)),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
    );
  }

  String _formatTime(String time) {
    if (time.length >= 5) return time.substring(0, 5);
    return time;
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(30),
      width: double.infinity,
      decoration: _boxDecoration(),
      child: Column(
        children: [
          const Text('기록된 데이터가 없어요.', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () => _navigateAndRefresh(),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4BECBE), foregroundColor: Colors.white),
            child: const Text('수면 기록하기'),
          ),
        ],
      ),
    );
  }

  Future<void> _navigateAndRefresh({SleepRecord? record}) async {
    final result = await Navigator.push(context, MaterialPageRoute(builder: (_) => SleepEditPage(record: record, selectedDate: _selectedDate)));
    if (result == true) _loadSleepData();
  }
}

class _SleepTimeItem extends StatelessWidget {
  final String title;
  final String time;
  const _SleepTimeItem({required this.title, required this.time});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 13, color: Colors.grey)),
        const SizedBox(height: 6),
        Text(time, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
      ],
    );
  }
}