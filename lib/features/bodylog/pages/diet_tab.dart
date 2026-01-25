import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/diet_api_service.dart';
import '../data/diet_model.dart';
import 'diet_edit_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_local.dart';
import '../../../common/common.dart';

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
    // 월요일부터 시작하도록 설정
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
      height: 80,
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
                Text(
                  "${date.day}",
                  style: TextStyle(
                      fontSize: 16,
                      color: isSelected ? Colors.black : Colors.black,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF4BECBE) : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    label,
                    style: TextStyle(
                        fontSize: 12,
                        color: isSelected ? Colors.white : Colors.grey,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTimelineRow(String type, DietRecord? record, bool isLast) {
    final hasRecord = record != null;

    return IntrinsicHeight( // 자식들 중 가장 높은 요소에 맞춰 높이 자동 조절
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 왼쪽 타임라인 표시 영역
          SizedBox(
            width: 50,
            child: Column(
              children: [
                const SizedBox(height: 5),
                Text(
                  _mealTitleMap[type]!,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: hasRecord ? const Color(0xFF4BECBE) : Colors.grey[400]
                  ),
                ),
                const SizedBox(height: 8),
                CircleAvatar(
                    radius: 5,
                    backgroundColor: hasRecord ? const Color(0xFF4BECBE) : Colors.grey[300]
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: Colors.grey[200],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          // 오른쪽 카드 영역
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: hasRecord ? _buildFilledCard(record!) : _buildEmptyCard(type),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilledCard(DietRecord r) {
    String fullImageUrl = "";
    if (r.imageUrl != null && r.imageUrl!.isNotEmpty) {
      fullImageUrl = r.imageUrl!.startsWith("http")
          ? r.imageUrl!
          : "http://52.79.228.227:8080${r.imageUrl!.startsWith('/') ? '' : '/'}${r.imageUrl}";
    }

    return GestureDetector(
      onTap: () => _navigateAndRefresh(isEdit: true, record: r),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FA), // 가이드 이미지의 연회색 배경
          borderRadius: BorderRadius.circular(16),
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
                    const Icon(Icons.edit_outlined, size: 16, color: Colors.grey),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 14, color: Color(0xFF4BECBE)),
                    const SizedBox(width: 4),
                    Text(r.time ?? "", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 음식 이미지
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: fullImageUrl.isNotEmpty
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      fullImageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (c, e, s) => const Icon(Icons.broken_image, color: Colors.grey),
                    ),
                  )
                      : const Icon(Icons.camera_alt, color: Colors.grey),
                ),
                const SizedBox(width: 16),
                // 음식 명칭 리스트
                Expanded(
                  child: r.foods.isNotEmpty
                      ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: r.foods.map((food) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("• ", style: TextStyle(color: Colors.black54)),
                          Expanded(
                            child: Text(
                                food,
                                style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.3)
                            ),
                          ),
                        ],
                      ),
                    )).toList(),
                  )
                      : const Text("기록된 음식이 없습니다.", style: TextStyle(color: Colors.grey, fontSize: 13)),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("아직 기록하지 않았어요!", style: TextStyle(color: Colors.grey, fontSize: 14)),
          ElevatedButton(
            onPressed: () => _navigateAndRefresh(isEdit: false, initialMealType: type),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4BECBE),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text("기록하기", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
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