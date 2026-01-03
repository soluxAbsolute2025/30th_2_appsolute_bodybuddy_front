import 'package:flutter/material.dart';

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

  // 📅 날짜 아이템 하나 (동그라미)
  Widget _buildDateItem(String day, String weekDay, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: Column(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF4BECBE) : Colors.white, // 선택되면 민트색
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

  // 🍽️ 타임라인 아이템 (식사 기록 카드)
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
          Column(
            children: [
              Text(mealType.substring(0, 2), // "아침", "점심" 두 글자만 따오기
                  style: const TextStyle(fontSize: 10, color: Color(0xFF4BECBE), fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: Color(0xFF4BECBE), // 민트색 점
                  shape: BoxShape.circle,
                ),
              ),
              // 마지막 아이템이 아니면 아래로 선을 그음
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: const Color(0xFF4BECBE).withOpacity(0.3), // 연한 민트색 선
                  ),
                ),
            ],
          ),
          const SizedBox(width: 15),

          // 오른쪽 카드 내용
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30), // 다음 아이템과의 간격
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50], // 아주 연한 회색 배경
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 카드 헤더 (제목 + 시간)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(mealType, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(width: 5),
                            const Icon(Icons.edit, size: 14, color: Colors.grey),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.access_time, size: 14, color: Color(0xFF4BECBE)),
                            const SizedBox(width: 4),
                            Text(time, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),

                    // 음식 사진 + 메뉴 리스트
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 사진 자리 (회색 박스)
                        Container(
                          width: 100,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        const SizedBox(width: 15),
                        // 메뉴 텍스트 리스트
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: menus
                                .map((menu) => Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Text('•  $menu', style: const TextStyle(fontSize: 13)),
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
        ],
      ),
    );
  }

  // 📝 기록하기 버튼이 있는 빈 타임라인
  Widget _buildEmptyTimelineItem({required String mealType, required bool isLast}) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 왼쪽 타임라인
          Column(
            children: [
              Text(mealType.substring(0, 2),
                  style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey), // 빈 동그라미
                  shape: BoxShape.circle,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(width: 2, color: Colors.grey.withOpacity(0.3)),
                ),
            ],
          ),
          const SizedBox(width: 15),

          // 오른쪽 빈 카드
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
                  const Text('아직 기록하지 않았어요!', style: TextStyle(color: Colors.grey)),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4BECBE),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: const Size(80, 36),
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