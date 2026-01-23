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
    return GestureDetector(
      onTap: () => _navigateAndRefresh(isEdit: true, record: r),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
          Text("${r.mealTypeKor} 식사", style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                r.imageUrl ?? '',
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported),
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: 180,
              child: Text(r.foods.join("\n"), maxLines: 4, overflow: TextOverflow.ellipsis),
            ),
          ]),
        ]),
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
