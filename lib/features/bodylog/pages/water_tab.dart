import 'package:flutter/material.dart';
import 'dart:math' as math; // 회전을 위해 추가

class WaterTab extends StatefulWidget {
  const WaterTab({super.key});

  @override
  State<WaterTab> createState() => _WaterTabState();
}

class _WaterTabState extends State<WaterTab> {
  @override
  Widget build(BuildContext context) {
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

          // 1. 중앙 물결 이미지 및 원형 그래프 영역 (수정됨 ⭐)
          SizedBox(
            width: 180, // (1) 전체 영역 크기를 240 -> 180으로 줄임
            height: 180,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // (1) 물결 이미지 (크기 축소)
                Container(
                  width: 150, // 200 -> 150으로 줄임
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[50],
                  ),
                  child: ClipOval(
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Image.asset(
                          'assets/bodylog/water_back.png',
                          width: 150, // 200 -> 150
                          height: 150,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(color: const Color(0xFFE0F7FA)),
                        ),
                        Image.asset(
                          'assets/bodylog/water_front.png',
                          width: 150, // 200 -> 150
                          height: 150, // 높이 조절 가능
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(height: 90, color: const Color(0xFF4BECBE).withOpacity(0.3)),
                        ),
                      ],
                    ),
                  ),
                ),

                // (2) 퍼센트 텍스트 (수정됨 ⭐ - 상단으로 이동)
                const Align(
                  alignment: Alignment.topCenter, // 상단 중앙 정렬
                  child: Padding(
                    padding: EdgeInsets.only(top: 40), // 상단 여백 추가
                    child: Text(
                      '60%',
                      style: TextStyle(
                        fontSize: 28, // 크기 축소에 맞춰 폰트 사이즈도 36 -> 28로 조절
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4BECBE), // 민트색 텍스트
                      ),
                    ),
                  ),
                ),

                // (3) 진행률 원형 테두리 (크기 축소)
                SizedBox(
                  width: 150, // 200 -> 150으로 줄임
                  height: 150,
                  child: Transform.rotate(
                    angle: -math.pi / 2, // -90도 회전 (12시 시작)
                    child: const CircularProgressIndicator(
                      value: 0.6, // 60%
                      strokeWidth: 10, // 두께도 살짝 조정 (12 -> 10)
                      color: Color(0xFF4BECBE), // 진행 색상 (민트)
                      backgroundColor: Color(0xFFF5F5F5), // 배경 트랙 색상 (연한 회색)
                      strokeCap: StrokeCap.round, // 끝부분 둥글게
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 수분 섭취량 텍스트
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('1,200 ml', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(' / 2000 ml', style: TextStyle(fontSize: 16, color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 30),

          // 2. 버튼들
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildAddButton('+ 200ml'),
                const SizedBox(width: 12),
                _buildAddButton('+ 300ml'),
                const SizedBox(width: 12),
                _buildAddButton('+ 500ml'),
                const SizedBox(width: 12),
                _buildAddButton('직접입력', icon: Icons.edit),
              ],
            ),
          ),
          const SizedBox(height: 40),

          // 3. 오늘의 기록 (이하 동일)
          const Align(
            alignment: Alignment.centerLeft,
            child: Text('오늘의 기록', style: TextStyle(fontSize: 14, color: Colors.grey)),
          ),
          const SizedBox(height: 10),
          _buildRecordItem('300ml', '08:30'),
          const SizedBox(height: 10),
          _buildRecordItem('200ml', '10:15'),
          const SizedBox(height: 10),
          _buildRecordItem('500ml', '12:00'),

          const SizedBox(height: 40),

          // 4. 주간 수분 섭취량 (기존 코드 유지)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey[200]!),
              boxShadow: [
                BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5)),
              ],
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
                    _buildBar('25', 0.6),
                    _buildBar('26', 0.4),
                    _buildBar('27', 0.5),
                    _buildBar('28', 0.8),
                    _buildBar('29', 0.55),
                    _buildBar('30', 0.65),
                    _buildBar('31', 0.7),
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

  // --- 기존 헬퍼 메서드들 (동일) ---
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

  Widget _buildAddButton(String text, {IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: Colors.grey[700]),
            const SizedBox(width: 6),
          ],
          Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildRecordItem(String amount, String time) {
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
          Text(time, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}