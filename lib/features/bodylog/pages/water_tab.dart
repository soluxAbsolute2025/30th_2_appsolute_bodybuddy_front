import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../data/water_api_service.dart';
import '../data/water_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../common/common.dart';

class WaterTab extends StatefulWidget {
  const WaterTab({super.key});

  @override
  State<WaterTab> createState() => _WaterTabState();
}

// 애니메이션 구현을 위해 SingleTickerProviderStateMixin 추가
class _WaterTabState extends State<WaterTab> with SingleTickerProviderStateMixin {
  final WaterApiService _apiService = WaterApiService();
  static const String baseUrl = "http://52.79.228.227:8080";

  int _todayTotal = 0;
  int _goalAmount = 2000; // 기본값
  List<WaterLog> _logs = [];
  List<WaterDailyStat> _weeklyStats = [];
  bool _isLoading = false;

  // 물결 애니메이션 컨트롤러
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    // 애니메이션 초기화: 2초 동안 무한 반복
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _initializeData();
  }

  @override
  void dispose() {
    _waveController.dispose(); // 페이지 나갈 때 애니메이션 종료 (메모리 관리)
    super.dispose();
  }

  Future<void> _initializeData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    await _forceFixServerGoal();
    await _fetchData();
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _forceFixServerGoal() async {
    try {
      String? token = await Common.storage.read(key: 'accessToken');
      if (token == null) return;
      final url = Uri.parse('$baseUrl/api/users');
      final response = await http.patch(
        url,
        headers: {"Authorization": "Bearer $token", "Content-Type": "application/json"},
        body: jsonEncode({"dailyWaterGoal": 2000}),
      );
      if (response.statusCode != 200) {
        await http.put(
          url,
          headers: {"Authorization": "Bearer $token", "Content-Type": "application/json"},
          body: jsonEncode({"dailyWaterGoal": 2000}),
        );
      }
    } catch (e) {
      print("🔧 [목표 수정 실패]: $e");
    }
  }

  Future<void> _fetchData() async {
    try {
      await _fetchUserGoal();
      final logs = await _apiService.getTodayLogs();
      final weekly = await _apiService.getWeeklyStats();
      int sum = logs.fold(0, (prev, element) => prev + element.amount);
      if (mounted) {
        setState(() {
          _logs = logs;
          _todayTotal = sum;
          _weeklyStats = weekly;
        });
      }
    } catch (e) {
      print("데이터 로드 중 에러: $e");
    }
  }

  Future<void> _fetchUserGoal() async {
    try {
      String? token = await Common.storage.read(key: 'accessToken');
      if (token == null) return;
      final response = await http.get(
        Uri.parse('$baseUrl/api/users'),
        headers: {"Authorization": "Bearer $token"},
      );
      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final jsonResponse = jsonDecode(decodedBody);
        if (jsonResponse['data'] != null && jsonResponse['data']['dailyWaterGoal'] != null) {
          setState(() {
            _goalAmount = jsonResponse['data']['dailyWaterGoal'];
          });
        }
      }
    } catch (e) {
      print("목표 로드 실패: $e");
    }
  }

  Future<void> _addWater(int amount) async {
    if (_goalAmount <= 0) await _forceFixServerGoal();
    try {
      await _apiService.addWaterLog(amount);
      await _fetchData();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("추가 실패: 서버 연결 상태를 확인하세요.")),
      );
    }
  }

  Future<void> _deleteWater(int id) async {
    try {
      await _apiService.deleteWaterLog(id);
      await _fetchData();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("삭제 실패")));
    }
  }

  @override
  Widget build(BuildContext context) {
    double percent = _goalAmount > 0 ? (_todayTotal / _goalAmount).clamp(0.0, 1.0) : 0.0;
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
          _buildWaterProgress(percent, percentInt), // 수정된 위젯 호출
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${_todayTotal}ml', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(' / ${_goalAmount}ml', style: const TextStyle(fontSize: 16, color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 30),
          // 버튼 리스트 (기존 유지)
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
                _buildCustomInputButton(),
              ],
            ),
          ),
          const SizedBox(height: 40),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text('오늘의 기록', style: TextStyle(fontSize: 14, color: Colors.grey)),
          ),
          const SizedBox(height: 10),
          _buildLogList(),
          const SizedBox(height: 40),
          _buildWeeklyChart(),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  // --- 핵심 위젯: 물결 애니메이션 포함 ---
  // --- 핵심 위젯: 단순화된 물 게이지 ---
  Widget _buildWaterProgress(double percent, int percentInt) {
    const double outerSize = 180.0;
    const double innerSize = 134.0;

    return SizedBox(
      width: outerSize,
      height: outerSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 1. 바깥쪽 게이지 (정상 작동 확인용)
          Transform.rotate(
            angle: -math.pi / 2,
            child: SizedBox(
              width: outerSize,
              height: outerSize,
              child: CircularProgressIndicator(
                value: percent,
                strokeWidth: 10,
                color: const Color(0xFF4BECBE),
                backgroundColor: const Color(0xFFF5F5F5),
                strokeCap: StrokeCap.round,
              ),
            ),
          ),

          // 2. 내부 이미지 박스
          Container(
            width: innerSize,
            height: innerSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[50],
            ),
            child: ClipOval(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // (1) 물 아이콘 (차오르는 거 없이 그냥 꽉 채우기)
                  Align(
                    alignment: Alignment.bottomCenter, // 하단 정렬
                    child: SizedBox(
                      width: innerSize,
                      height: innerSize * 0.6, // 전체 원 높이의 60%만 차지
                      child: Image.asset(
                        'assets/bodylog/water_icon.png',
                        fit: BoxFit.cover, // 지정된 60% 영역 내에서 꽉 차게
                        alignment: Alignment.topCenter, // 물결의 윗부분이 잘리지 않게
                        errorBuilder: (c, e, s) => Container(color: Colors.blue.withOpacity(0.3)),
                      ),
                    ),
                  ),

                  // (2) 퍼센트 텍스트 (위치 더 위로 올림)
                  Positioned(
                    top: 15, // 숫자가 더 위로 가도록 고정값 부여
                    child: Text(
                      '$percentInt%',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00CFA5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- 나머지 UI 보조 위젯들 ---
  Widget _buildAddButton(String text, int amount) {
    return InkWell(
      onTap: () => _addWater(amount),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      ),
    );
  }

  Widget _buildCustomInputButton() {
    return InkWell(
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
    );
  }

  Widget _buildLogList() {
    if (_logs.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Text(_isLoading ? "데이터 동기화 중..." : "아직 기록이 없습니다.", style: const TextStyle(color: Colors.grey)),
      );
    }
    return ListView.builder(
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
    );
  }

  Widget _buildRecordItem(WaterLog log) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey[100]!)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [const Icon(Icons.water_drop, color: Color(0xFF4BECBE), size: 20), const SizedBox(width: 8), Text('${log.amount}ml', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))]),
          Row(children: [Text(log.time, style: const TextStyle(color: Colors.grey)), const SizedBox(width: 10), GestureDetector(onTap: () => _deleteWater(log.id), child: const Icon(Icons.close, size: 18, color: Colors.grey))]),
        ],
      ),
    );
  }

  Widget _buildWeeklyChart() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey[200]!), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('주간 수분 섭취량', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 20),
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, crossAxisAlignment: CrossAxisAlignment.end, children: _weeklyStats.isNotEmpty ? _weeklyStats.map((stat) => _buildBar(stat)).toList() : [const Text("데이터 없음", style: TextStyle(color: Colors.grey))]),
      ]),
    );
  }

  Widget _buildBar(WaterDailyStat stat) {
    double ratio = (stat.totalAmount / 2500).clamp(0.0, 1.0);
    if (stat.totalAmount > 0 && ratio < 0.1) ratio = 0.1;
    return Column(children: [Container(width: 8, height: 150 * ratio, decoration: BoxDecoration(color: const Color(0xFF4BECBE), borderRadius: BorderRadius.circular(10))), const SizedBox(height: 8), Text(stat.day, style: const TextStyle(fontSize: 12, color: Colors.grey))]);
  }

  void _showCustomInputDialog() {
    TextEditingController controller = TextEditingController();
    showDialog(context: context, builder: (context) => AlertDialog(title: const Text("수분 섭취량 입력"), content: TextField(controller: controller, keyboardType: TextInputType.number, decoration: const InputDecoration(suffixText: "ml", hintText: "예: 250")), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("취소")), TextButton(onPressed: () { int? amount = int.tryParse(controller.text); if (amount != null && amount > 0) { _addWater(amount); Navigator.pop(context); }}, child: const Text("저장", style: TextStyle(color: Color(0xFF4BECBE))))]));
  }
}