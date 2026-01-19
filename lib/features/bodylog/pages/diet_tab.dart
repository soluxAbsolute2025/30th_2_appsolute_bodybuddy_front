import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart'; // 한국어 날짜 초기화용
import '../../../common/common.dart';
import 'diet_edit_page.dart'; // ★ 아까 만든 편집 페이지 import 필수

class DietTab extends StatefulWidget {
  const DietTab({super.key});

  @override
  State<DietTab> createState() => _DietTabState();
}

class _DietTabState extends State<DietTab> {
  DateTime _selectedDate = DateTime.now(); // 선택된 날짜
  List<dynamic> _dailyMeals = []; // 서버 데이터
  bool _isLoading = false;
  bool _isLocaleReady = false; // 날짜 초기화 여부

  final String _baseUrl = "http://52.79.228.227:8080";

  @override
  void initState() {
    super.initState();
    // 1. 한국어 날짜 데이터 초기화
    initializeDateFormatting('ko_KR', null).then((_) {
      if (mounted) {
        setState(() {
          _isLocaleReady = true;
        });
      }
    });
    // 2. 데이터 조회
    _fetchDailyMeals();
  }

  // --- [API] 식단 조회 ---
  Future<void> _fetchDailyMeals() async {
    if (Common.token == null) return;

    setState(() => _isLoading = true);
    String dateStr = DateFormat('yyyy-MM-dd').format(_selectedDate);

    try {
      final url = Uri.parse('$_baseUrl/api/meal-log?date=$dateStr');
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${Common.token}",
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _dailyMeals = data;
        });
      } else {
        setState(() => _dailyMeals = []);
      }
    } catch (e) {
      print("❌ 에러: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // 데이터에서 특정 끼니(BREAKFAST 등) 찾기
  Map<String, dynamic>? _findMealLog(String type) {
    try {
      return _dailyMeals.firstWhere((element) => element['mealType'] == type);
    } catch (e) {
      return null;
    }
  }

  // --- 화면 이동 (편집/추가 페이지로) ---
  Future<void> _navigateToEditPage({
    required bool isEditMode,
    String? initialMealType,
    Map<String, dynamic>? existingData,
  }) async {
    // 페이지 이동 후 돌아오면(pop) 새로고침
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DietEditPage(
          isEditMode: isEditMode,
          selectedDate: _selectedDate,
          initialMealType: initialMealType,
          existingData: existingData,
        ),
      ),
    );
    _fetchDailyMeals(); // 돌아오면 데이터 갱신
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLocaleReady) return const Center(child: CircularProgressIndicator());

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. 달력 (주간)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: _buildCalendarDays()),
          ),
          const SizedBox(height: 30),

          // 2. 타이틀
          const Text('오늘의 식단', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),

          // 3. 리스트 (로딩 중이면 로딩바)
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
            children: [
              _buildMealSlot('아침 식사', 'BREAKFAST', false),
              _buildMealSlot('점심 식사', 'LUNCH', false),
              _buildMealSlot('저녁 식사', 'DINNER', true),
            ],
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  // 끼니 슬롯 (데이터 유무에 따라 분기)
  Widget _buildMealSlot(String title, String serverType, bool isLast) {
    final mealData = _findMealLog(serverType);

    if (mealData != null) {
      // 데이터 있음 -> 내용 표시
      List<dynamic> foodList = mealData['foods'] ?? [];
      List<String> menus = foodList.map((e) => e.toString()).toList();
      String timeStr = mealData['intakeTime'] ?? "00:00";
      if (timeStr.length >= 5) timeStr = timeStr.substring(0, 5);

      return _buildTimelineItem(
        mealTypeKor: title,
        time: timeStr,
        menus: menus,
        isLast: isLast,
        originalData: mealData, // 원본 데이터 전달
      );
    } else {
      // 데이터 없음 -> "기록하기" 버튼 표시
      return _buildEmptyTimelineItem(
        mealTypeKor: title,
        serverType: serverType,
        isLast: isLast,
      );
    }
  }

  // 📅 달력 위젯 생성
  List<Widget> _buildCalendarDays() {
    List<Widget> days = [];
    DateTime now = DateTime.now();
    for (int i = -3; i <= 3; i++) {
      DateTime date = now.add(Duration(days: i));
      bool isSelected = date.year == _selectedDate.year &&
          date.month == _selectedDate.month &&
          date.day == _selectedDate.day;

      days.add(GestureDetector(
        onTap: () {
          setState(() => _selectedDate = date);
          _fetchDailyMeals();
        },
        child: Padding(
          padding: const EdgeInsets.only(right: 15),
          child: Column(
            children: [
              Container(
                width: 45, height: 45,
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF4BECBE) : Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: isSelected
                      ? [BoxShadow(color: const Color(0xFF4BECBE).withOpacity(0.4), blurRadius: 10, offset: const Offset(0, 4))]
                      : [],
                ),
                alignment: Alignment.center,
                child: Text(
                  date.day.toString(),
                  style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                DateFormat.E('ko_KR').format(date),
                style: TextStyle(color: isSelected ? Colors.black : Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
      ));
    }
    return days;
  }

  // 🍽️ 기록된 아이템 (수정 모드로 이동)
  Widget _buildTimelineItem({
    required String mealTypeKor,
    required String time,
    required List<String> menus,
    required bool isLast,
    required Map<String, dynamic> originalData,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 왼쪽 타임라인 선
          SizedBox(
            width: 30,
            child: Column(
              children: [
                Text(mealTypeKor.substring(0, 2),
                    style: const TextStyle(fontSize: 10, color: Color(0xFF4BECBE), fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Container(width: 10, height: 10, decoration: const BoxDecoration(color: Color(0xFF4BECBE), shape: BoxShape.circle)),
                if (!isLast) Expanded(child: Container(width: 2, color: const Color(0xFF4BECBE).withOpacity(0.3))),
              ],
            ),
          ),
          const SizedBox(width: 15),
          // 오른쪽 카드
          Expanded(
            child: GestureDetector(
              onTap: () => _navigateToEditPage(
                isEditMode: true,
                existingData: originalData,
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(children: [
                            Text(mealTypeKor, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(width: 5),
                            const Icon(Icons.edit, size: 14, color: Colors.grey),
                          ]),
                          Text(time, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // 메뉴 리스트
                      if (menus.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: menus.map((m) => Text('• $m', style: const TextStyle(fontSize: 13, height: 1.5))).toList(),
                        )
                      else
                        const Text('메뉴 정보 없음', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 📝 빈 아이템 (기록 모드로 이동)
  Widget _buildEmptyTimelineItem({
    required String mealTypeKor,
    required String serverType,
    required bool isLast,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 왼쪽 타임라인 선 (회색)
          SizedBox(
            width: 30,
            child: Column(
              children: [
                Text(mealTypeKor.substring(0, 2),
                    style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Container(
                    width: 10, height: 10,
                    decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.grey), shape: BoxShape.circle)),
                if (!isLast) Expanded(child: Container(width: 2, color: Colors.grey.withOpacity(0.3))),
              ],
            ),
          ),
          const SizedBox(width: 15),
          // 오른쪽 카드
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 30),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(16)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('아직 기록하지 않았어요!', style: TextStyle(color: Colors.grey, fontSize: 13)),
                  ElevatedButton(
                    onPressed: () => _navigateToEditPage(
                      isEditMode: false,
                      initialMealType: serverType, // "BREAKFAST" 등 전달
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4BECBE),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      minimumSize: const Size(0, 36),
                    ),
                    child: const Text('기록하기', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}