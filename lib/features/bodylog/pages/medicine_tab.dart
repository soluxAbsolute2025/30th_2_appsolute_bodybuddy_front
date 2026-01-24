import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/medicine_api_service.dart';
import '../data/medicine_model.dart';
import 'medicine_edit_page.dart';

class MedicineTab extends StatefulWidget {
  const MedicineTab({super.key});

  @override
  State<MedicineTab> createState() => _MedicineTabState();
}

class _MedicineTabState extends State<MedicineTab> {
  final MedicineApiService _apiService = MedicineApiService();

  DateTime _selectedDate = DateTime.now(); // 선택된 날짜
  List<DateTime> _weekDays = [];           // 주간 날짜 리스트
  List<MedicineRecord> _medicines = [];    // 서버에서 가져온 약 리스트
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _generateWeekDays(); // 1. 달력 생성
    _fetchData();        // 2. 데이터 조회
  }

  // 이번 주 날짜 생성
  void _generateWeekDays() {
    DateTime now = DateTime.now();
    int currentWeekday = now.weekday; // 1(월)~7(일)
    DateTime thisMonday = now.subtract(Duration(days: currentWeekday - 1));

    _weekDays = List.generate(7, (index) => thisMonday.add(Duration(days: index)));
  }

  // 데이터 불러오기
  Future<void> _fetchData() async {
    setState(() => _isLoading = true);
    try {
      String dateStr = DateFormat('yyyy-MM-dd').format(_selectedDate);
      final list = await _apiService.getMedicines(dateStr);
      setState(() => _medicines = list);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // ✅ [수정됨] 복용 체크 / 취소 로직 연결
  Future<void> _toggleCheck(MedicineRecord med) async {
    try {
      if (med.isTaken) {
        // 🟥 1. 이미 먹은 상태면 -> 취소(삭제)
        // (주의: MedicineRecord 모델에 logId가 있어야 취소가 정확히 됨)
        if (med.logId != null) {
          await _apiService.cancelMedicine(med.logId!);

          setState(() {
            med.isTaken = false;
            med.logId = null; // ID 초기화
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('복용 취소됨')),
          );
        } else {
          // logId가 없으면 화면에서만 일단 끔 (새로고침 권장)
          setState(() => med.isTaken = false);
          _fetchData(); // 확실하게 하기 위해 새로고침
        }
      } else {
        // 🟩 2. 안 먹은 상태면 -> 복용(생성)
        // checkMedicine이 생성된 로그의 ID를 반환하도록 API를 수정했었음
        int? newLogId = await _apiService.checkMedicine(med);

        if (newLogId != null) {
          setState(() {
            med.isTaken = true;
            med.logId = newLogId; // ✅ ID 저장! (그래야 나중에 취소 가능)
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('복용 완료! 💊')),
          );
        }
      }
    } catch (e) {
      print("에러 발생: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('처리 실패: 서버 에러')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          _buildWeeklyCalendar(), // (1) 주간 달력
          const SizedBox(height: 30),

          // (2) 날짜 헤더
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_selectedDate.month}월 ${_selectedDate.day}일 약 & 영양제',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              InkWell(
                onTap: _fetchData,
                child: const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Icon(Icons.refresh, size: 20, color: Colors.grey),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),

          // (3) 리스트
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_medicines.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Center(child: Text("복용할 약이 없습니다.", style: TextStyle(color: Colors.grey))),
            )
          else
            ..._medicines.map((med) => _buildMedicineCard(med)),

          // (4) 추가 버튼
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () async {
              // 추가 페이지로 이동 (record 없음)
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MedicineEditPage(selectedDate: _selectedDate)),
              );
              if (result == true) _fetchData(); // 저장하고 돌아오면 새로고침
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
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  // 주간 달력 UI
  Widget _buildWeeklyCalendar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: _weekDays.map((date) {
        bool isSelected = date.year == _selectedDate.year &&
            date.month == _selectedDate.month &&
            date.day == _selectedDate.day;

        return GestureDetector(
          onTap: () {
            setState(() => _selectedDate = date);
            _fetchData();
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 45,
            height: isSelected ? 80 : 70,
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
                Text('${date.day}',
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey[400],
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    )),
                const SizedBox(height: 4),
                Text(_getWeekdayName(date.weekday),
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey[400],
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      fontSize: 14,
                    )),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // 약 정보 카드 UI
  Widget _buildMedicineCard(MedicineRecord med) {
    return GestureDetector(
      onTap: () async {
        // 수정 페이지로 이동 (record 전달)
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MedicineEditPage(
              selectedDate: _selectedDate,
              record: med, // 기존 데이터 전달
            ),
          ),
        );
        if (result == true) _fetchData();
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
            // 체크 아이콘
            GestureDetector( // 아이콘 눌러도 체크되게 수정
              onTap: () => _toggleCheck(med),
              child: Container(
                width: 50, height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: med.isTaken
                    ? const Icon(Icons.check, color: Color(0xFF4BECBE))
                    : const SizedBox(),
              ),
            ),
            const SizedBox(width: 15),

            // 텍스트 정보
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(med.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildTag(med.frequencyKor),
                      const SizedBox(width: 6),
                      _buildTag(med.timeKor),
                    ],
                  ),
                ],
              ),
            ),

            // 복용 버튼
            GestureDetector(
              onTap: () => _toggleCheck(med),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: med.isTaken ? Colors.grey[300] : const Color(0xFF4BECBE),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  med.isTaken ? '취소' : '복용',
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

  String _getWeekdayName(int weekday) {
    const days = ['월', '화', '수', '목', '금', '토', '일'];
    return days[weekday - 1];
  }
}