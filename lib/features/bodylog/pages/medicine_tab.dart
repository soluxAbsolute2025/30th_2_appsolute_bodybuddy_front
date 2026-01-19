import 'package:flutter/material.dart';

// -------------------------------------------------------------------------
// 1. 메인 약/영양제 탭 (MedicineTab)
// -------------------------------------------------------------------------
class MedicineTab extends StatefulWidget {
  const MedicineTab({super.key});

  @override
  State<MedicineTab> createState() => _MedicineTabState();
}

class _MedicineTabState extends State<MedicineTab> {
  // 날짜 관련 상태 변수
  DateTime _selectedDate = DateTime.now(); // 현재 선택된 날짜 (기본: 오늘)
  List<DateTime> _weekDays = []; // 이번 주 7일 날짜 리스트

  // 약 데이터 리스트 (API에서 받아온 데이터라고 가정)
  List<Map<String, dynamic>> _medicines = [];

  @override
  void initState() {
    super.initState();
    _generateWeekDays(); // 1. 이번 주 날짜 생성
    _fetchMedicineData(_selectedDate); // 2. 오늘 날짜 데이터 로드
  }

  // [기능 1] 이번 주 날짜 7개 자동 생성 (월요일 ~ 일요일)
  void _generateWeekDays() {
    DateTime now = DateTime.now();
    // 오늘이 무슨 요일인지 (1:월 ~ 7:일)
    int currentWeekday = now.weekday;
    // 이번 주 월요일 구하기
    DateTime thisMonday = now.subtract(Duration(days: currentWeekday - 1));

    // 월요일부터 7일치 날짜 리스트 생성
    _weekDays = List.generate(7, (index) {
      return thisMonday.add(Duration(days: index));
    });
  }

  // [기능 2] API 조회 시뮬레이션 (날짜 변경 시 호출)
  void _fetchMedicineData(DateTime date) {
    // 💡 실제 API 연동 시:
    // String dateStr = "${date.year}-${date.month.toString().padLeft(2,'0')}-${date.day.toString().padLeft(2,'0')}";
    // var response = await http.get(Uri.parse('.../api/medicines?date=$dateStr'));

    print("API 조회 요청 날짜: ${date.toString().split(' ')[0]}");

    setState(() {
      // 날짜에 따라 다른 데이터가 오는 척 시뮬레이션
      if (date.day % 2 == 0) {
        // 짝수 날짜 데이터
        _medicines = [
          {"name": "종합 비타민", "frequency": "1일 1회", "time": "식후", "isTaken": true},
          {"name": "오메가3", "frequency": "1일 2회", "time": "식후", "isTaken": false},
        ];
      } else {
        // 홀수 날짜 데이터
        _medicines = [
          {"name": "프로바이오틱스", "frequency": "1일 1회", "time": "공복", "isTaken": false},
          {"name": "루테인", "frequency": "1일 1회", "time": "취침 전", "isTaken": false},
          {"name": "비타민 D", "frequency": "1일 1회", "time": "점심", "isTaken": false},
        ];
      }
    });
  }

  // 요일 숫자를 한글로 변환하는 헬퍼 함수
  String _getWeekdayName(int weekday) {
    const days = ['월', '화', '수', '목', '금', '토', '일'];
    return days[weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),

          // (1) 주간 달력 (동적 생성)
          _buildWeeklyCalendar(),

          const SizedBox(height: 30),

          // (2) 날짜 헤더 및 새로고침
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_selectedDate.month}월 ${_selectedDate.day}일 약 & 영양제',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              // 데이터가 제대로 바뀌는지 확인용 새로고침 버튼
              InkWell(
                onTap: () => _fetchMedicineData(_selectedDate),
                child: const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Icon(Icons.refresh, size: 20, color: Colors.grey),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),

          // (3) 약 리스트 아이템들 (데이터가 없으면 안내 문구)
          if (_medicines.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Center(child: Text("복용할 약이 없습니다.", style: TextStyle(color: Colors.grey))),
            )
          else
            ..._medicines.map((med) => _buildMedicineCard(med)),

