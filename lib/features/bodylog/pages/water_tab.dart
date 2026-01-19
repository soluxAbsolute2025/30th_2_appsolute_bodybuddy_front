import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../common/common.dart'; // Common.token 사용을 위해 import

class WaterTab extends StatefulWidget {
  const WaterTab({super.key});

  @override
  State<WaterTab> createState() => _WaterTabState();
}

class _WaterTabState extends State<WaterTab> {
  // 1. 상태 변수들 (서버에서 받아올 데이터)
  int _todayTotal = 0; // 오늘 마신 총량
  final int _goalAmount = 2000; // 목표량 (일단 고정, 나중에 user info에서 가져오기 가능)
  List<dynamic> _logs = []; // 오늘 기록 리스트
  bool _isLoading = false; // 로딩 상태

  final String _baseUrl = "http://52.79.228.227:8080"; // 서버 주소

  @override
  void initState() {
    super.initState();
    _fetchTodayData(); // 페이지 열리자마자 데이터 가져오기
  }

  // --- [API] 1. 오늘 기록 가져오기 ---
  Future<void> _fetchTodayData() async {
    if (Common.token == null) return;

    setState(() => _isLoading = true);

    try {
      final url = Uri.parse('$_baseUrl/api/water-log/today');
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${Common.token}",
        },
      );

      if (response.statusCode == 200) {
        // 서버 응답 구조에 따라 다를 수 있지만, 리스트로 가정합니다.
        // 예: [{"id": 1, "amount": 200, "createdAt": "..."}]
        final List<dynamic> data = jsonDecode(response.body);

        int sum = 0;
        for (var item in data) {
          sum += (item['amount'] as int); // 총량 계산
        }

        setState(() {
          _logs = data;
          _todayTotal = sum;
        });
      } else {
        print("데이터 불러오기 실패: ${response.statusCode}");
      }
    } catch (e) {
      print("에러 발생: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // --- [API] 2. 물 기록 추가하기 ---
  Future<void> _addWaterLog(int amount) async {
    if (Common.token == null) return;

    try {
      final url = Uri.parse('$_baseUrl/api/water-log');
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${Common.token}",
        },
        body: jsonEncode({
          "amount": amount,
          // "unit": "ml" // 필요하다면 추가
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("물 추가 성공: $amount");
        _fetchTodayData(); // 데이터 새로고침 (총량 및 리스트 업데이트)
      } else {
        print("추가 실패: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("기록 저장 실패")));
      }
    } catch (e) {
      print("에러 발생: $e");
    }
  }

  // --- [API] 3. 기록 삭제하기 (리스트에서 X 버튼 눌렀을 때) ---
  Future<void> _deleteWaterLog(int id) async {
    try {
      final url = Uri.parse('$_baseUrl/api/water-log/$id');
      final response = await http.delete(
        url,
        headers: {
          "Authorization": "Bearer ${Common.token}",
        },
      );

      if (response.statusCode == 200) {
        _fetchTodayData(); // 삭제 후 새로고침
      }
    } catch (e) {
      print("삭제 에러: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // 퍼센트 계산 (1.0이 최대)
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

          // 1. 중앙 물결 이미지 및 원형 그래프 영역
          SizedBox(
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
                        Image.asset(
                          'assets/bodylog/water_back.png',
                          width: 150, height: 150, fit: BoxFit.cover,
                          errorBuilder: (ctx, err, stack) => Container(color: const Color(0xFFE0F7FA)),
                        ),
                        // 물 차오르는 높이 조절 (percent * 150)
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 150 * percent, // 퍼센트에 따라 높이 변함
                            width: 150,
                            color: const Color(0xFF4BECBE).withOpacity(0.3), // 이미지 없으면 색으로 대체
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

                // 진행률 원형 테두리
                SizedBox(
                  width: 150,
                  height: 150,
                  child: Transform.rotate(
                    angle: -math.pi / 2,
                    child: CircularProgressIndicator(
                      value: percent, // 계산된 퍼센트 적용
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

          // 수분 섭취량 텍스트
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${_todayTotal}ml', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), // 변수 적용
              Text(' / ${_goalAmount}ml', style: const TextStyle(fontSize: 16, color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 30),

          // 2. 버튼들
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
                // 직접 입력 버튼
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

          // 리스트 빌더로 교체
          _logs.isEmpty
              ? const Padding(
            padding: EdgeInsets.all(20),
            child: Text("아직 기록이 없습니다.", style: TextStyle(color: Colors.grey)),
          )
              : ListView.builder(
            shrinkWrap: true, // 스크롤 중첩 방지
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _logs.length,
            itemBuilder: (context, index) {
              final log = _logs[index];
              // log['createdAt']가 "2024-05-20T10:30:00" 형식이면 시간만 자름
              String time = "00:00";
              if (log['createdAt'] != null && log['createdAt'].length > 16) {
                time = log['createdAt'].substring(11, 16);
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _buildRecordItem(
                    log['id'],
                    '${log['amount']}ml',
                    time
                ),
              );
            },
          ),

          const SizedBox(height: 40),

          // 4. 주간 차트 (API 연결 필요 시 주간 API 호출 추가 필요, 일단 UI 유지)
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildBar('25', 0.6), _buildBar('26', 0.4), _buildBar('27', 0.5),
                    _buildBar('28', 0.8), _buildBar('29', 0.55), _buildBar('30', 0.65), _buildBar('31', 0.7),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  // --- 헬퍼 위젯들 ---

  // 직접 입력 팝업
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
                _addWaterLog(amount); // API 호출
                Navigator.pop(context);
              }
            },
            child: const Text("저장", style: TextStyle(color: Color(0xFF4BECBE))),
          ),
        ],
      ),
    );
  }

  // + 버튼 (클릭 시 API 호출)
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

  // 기록 아이템 (삭제 버튼 포함)
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
                onTap: () => _deleteWaterLog(id), // 삭제 API 연결
                child: const Icon(Icons.close, size: 18, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBar(String day, double heightRatio) {
    return Column(
      children: [
        Container(
          width: 8,
          height: 150 * heightRatio,
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
}