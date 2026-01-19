import 'package:flutter/material.dart';
import '../../../common/common.dart';

// -------------------------------------------------------------------------
// 1. 메인 수면 탭 (SleepTab)
// -------------------------------------------------------------------------
class SleepTab extends StatefulWidget {
  const SleepTab({super.key});

  @override
  State<SleepTab> createState() => _SleepTabState();
}

class _SleepTabState extends State<SleepTab> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // 상단 배너가 화면 끝까지 닿게 하기 위해 padding을 부분적으로 적용
      child: Column(
        children: [
          // (1) 상단 그라데이션 배너 영역
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 40, 20, 40),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFFFBE6), Color(0xFFE0FCF6)], // 연한 노랑 -> 민트 그라데이션
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
                  text: const TextSpan(
                    style: TextStyle(fontSize: 24, color: Colors.black, height: 1.3),
                    children: [
                      TextSpan(
                        text: '7시간 30분',
                        style: TextStyle(color: Color(0xFF4BECBE), fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: '\n잤어요', style: TextStyle(fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // (2) 메인 컨텐츠 영역
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('수면 기록', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 15),

                // 수면 상세 정보 카드
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: _boxDecoration(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 카드 헤더 (아이콘 + 제목 + 편집 버튼)
                      Row(
                        children: [
                          const Icon(Icons.nightlight_round, color: Color(0xFF4BECBE), size: 20),
                          const SizedBox(width: 8),
                          const Text('어젯밤 수면', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: () {
                              // 편집 페이지로 이동
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const SleepEditPage()),
                              );
                            },
                            child: const Icon(Icons.edit, size: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // 수면 시간 (메인 텍스트)
                      const Text('7시간 30분', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF4BECBE))),
                      const SizedBox(height: 20),
                      const Divider(color: Colors.grey, thickness: 0.2),
                      const SizedBox(height: 15),

                      // 취침/기상 시간 정보
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _SleepTimeItem(title: '취침 시간', time: '23:30 pm'),
                          _SleepTimeItem(title: '기상 시간', time: '07:00 am'),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // 수면 품질 카드
                Container(
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
                        child: const Text('좋음', style: TextStyle(color: Color(0xFF4BECBE), fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // 주간 수면 패턴 (막대 그래프)
                Container(
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
                          _buildBar('25', 0.8),
                          _buildBar('26', 0.5),
                          _buildBar('27', 0.7),
                          _buildBar('28', 0.95), // 가장 높음
                          _buildBar('29', 0.6),
                          _buildBar('30', 0.75),
                          _buildBar('31', 0.9),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 80), // 하단 여백
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 공통 박스 스타일
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

  // 막대 그래프 생성 함수
  Widget _buildBar(String day, double heightRatio) {
    return Column(
      children: [
        Container(
          width: 8,
          height: 120 * heightRatio, // 높이 조절
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

// 작은 컴포넌트: 취침/기상 시간 표시
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


// -------------------------------------------------------------------------
// 2. 기록 편집 화면 (SleepEditPage) - 두 번째 이미지 구현
// -------------------------------------------------------------------------
class SleepEditPage extends StatefulWidget {
  const SleepEditPage({super.key});

  @override
  State<SleepEditPage> createState() => _SleepEditPageState();
}

class _SleepEditPageState extends State<SleepEditPage> {
  // 예제용 컨트롤러
  final TextEditingController _sleepTimeController = TextEditingController(text: "오후 11:00");
  final TextEditingController _wakeTimeController = TextEditingController(text: "오전 07:00");
  String _selectedQuality = '좋음';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('기록 편집', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. 취침 시간 입력
            _buildLabel('취침 시간'),
            const SizedBox(height: 8),
            _buildTextField(_sleepTimeController),

            const SizedBox(height: 24),

            // 2. 기상 시간 입력
            _buildLabel('기상 시간'),
            const SizedBox(height: 8),
            _buildTextField(_wakeTimeController),

            const SizedBox(height: 24),

            // 3. 수면 품질 선택 (Dropdown)
            _buildLabel('수면 품질'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedQuality,
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                  items: <String>['매우 좋음', '좋음', '보통', '나쁨'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedQuality = newValue!;
                    });
                  },
                ),
              ),
            ),

            const Spacer(),

            // 4. 하단 버튼들
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context), // 저장 동작
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4BECBE),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('수정하기', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context), // 삭제 동작
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFFF6B6B)), // 붉은색 테두리
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('삭제하기', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFFFF6B6B))),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14));
  }

  Widget _buildTextField(TextEditingController controller) {
    return TextField(
      controller: controller,
      readOnly: true, // 실제 앱에서는 탭하면 TimePicker가 뜨도록 구현
      onTap: () {
        // 여기에 시간 선택 로직 추가 가능
      },
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
      ),
    );
  }
}