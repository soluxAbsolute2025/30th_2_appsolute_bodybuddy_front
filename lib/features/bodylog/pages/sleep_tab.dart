// lib/features/bodylog/pages/sleep_tab.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/sleep_api_service.dart';
import '../data/sleep_model.dart';
import 'sleep_edit_page.dart';
import '../../../common/common.dart';

class SleepTab extends StatefulWidget {
  const SleepTab({super.key});

  @override
  State<SleepTab> createState() => _SleepTabState();
}

class _SleepTabState extends State<SleepTab> {
  final SleepApiService _apiService = SleepApiService();

  DateTime _selectedDate = DateTime.now();
  SleepRecord? _todaySleep; // 받아온 데이터
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSleepData();
  }

  Future<void> _loadSleepData() async {
    setState(() => _isLoading = true);
    String dateStr = DateFormat('yyyy-MM-dd').format(_selectedDate);

    final data = await _apiService.getSleepLog(dateStr);

    setState(() {
      _todaySleep = data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // (1) 상단 그라데이션 배너
          _buildTopBanner(),

          // (2) 메인 컨텐츠 영역
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDateHeader(), // 날짜 이동 버튼 추가
                const SizedBox(height: 20),

                const Text('수면 기록', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 15),

                // 데이터 로딩 상태 처리
                if (_isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (_todaySleep == null)
                  _buildEmptyState()
                else
                  _buildSleepDetailCard(),

                const SizedBox(height: 20),

                // 수면 품질 카드 (데이터 있을 때만 표시)
                if (_todaySleep != null)
                  _buildQualityCard(),

                const SizedBox(height: 40),

                // 주간 패턴 (일단 하드코딩 유지, 추후 API 연결 필요)
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
          const Text('오늘은', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
          const SizedBox(height: 5),
          RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 24, color: Colors.black, height: 1.3),
              children: [
                TextSpan(
                  text: _todaySleep?.durationString ?? '0시간',
                  style: const TextStyle(color: Color(0xFF4BECBE), fontWeight: FontWeight.bold),
                ),
                const TextSpan(text: '\n잤어요', style: TextStyle(fontWeight: FontWeight.w500)),
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

  // 수면 상세 정보 카드
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
              const SizedBox(width: 4),
              GestureDetector(
                onTap: () => _navigateAndRefresh(record: _todaySleep),
                child: const Icon(Icons.edit, size: 16, color: Colors.grey),
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
              _SleepTimeItem(title: '취침 시간', time: _todaySleep!.sleepTime),
              _SleepTimeItem(title: '기상 시간', time: _todaySleep!.wakeTime),
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

  // 차트 (디자인 유지)
  Widget _buildWeeklyChart() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('주간 수면 패턴', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildBar('월', 0.6),
              _buildBar('화', 0.5),
              _buildBar('수', 0.7),
              _buildBar('목', 0.8),
              _buildBar('금', 0.4),
              _buildBar('토', 0.9),
              _buildBar('일', 0.7),
            ],
          ),
        ],
      ),
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

  Widget _buildBar(String day, double heightRatio) {
    return Column(
      children: [
        Container(
          width: 8,
          height: 100 * heightRatio,
          decoration: BoxDecoration(
            color: const Color(0xFF4BECBE),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        const SizedBox(height: 8),
        Text(day, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  // 화면 이동 및 새로고침
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
        Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(time, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      ],
    );
  }
}