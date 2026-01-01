import 'package:flutter/material.dart';

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

          // 1. 원형 그래프
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 200, height: 200,
                child: CircularProgressIndicator(value: 1.0, strokeWidth: 15, color: Colors.grey[200]),
              ),
              const SizedBox(
                width: 200, height: 200,
                child: CircularProgressIndicator(
                  value: 0.6, strokeWidth: 15, color: Color(0xFF4BECBE), strokeCap: StrokeCap.round,
                ),
              ),
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('60%', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF4BECBE))),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('1,200 ml', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(' / 2000 ml', style: TextStyle(fontSize: 16, color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 30),

          // 2. 버튼들
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildAddButton('+ 200ml'),
              _buildAddButton('+ 300ml'),
              _buildAddButton('+ 500ml'),
            ],
          ),
          const SizedBox(height: 40),

          // 3. 오늘의 기록
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

          // 4. 주간 수분 섭취량 (막대 그래프) - 새로 추가됨! ⭐
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
                  crossAxisAlignment: CrossAxisAlignment.end, // 밑변 맞추기
                  children: [
                    _buildBar('25', 0.6),
                    _buildBar('26', 0.4),
                    _buildBar('27', 0.5),
                    _buildBar('28', 0.8), // 제일 높은 날
                    _buildBar('29', 0.55),
                    _buildBar('30', 0.65),
                    _buildBar('31', 0.7),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 80), // 하단 바에 가려지지 않게 여백 추가
        ],
      ),
    );
  }

  // 막대 하나 그리는 함수
  Widget _buildBar(String day, double heightRatio) {
    return Column(
      children: [
        Container(
          width: 8,
          height: 150 * heightRatio, // 높이 조절
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

  Widget _buildAddButton(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(20)),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
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