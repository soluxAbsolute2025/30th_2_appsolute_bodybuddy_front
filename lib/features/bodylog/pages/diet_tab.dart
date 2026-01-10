import 'package:flutter/material.dart';

// -------------------------------------------------------------------------
// 1. 식단 탭 (DietTab)
// -------------------------------------------------------------------------
class DietTab extends StatefulWidget {
  const DietTab({super.key});

  @override
  State<DietTab> createState() => _DietTabState();
}

class _DietTabState extends State<DietTab> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. 주간 달력 (가로 스크롤)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildDateItem('25', '월', false),
                _buildDateItem('26', '화', false),
                _buildDateItem('27', '수', false),
                _buildDateItem('28', '목', false),
                _buildDateItem('29', '금', false),
                _buildDateItem('30', '토', true), // 선택된 날짜
                _buildDateItem('31', '일', false),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // 2. "오늘의 식단" 제목
          const Text(
            '오늘의 식단',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          // 3. 타임라인 리스트
          // 아침
          _buildTimelineItem(
            mealType: '아침 식사',
            time: '08시 30분',
            menus: ['김치찌개', '현미밥', '계란찜'],
            isLast: false,
          ),
          // 점심
          _buildTimelineItem(
            mealType: '점심 식사',
            time: '12시 20분',
            menus: ['닭가슴살 샐러드'],
            isLast: false,
          ),
          // 저녁 (기록 안 된 상태)
          _buildEmptyTimelineItem(
            mealType: '저녁 식사',
            isLast: true,
          ),

          const SizedBox(height: 80), // 하단 여백
        ],
      ),
    );
  }

  // 📅 날짜 아이템 하나
  Widget _buildDateItem(String day, String weekDay, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: Column(
        children: [
          Container(
            width: 45,
            height: 45, // 이미지와 비슷하게 둥근 사각형 또는 원형 유지
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF4BECBE) : Colors.white,
              shape: BoxShape.circle,
              boxShadow: isSelected
                  ? [
                BoxShadow(
                    color: const Color(0xFF4BECBE).withOpacity(0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 4))
              ]
                  : [],
            ),
            alignment: Alignment.center,
            child: Text(
              day,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            weekDay,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // 🍽️ 타임라인 아이템 (기록된 식사)
  Widget _buildTimelineItem({
    required String mealType,
    required String time,
    required List<String> menus,
    required bool isLast,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 왼쪽 타임라인 선과 점
          SizedBox(
            width: 30, // 너비 고정
            child: Column(
              children: [
                Text(mealType.substring(0, 2),
                    style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFF4BECBE),
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Color(0xFF4BECBE),
                    shape: BoxShape.circle,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: const Color(0xFF4BECBE).withOpacity(0.3),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 15),

          // 오른쪽 카드 내용
          Expanded(
            child: GestureDetector(
              onTap: () {
                // 카드 클릭 시 수정 페이지로 이동
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DietEditPage(isEditMode: true),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 카드 헤더
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(mealType,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              const SizedBox(width: 5),
                              const Icon(Icons.edit,
                                  size: 14, color: Colors.grey),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.access_time,
                                  size: 14, color: Color(0xFF4BECBE)),
                              const SizedBox(width: 4),
                              Text(time,
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),

                      // 음식 사진 + 메뉴 리스트
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: menus
                                  .map((menu) => Padding(
                                padding:
                                const EdgeInsets.only(bottom: 4),
                                child: Text('•  $menu',
                                    style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.black87)),
                              ))
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
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

  // 📝 기록하기 버튼이 있는 빈 타임라인
  Widget _buildEmptyTimelineItem(
      {required String mealType, required bool isLast}) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 30,
            child: Column(
              children: [
                Text(mealType.substring(0, 2),
                    style: const TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey),
                    shape: BoxShape.circle,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                        width: 2, color: Colors.grey.withOpacity(0.3)),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('아직 기록하지 않았어요!',
                      style: TextStyle(color: Colors.grey, fontSize: 13)),
                  ElevatedButton(
                    onPressed: () {
                      // 기록하기 버튼 클릭 시 추가 모드로 이동
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                          const DietEditPage(isEditMode: false),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4BECBE),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 0),
                      minimumSize: const Size(0, 36),
                    ),
                    child: const Text('기록하기',
                        style: TextStyle(fontWeight: FontWeight.bold)),
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

// -------------------------------------------------------------------------
// 2. 식단 기록/수정 페이지 (DietEditPage)
// -------------------------------------------------------------------------
class DietEditPage extends StatefulWidget {
  final bool isEditMode; // 수정 모드인지 여부

  const DietEditPage({super.key, this.isEditMode = false});

  @override
  State<DietEditPage> createState() => _DietEditPageState();
}

class _DietEditPageState extends State<DietEditPage> {
  String _selectedMealTime = '아침'; // 라디오 버튼 선택값

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('기록 편집',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // (1) 시간 입력
                  _buildLabel('시간'),
                  const SizedBox(height: 10),
                  _buildTextField(
                    hint: '오후 12:00',
                  ),

                  const SizedBox(height: 25),

                  // (2) 메모 입력 (이미지상 드롭다운처럼 보이나 텍스트 필드로 구현)
                  _buildLabel('메모'),
                  const SizedBox(height: 10),
                  _buildTextField(
                    hint: '메뉴를 입력해주세요',
                    initialValue: widget.isEditMode ? '김치찌개, 현미밥, 계란찜' : null,
                    suffixIcon:
                    const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                  ),

                  const SizedBox(height: 25),

                  // (3) 사진 업로드 영역
                  _buildLabel('사진'),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, size: 30, color: Colors.grey[400]),
                        const SizedBox(height: 8),
                        Text(
                          '식사 사진 올리기',
                          style: TextStyle(
                              color: Colors.grey[500],
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  // (4) 식사 시간 선택 (라디오 버튼)
                  _buildLabel('식사 시간'),
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
          // 하단 버튼들
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
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(widget.isEditMode ? '수정하기' : '기록하기',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
                if (widget.isEditMode) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFFF6B6B)),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('삭제하기',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color(0xFFFF6B6B))),
                    ),
                  ),
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Helper Widgets for Edit Page ---

  Widget _buildLabel(String text) {
    return Text(text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14));
  }

  Widget _buildTextField(
      {String? hint, String? initialValue, Widget? suffixIcon}) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
        suffixIcon: suffixIcon,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF4BECBE))),
      ),
    );
  }

  Widget _buildRadioOption(String value) {
    bool isSelected = _selectedMealTime == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedMealTime = value),
      child: Row(
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? const Color(0xFF4BECBE) : Colors.white,
              border: Border.all(
                  color: isSelected
                      ? const Color(0xFF4BECBE)
                      : Colors.grey[300]!),
            ),
            child: isSelected
                ? const Icon(Icons.check, size: 12, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 8),
          Text(value, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}