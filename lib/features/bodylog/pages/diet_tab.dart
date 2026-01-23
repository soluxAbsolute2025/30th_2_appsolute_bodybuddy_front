import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/diet_api_service.dart';
import '../data/diet_model.dart';
import 'diet_edit_page.dart';
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
  final DietApiService _apiService = DietApiService();

  DateTime _selectedDate = DateTime.now();
  List<DietRecord> _todayMeals = [];
  bool _isLoading = false;
  List<DateTime> _weekDays = [];

  final List<String> _mealOrder = ['BREAKFAST', 'LUNCH', 'DINNER'];
  final Map<String, String> _mealTitleMap = {
    'BREAKFAST': '아침',
    'LUNCH': '점심',
    'DINNER': '저녁',
  };

  @override
  void initState() {
    super.initState();
    _generateWeekDays();
    _loadMeals();
  }

  void _generateWeekDays() {
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    _weekDays = List.generate(7, (i) => monday.add(Duration(days: i)));
  }

  Future<void> _loadMeals() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);
    try {
      final dateStr = DateFormat('yyyy-MM-dd').format(_selectedDate);
      final meals = await _apiService.getMealLogs(dateStr);

      if (!mounted) return;
      setState(() {
        _todayMeals = meals;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _todayMeals = [];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              _buildWeekCalendar(),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text('오늘의 식단', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 20),
              if (_isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40),
                    child: CircularProgressIndicator(color: Color(0xFF4BECBE)),
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: _mealOrder.asMap().entries.map((e) {
                      final index = e.key;
                      final type = e.value;
                      final record = _todayMeals.where((m) => m.mealType == type).isNotEmpty
                          ? _todayMeals.firstWhere((m) => m.mealType == type)
                          : null;

                      return _buildTimelineRow(type, record, index == _mealOrder.length - 1);
                    }).toList(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeekCalendar() {
    return SizedBox(
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _weekDays.map((date) {
          final isSelected = DateUtils.isSameDay(date, _selectedDate);
          final label = DateFormat('E', 'ko_KR').format(date);

          return GestureDetector(
            onTap: _isLoading
                ? null
                : () {
              setState(() => _selectedDate = date);
              _loadMeals();
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: isSelected ? const Color(0xFF4BECBE) : Colors.transparent,
                  child: Text(
                    "${date.day}",
                    style: TextStyle(color: isSelected ? Colors.white : Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 4),
                Text(label, style: TextStyle(fontSize: 12, color: isSelected ? const Color(0xFF4BECBE) : Colors.grey)),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTimelineRow(String type, DietRecord? record, bool isLast) {
    final hasRecord = record != null;

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth - 60;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 50,
              child: Column(
                children: [
                  Text(
                    _mealTitleMap[type]!,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: hasRecord ? const Color(0xFF4BECBE) : Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  CircleAvatar(radius: 5, backgroundColor: hasRecord ? const Color(0xFF4BECBE) : Colors.grey[300]),
                  if (!isLast) Container(width: 2, height: 60, color: Colors.grey[200]),
                ],
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: cardWidth > 0 ? cardWidth : 0,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: hasRecord ? _buildFilledCard(record!) : _buildEmptyCard(type),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFilledCard(DietRecord r) {
    // 🔍 [디버깅용 로그] 콘솔에서 확인해보세요
    print("--------------------------------");
    print("📌 식사 타입: ${r.mealTypeKor}");
    print("📌 원본 이미지 URL: ${r.imageUrl}");
    print("📌 음식 리스트: ${r.foods}");
    print("--------------------------------");

    // 1. 이미지 URL 처리 (http가 없으면 서버 주소 붙이기)
    String fullImageUrl = "";
    if (r.imageUrl != null && r.imageUrl!.isNotEmpty) {
      if (r.imageUrl!.startsWith("http")) {
        fullImageUrl = r.imageUrl!;
      } else {
        // ⚠️ 서버 도메인 추가
        fullImageUrl = "http://52.79.228.227:8080${r.imageUrl!.startsWith('/') ? '' : '/'}${r.imageUrl}";
      }
    }

    return GestureDetector(
      onTap: () => _navigateAndRefresh(isEdit: true, record: r),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      "${r.mealTypeKor} 식사",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(width: 6),
                    // 수정 아이콘을 클릭 가능한 버튼 느낌으로 강조
                    const Icon(Icons.edit_note_rounded, size: 20, color: Color(0xFF4BECBE)),
                  ],
                ),
                // API 명세에 intakeTime이 있으므로 표시해주면 좋습니다.
                Text(r.time ?? "", style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 12),

            // [하단] 이미지 + 리스트
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🖼️ 이미지 영역
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: fullImageUrl.isNotEmpty
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      fullImageUrl,
                      fit: BoxFit.cover,
                      // 👇 로딩 과정을 확인하기 위한 코드
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(child: CircularProgressIndicator(strokeWidth: 2));
                      },
                      // 👇 에러 원인을 보기 위한 코드
                      errorBuilder: (context, error, stackTrace) {
                        print("🚨 이미지 로드 에러 발생!");
                        print("❌ 시도한 URL: $fullImageUrl");
                        print("❌ 에러 내용: $error");
                        return Container(
                          color: Colors.grey[200],
                          child: const Icon(Icons.broken_image, color: Colors.grey),
                        );
                      },
                    ),
                  )
                      : const Icon(Icons.camera_alt, color: Colors.grey),
                ),
                const SizedBox(width: 16),

                // 📋 음식 리스트 영역
                Expanded(
                  child: (r.foods.isNotEmpty)
                      ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: r.foods.map((food) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("• ", style: TextStyle(fontSize: 14, height: 1.4)),
                          Expanded(
                            child: Text(
                              food,
                              style: const TextStyle(fontSize: 14, height: 1.4, color: Colors.black87),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    )).toList(),
                  )
                      : const Text(
                    "음식 정보 없음",
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyCard(String type) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
      child: Row(children: [
        const SizedBox(width: 180, child: Text("아직 기록하지 않았어요", style: TextStyle(color: Colors.grey))),
        const SizedBox(width: 8),
        SizedBox(
          height: 32,
          width: 72, // 🔥 핵심: 버튼 가로 고정
          child: ElevatedButton(
            onPressed: () => _navigateAndRefresh(isEdit: false, initialMealType: type),
            child: const Text("기록하기", style: TextStyle(fontSize: 12)),
          ),
        ),
      ]),
    );
  }

  Future<void> _navigateAndRefresh({required bool isEdit, DietRecord? record, String? initialMealType}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DietEditPage(
          isEditMode: isEdit,
          record: record,
          selectedDate: _selectedDate,
          initialMealType: initialMealType,
        ),
      ),
    );

    if (!mounted) return;
    if (result == true) _loadMeals();
  }
}