          // (4) 추가하기 버튼 (맨 아래)
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MedicineAddPage()),
              );
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, color: Colors.grey[400]),
                    const SizedBox(width: 8),
                    Text('약 & 영양제 추가하기', style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 80), // 하단 여백
        ],
      ),
    );
  }

  // ⭐️ 동적 주간 달력 위젯
  Widget _buildWeeklyCalendar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: _weekDays.map((date) {
        // 현재 렌더링 중인 날짜가 선택된 날짜와 같은지 비교
        bool isSelected = date.year == _selectedDate.year &&
            date.month == _selectedDate.month &&
            date.day == _selectedDate.day;

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedDate = date; // 선택된 날짜 변경
            });
            _fetchMedicineData(date); // 해당 날짜 데이터 API 요청
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200), // 부드러운 애니메이션
            width: 45,
            height: isSelected ? 80 : 70, // 선택되면 살짝 길어짐
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF4BECBE) : const Color(0xFFF7F8F9),
              borderRadius: BorderRadius.circular(25),
              boxShadow: isSelected
                  ? [BoxShadow(color: const Color(0xFF4BECBE).withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 4))]
                  : [],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 날짜 (일)
                Text(
                  '${date.day}',
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey[400],
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                // 요일 (한글)
                Text(
                  _getWeekdayName(date.weekday),
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey[400],
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // 약 카드 빌더
  Widget _buildMedicineCard(Map<String, dynamic> med) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MedicineEditPage(initialName: med['name'])),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!),
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5)),
          ],
        ),
        child: Row(
          children: [
            // 아이콘 박스
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: med['isTaken']
                  ? const Icon(Icons.check, color: Color(0xFF4BECBE))
                  : const SizedBox(),
            ),
            const SizedBox(width: 15),

            // 내용 (이름 + 태그)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(med['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildTag(med['frequency']),
                      const SizedBox(width: 6),
                      _buildTag(med['time']),
                    ],
                  ),
                ],
              ),
            ),

            // 복용 버튼
            GestureDetector(
              onTap: () {
                setState(() {
                  med['isTaken'] = !med['isTaken'];
                  // TODO: 여기서 API로 복용 완료 상태 전송
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: med['isTaken'] ? Colors.grey[300] : const Color(0xFF4BECBE),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  med['isTaken'] ? '취소' : '복용',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF4BECBE)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text, style: const TextStyle(color: Color(0xFF4BECBE), fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }
}

// -------------------------------------------------------------------------
// 2. 약 추가 페이지 (MedicineAddPage)
// -------------------------------------------------------------------------
class MedicineAddPage extends StatefulWidget {
  const MedicineAddPage({super.key});

  @override
  State<MedicineAddPage> createState() => _MedicineAddPageState();
}

class _MedicineAddPageState extends State<MedicineAddPage> {
  final TextEditingController _nameController = TextEditingController();
  String _selectedTime = '식후';
  String _selectedFrequency = '아침';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar('약 & 영양제 추가', context),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('약/영양제 이름'),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _nameController,
                    decoration: _inputDecoration('약 이름을 입력해주세요'),
                  ),
                  const SizedBox(height: 25),

                  _buildLabel('복용 시간'),
                  const SizedBox(height: 10),
                  _buildDropdown(),

                  const SizedBox(height: 25),

                  _buildLabel('1일 복용 횟수'),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _buildRadioOption('아침'),
                      const SizedBox(width: 20),
                      _buildRadioOption('점심'),
                      const SizedBox(width: 20),
                      _buildRadioOption('저녁'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  foregroundColor: Colors.grey,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('추가하기', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // (Helper 위젯들은 기존과 동일, 생략 없이 포함)
  Widget _buildLabel(String text) => Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14));

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[300]!)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[300]!)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF4BECBE))),
    );
  }

  Widget _buildDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedTime,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
          items: ['식후', '식전', '공복', '취침 전'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (v) => setState(() => _selectedTime = v!),
        ),
      ),
    );
  }

  Widget _buildRadioOption(String value) {
    bool isSelected = _selectedFrequency == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedFrequency = value),
      child: Row(
        children: [
          Container(
            width: 18, height: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? const Color(0xFF4BECBE) : Colors.white,
              border: Border.all(color: isSelected ? const Color(0xFF4BECBE) : Colors.grey[300]!),
            ),
            child: isSelected ? const Icon(Icons.check, size: 12, color: Colors.white) : null,
          ),
          const SizedBox(width: 8),
          Text(value, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------------------
// 3. 약 수정 페이지 (MedicineEditPage)
// -------------------------------------------------------------------------
class MedicineEditPage extends StatefulWidget {
  final String initialName;
  const MedicineEditPage({super.key, required this.initialName});

  @override
  State<MedicineEditPage> createState() => _MedicineEditPageState();
}

class _MedicineEditPageState extends State<MedicineEditPage> {
  late TextEditingController _nameController;
  String _selectedTime = '식후';
  String _selectedFrequency = '아침';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar('약 & 영양제 수정', context),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('약/영양제 이름'),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _nameController,
                    decoration: _inputDecoration('약 이름을 입력해주세요'),
                  ),
                  const SizedBox(height: 25),

                  _buildLabel('복용 시간'),
                  const SizedBox(height: 10),
                  _buildDropdown(),

                  const SizedBox(height: 25),

                  _buildLabel('1일 복용 횟수'),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _buildRadioOption('아침'),
                      const SizedBox(width: 20),
                      _buildRadioOption('점심'),
                      const SizedBox(width: 20),
                      _buildRadioOption('저녁'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
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
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFFF6B6B)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('삭제하기', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFFFF6B6B))),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 내부 위젯들 (AddPage와 동일한 로직 복사)
  Widget _buildLabel(String text) => Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14));

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[300]!)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[300]!)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF4BECBE))),
    );
  }

  Widget _buildDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedTime,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
          items: ['식후', '식전', '공복', '취침 전'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (v) => setState(() => _selectedTime = v!),
        ),
      ),
    );
  }

  Widget _buildRadioOption(String value) {
    bool isSelected = _selectedFrequency == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedFrequency = value),
      child: Row(
        children: [
          Container(
            width: 18, height: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? const Color(0xFF4BECBE) : Colors.white,
              border: Border.all(color: isSelected ? const Color(0xFF4BECBE) : Colors.grey[300]!),
            ),
            child: isSelected ? const Icon(Icons.check, size: 12, color: Colors.white) : null,
          ),
          const SizedBox(width: 8),
          Text(value, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------------------
// [공통] AppBar 함수
// -------------------------------------------------------------------------
AppBar _buildAppBar(String title, BuildContext context) {
  return AppBar(
    title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
    centerTitle: true,
    backgroundColor: Colors.white,
    elevation: 0,
    leading: IconButton(
      icon: const Icon(Icons.close, color: Colors.black),
      onPressed: () => Navigator.pop(context),
    ),
  );
}