// lib/features/bodylog/pages/water_tab.dart

import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../data/water_api_service.dart';
import '../data/water_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // 날짜 포맷팅을 위해 추가 (pubspec.yaml에 intl 없으면 기본 DateTime 사용)
import '../../../common/common.dart';

class WaterTab extends StatefulWidget {
  const WaterTab({super.key});

  @override
  State<WaterTab> createState() => _WaterTabState();
}

class _WaterTabState extends State<WaterTab> {
  final WaterApiService _apiService = WaterApiService();

  // 상태 변수
  int _todayTotal = 0;
  final int _goalAmount = 2000; // 목표량 (추후 사용자 정보에서 가져오기)
  List<WaterLog> _logs = [];
  List<WaterDailyStat> _weeklyStats = []; // 주간 차트 데이터
  bool _isLoading = false;
  final String _baseUrl = "http://52.79.228.227:8080";
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  // 데이터 통합 로드
  Future<void> _fetchData() async {
    setState(() => _isLoading = true);

    // 1. 오늘 기록 가져오기
    final logs = await _apiService.getTodayLogs();

    // 2. 총량 계산
    int sum = logs.fold(0, (prev, element) => prev + element.amount);

    // 3. 주간 통계 가져오기
    final weekly = await _apiService.getWeeklyStats();

    setState(() {
      _logs = logs;
      _todayTotal = sum;
      _weeklyStats = weekly;
      _isLoading = false;
    });
  }

  // 물 추가
  Future<void> _addWater(int amount) async {
    try {
      await _apiService.addWaterLog(amount);
      _fetchData(); // 성공 후 새로고침
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("저장 실패")));
    }
  }

  // 기록 삭제
  Future<void> _deleteWater(int id) async {
    try {
      await _apiService.deleteWaterLog(id);
      _fetchData(); // 성공 후 새로고침
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("삭제 실패")));
    }
  }

  @override
  Widget build(BuildContext context) {
    // 퍼센트 계산
    double percent = (_todayTotal / _goalAmount).clamp(0.0, 1.0);
    int percentInt = (percent * 100).toInt();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text('오늘의 수분 섭취', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 30),

          // 1. 물결 애니메이션 & 원형 그래프
          _buildWaterProgress(percent, percentInt),

          const SizedBox(height: 20),

          // 텍스트 (섭취량 / 목표)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${_todayTotal}ml', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(' / ${_goalAmount}ml', style: const TextStyle(fontSize: 16, color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 30),

          // 2. 추가 버튼들
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildAddButton('+ 200ml', 200),
                const SizedBox(width: 12),
                _buildAddButton('+ 300ml', 300),
                const SizedBox(width: 12),
                _buildAddButton('+ 500ml', 500),
                const SizedBox(width: 12),
                // 직접 입력
                InkWell(
                  onTap: _showCustomInputDialog,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 16, color: Colors.grey[700]),
                        const SizedBox(width: 6),
                        const Text('직접입력', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),

          // 3. 오늘의 기록 리스트
          const Align(
            alignment: Alignment.centerLeft,
            child: Text('오늘의 기록', style: TextStyle(fontSize: 14, color: Colors.grey)),
          ),
          const SizedBox(height: 10),

          if (_logs.isEmpty)
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(_isLoading ? "로딩 중..." : "아직 기록이 없습니다.", style: const TextStyle(color: Colors.grey)),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _logs.length,
              itemBuilder: (context, index) {
                final log = _logs[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _buildRecordItem(log),
                );
              },
            ),

          const SizedBox(height: 40),

          // 4. 주간 차트 (데이터 연동됨)
          _buildWeeklyChart(),

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  // --- 위젯 분리 ---

  Widget _buildWaterProgress(double percent, int percentInt) {
    return SizedBox(
      width: 180,
      height: 180,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey[50]),
            child: ClipOval(
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  // 배경 이미지
                  Image.asset(
                    'assets/bodylog/water_back.png',
                    width: 150, height: 150, fit: BoxFit.cover,
                    errorBuilder: (ctx, err, stack) => Container(color: const Color(0xFFE0F7FA)),
                  ),
                  // 물 차오르는 효과
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 150 * percent,
                      width: 150,
                      color: const Color(0xFF4BECBE).withOpacity(0.3),
                      child: Image.asset(
                        'assets/bodylog/water_front.png',
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, err, stack) => const SizedBox(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // 퍼센트 텍스트
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Text(
                '$percentInt%',
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF4BECBE)),
              ),
            ),
          ),
          // 원형 인디케이터
          SizedBox(
            width: 150,
            height: 150,
            child: Transform.rotate(
              angle: -math.pi / 2,
              child: CircularProgressIndicator(
                value: percent,
                strokeWidth: 10,
                color: const Color(0xFF4BECBE),
                backgroundColor: const Color(0xFFF5F5F5),
                strokeCap: StrokeCap.round,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton(String text, int amount) {
    return InkWell(
      onTap: () => _addWater(amount),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      ),
    );
  }

  Widget _buildRecordItem(WaterLog log) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[100]!)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.water_drop, color: Color(0xFF4BECBE), size: 20),
              const SizedBox(width: 8),
              Text('${log.amount}ml', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          Row(
            children: [
              Text(log.time, style: const TextStyle(color: Colors.grey)),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () => _deleteWater(log.id),
                child: const Icon(Icons.close, size: 18, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 주간 차트 (실제 데이터 반영)
  Widget _buildWeeklyChart() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('주간 수분 섭취량', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: _weeklyStats.isNotEmpty
                ? _weeklyStats.map((stat) => _buildBar(stat)).toList()
                : [const Text("데이터 없음", style: TextStyle(color: Colors.grey))],
          ),
        ],
      ),
    );
  }

  Widget _buildBar(WaterDailyStat stat) {
    // 최대치 2500ml 기준으로 높이 비율 계산 (최대 1.0)
    double ratio = (stat.totalAmount / 2500).clamp(0.0, 1.0);
    // 최소 높이는 보이게 처리
    if (stat.totalAmount > 0 && ratio < 0.1) ratio = 0.1;

    return Column(
      children: [
        Container(
          width: 8,
          height: 150 * ratio, // 비율에 따른 높이
          decoration: BoxDecoration(
            color: const Color(0xFF4BECBE),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        const SizedBox(height: 8),
        Text(stat.day, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  void _showCustomInputDialog() {
    TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("수분 섭취량 입력"),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(suffixText: "ml", hintText: "예: 250"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("취소")),
          TextButton(
            onPressed: () {
              int? amount = int.tryParse(controller.text);
              if (amount != null && amount > 0) {
                _addWater(amount);
                Navigator.pop(context);
              }
            },
            child: const Text("저장", style: TextStyle(color: Color(0xFF4BECBE))),
          ),
        ],
      ),
    );
  }
}