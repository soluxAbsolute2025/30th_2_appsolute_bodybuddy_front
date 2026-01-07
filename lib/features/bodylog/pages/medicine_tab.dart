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
  // 예제용 데이터 리스트
  final List<Map<String, dynamic>> _medicines = [
    {
      "name": "종합 비타민",
      "frequency": "1일 1회",
      "time": "식후",
      "isTaken": true,
    },
    {
      "name": "오메가3",
      "frequency": "1일 2회",
      "time": "식후",
      "isTaken": false,
    },
    {
      "name": "프로바이오틱스",
      "frequency": "1일 1회",
      "time": "공복",
      "isTaken": false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // (1) 주간 달력 (상단)
          const SizedBox(height: 10),
          _buildWeeklyCalendar(),
          const SizedBox(height: 30),

          // (2) 약 & 영양제 리스트 헤더
          const Text('약 & 영양제', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),

          // (3) 약 리스트 아이템들
          ..._medicines.map((med) => _buildMedicineCard(med)),

          // (4) 추가하기 버튼 (맨 아래)
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

  // 주간 달력 위젯
  Widget _buildWeeklyCalendar() {
    final days = ['25\n월', '26\n화', '27\n수', '28\n목', '29\n금', '30\n토', '31\n일'];
    int selectedIndex = 5; // '30 토'를 선택된 상태로 가정

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(days.length, (index) {
        bool isSelected = index == selectedIndex;
        return Container(
          width: 45,
          height: 70,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF4BECBE) : Colors.grey[50],
            borderRadius: BorderRadius.circular(25),
            boxShadow: isSelected
                ? [BoxShadow(color: const Color(0xFF4BECBE).withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 4))]
                : [],
          ),
          child: Center(
            child: Text(
              days[index],
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                height: 1.5,
              ),
            ),
          ),
        );
      }),
    );
  }

  // 약 카드 빌더
  Widget _buildMedicineCard(Map<String, dynamic> med) {
    return GestureDetector(
      onTap: () {
        // 카드 클릭 시 수정 페이지로 이동
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
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: med['isTaken'] ? Colors.grey[300] : const Color(0xFF4BECBE),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  med['isTaken'] ? '복용완료' : '복용하기',
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
      appBar: _buildAppBar('약 & 영양제 추가', context), // 여기서 _buildAppBar 호출
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
      appBar: _buildAppBar('약 & 영양제 수정', context), // 여기서도 _buildAppBar 호출
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

  // 내부 위젯들 (AddPage와 동일한 로직)
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
// [핵심] 공통으로 사용하는 AppBar 함수
// 이 함수가 클래스 밖에 있어야(Top-level) 양쪽 페이지에서 모두 부를 수 있습니다.
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