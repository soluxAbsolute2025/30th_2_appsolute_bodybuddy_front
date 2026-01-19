import 'package:flutter/material.dart';
import 'dart:math' as math;
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
  // 1. 상태 변수들
  int _todayTotal = 0; // 오늘 총 섭취량
  final int _goalAmount = 2000; // 목표량
  List<dynamic> _logs = []; // 오늘 기록 리스트
  Map<String, int> _weeklyData = {}; // 주간 데이터 (날짜: 섭취량)
  bool _isLoading = false;

  final String _baseUrl = "http://52.79.228.227:8080";

  @override
  void initState() {
    super.initState();
    _fetchAllData(); // 초기 데이터 로드
  }

  // 데이터 한 번에 새로고침 (오늘 기록 + 주간 기록)
  Future<void> _fetchAllData() async {
    await _fetchTodayData();
    await _fetchWeeklyData();
  }

  // --- [API] 1. 오늘 기록 가져오기 (GET /api/water-log/today) ---
  Future<void> _fetchTodayData() async {
    if (Common.token == null) return;
    if (!mounted) return;

    setState(() => _isLoading = true);

    try {
      final url = Uri.parse('$_baseUrl/api/water-log/today');
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${Common.token}",
          "TimeZone": "Asia/Seoul", // ★ 명세서 필수 헤더 추가
        },
      );

      if (response.statusCode == 200) {
        // 명세서: [{"waterLogId": 101, "amountMl": 500, "loggedAt": "..."}]
        final List<dynamic> data = jsonDecode(response.body);

        int sum = 0;
        for (var item in data) {
          sum += (item['amountMl'] as int); // ★ amount -> amountMl 로 변경
        }

        setState(() {
          _logs = data;
          _todayTotal = sum;
        });
      } else {
        print("❌ 오늘 기록 로드 실패: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ 네트워크 에러(Today): $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // --- [API] 2. 주간 기록 가져오기 (GET /api/water-log/weekly) ---
  Future<void> _fetchWeeklyData() async {
    if (Common.token == null) return;

    try {
      final url = Uri.parse('$_baseUrl/api/water-log/weekly');
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${Common.token}",
          "TimeZone": "Asia/Seoul", // ★ 필수 헤더
        },
      );

      if (response.statusCode == 200) {
        // 명세서: {"2025-12-24": 1000, "2025-12-30": 500}
        final Map<String, dynamic> rawData = jsonDecode(response.body);

        // dynamic 값을 int로 안전하게 변환
        Map<String, int> parsedData = {};
        rawData.forEach((key, value) {
          parsedData[key] = value as int;
        });

        setState(() {
          _weeklyData = parsedData;
        });
      } else {
        print("❌ 주간 기록 로드 실패: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ 네트워크 에러(Weekly): $e");
    }
  }

  // --- [API] 3. 기록 추가하기 (POST /api/water-log) ---
  Future<void> _addWaterLog(int amount) async {
    if (Common.token == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("로그인이 필요합니다.")));
      return;
    }

    // 날짜 포맷: YYYY-MM-DD
    DateTime now = DateTime.now();
    String todayDate = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    try {
      final url = Uri.parse('$_baseUrl/api/water-log');

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${Common.token}",
        },
        body: jsonEncode({
          "mlAmount": amount,      // ★ amount -> mlAmount
          "recordDate": todayDate, // ★ 필수 필드
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("✅ 저장 성공");
        _fetchAllData(); // 데이터 새로고침 (오늘 + 주간)
      } else {
        print("❌ 저장 실패: ${utf8.decode(response.bodyBytes)}");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("저장 실패: ${utf8.decode(response.bodyBytes)}")));
        }
      }
    } catch (e) {
      print("❌ 네트워크 에러(Add): $e");
    }
  }

  // --- [API] 4. 기록 삭제하기 (DELETE /api/water-log/{id}) ---
  Future<void> _deleteWaterLog(int waterLogId) async {
    try {
      final url = Uri.parse('$_baseUrl/api/water-log/$waterLogId');
      final response = await http.delete(
        url,
        headers: {
          "Authorization": "Bearer ${Common.token}",
        },
      );

      if (response.statusCode == 200) {
        print("✅ 삭제 성공");
        _fetchAllData(); // 새로고침
      } else {
        print("❌ 삭제 실패: ${response.body}");
      }
    } catch (e) {
      print("삭제 에러: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    double percent = (_todayTotal / _goalAmount).clamp(0.0, 1.0);
    int percentInt = (percent * 100).toInt();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 10),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text('오늘의 수분 섭취', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 30),

          // 1. 원형 그래프 UI (기존 동일)
          SizedBox(
            width: 180,
            height: 180,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 150, height: 150,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey[50]),
                  child: ClipOval(
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Image.asset(
                          'assets/bodylog/water_back.png',
                          width: 150, height: 150, fit: BoxFit.cover,
                          errorBuilder: (ctx, err, stack) => Container(color: const Color(0xFFE0F7FA)),
                        ),
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
                SizedBox(
                  width: 150, height: 150,
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
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${_todayTotal}ml', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(' / ${_goalAmount}ml', style: const TextStyle(fontSize: 16, color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 30),

          // 2. 버튼 리스트
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

          _logs.isEmpty
              ? const Padding(
            padding: EdgeInsets.all(20),
            child: Text("오늘 마신 물이 없어요!", style: TextStyle(color: Colors.grey)),
          )
              : ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _logs.length,
            itemBuilder: (context, index) {
              final log = _logs[index];

              // ★ 명세서대로 필드명 변경 적용
              final int id = log['waterLogId'];
              final int amount = log['amountMl'];
              final String rawTime = log['loggedAt'] ?? "";

              String time = "-";
              // 2025-12-30T00:00:00 형식이면 T 뒤에 시간만 자르기
              if (rawTime.contains("T")) {
                time = rawTime.split("T")[1].substring(0, 5); // 00:00
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _buildRecordItem(id, '${amount}ml', time),
              );
            },
          ),

          const SizedBox(height: 40),

          // 4. 주간 수분 섭취량 (실제 데이터 반영)
          Container(
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
                // 차트 그리기
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: _buildWeeklyBars(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  // --- 주간 차트 빌더 ---
  List<Widget> _buildWeeklyBars() {
    List<Widget> bars = [];
    DateTime now = DateTime.now();

    // 오늘부터 6일 전까지 (총 7일) 반복
    for (int i = 6; i >= 0; i--) {
      DateTime date = now.subtract(Duration(days: i));
      String dateKey = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

      // 해당 날짜의 데이터 가져오기 (없으면 0)
      int amount = _weeklyData[dateKey] ?? 0;

      // 높이 비율 (최대 3000ml 기준)
      double heightRatio = (amount / 3000).clamp(0.0, 1.0);
      // 최소 높이는 보이게 설정 (데이터가 있으면)
      if (amount > 0 && heightRatio < 0.1) heightRatio = 0.1;

      bars.add(_buildBar(date.day.toString(), heightRatio, amount));
    }
    return bars;
  }

  Widget _buildBar(String day, double heightRatio, int amount) {
    return Column(
      children: [
        // 툴팁처럼 양을 표시하고 싶으면 여기에 Text 추가 가능
        Container(
          width: 8,
          height: 150 * heightRatio, // 최대 높이 150
          decoration: BoxDecoration(
            color: amount > 0 ? const Color(0xFF4BECBE) : Colors.grey[300], // 데이터 없으면 회색
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        const SizedBox(height: 8),
        Text(day, style: const TextStyle(fontSize: 12, color: Colors.grey)),
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
                _addWaterLog(amount);
                Navigator.pop(context);
              }
            },
            child: const Text("저장", style: TextStyle(color: Color(0xFF4BECBE))),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton(String text, int amount) {
    return InkWell(
      onTap: () => _addWaterLog(amount),
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

  Widget _buildRecordItem(int id, String amount, String time) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey[100]!)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.water_drop, color: Color(0xFF4BECBE), size: 20),
              const SizedBox(width: 8),
              Text(amount, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          Row(
            children: [
              Text(time, style: const TextStyle(color: Colors.grey)),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () => _deleteWaterLog(id),
                child: const Icon(Icons.close, size: 18, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}