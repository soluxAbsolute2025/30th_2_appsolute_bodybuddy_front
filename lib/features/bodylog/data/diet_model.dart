import 'package:intl/intl.dart';

class DietRecord {
  final int id;
  final String mealType;
  final String? imageUrl; // 앱에서는 imageUrl로 씀
  final List<String> foods;
  final String memo;
  final String time;

  DietRecord({
    required this.id,
    required this.mealType,
    this.imageUrl,
    required this.foods,
    required this.memo,
    required this.time,
  });

  // 한글 식사명 변환 (화면 표시용)
  String get mealTypeKor {
    switch (mealType) {
      case 'BREAKFAST': return '아침';
      case 'LUNCH': return '점심';
      case 'DINNER': return '저녁';
      default: return '기타';
    }
  }

  factory DietRecord.fromJson(Map<String, dynamic> json) {
    // 1. 이미지 URL 연결 (서버는 'photoUrl', 앱은 'imageUrl')
    String? imgUrl = json['photoUrl']; // ★ 여기가 핵심! 서버 키값에 맞춤

    // 2. 음식 & 메모 파싱 로직
    // 서버가 주는 데이터 형태: "[음식: 김밥]\n메모: 맛있음"
    String rawData = json['memo'] ?? "";
    List<String> parsedFoods = [];
    String parsedMemo = "";

    try {
      if (rawData.contains("[음식:")) {
        // (1) 음식 추출
        // "[음식:" 뒤부터 "]" 앞까지 자르기
        int foodStart = rawData.indexOf("[음식:") + 4; // "[음식:" 길이 고려 (대략적인 위치)
        // 정확히는 ':' 뒤를 찾아야 함
        final parts = rawData.split('\n'); // 줄바꿈으로 나눔

        for (var part in parts) {
          if (part.startsWith("[음식:")) {
            // "[음식: 김밥]" -> "김밥" 추출
            String foodContent = part.replaceAll("[음식:", "").replaceAll("]", "").trim();
            if (foodContent.isNotEmpty) {
              parsedFoods.add(foodContent);
            }
          } else if (part.startsWith("메모:")) {
            // "메모: 맛있음" -> "맛있음" 추출
            parsedMemo = part.replaceAll("메모:", "").trim();
          } else {
            // 그 외 내용은 메모에 붙임
            if (parsedMemo.isNotEmpty) parsedMemo += "\n";
            parsedMemo += part;
          }
        }
      } else {
        // 형식이 다르면 그냥 전체를 메모로 처리
        parsedMemo = rawData;
      }
    } catch (e) {
      parsedMemo = rawData;
      print("메모 파싱 에러: $e");
    }

    // 3. 시간 처리 (loggedAt에서 시간만 추출)
    String timeStr = "";
    if (json['loggedAt'] != null) {
      try {
        DateTime dt = DateTime.parse(json['loggedAt']);
        timeStr = DateFormat("HH:mm").format(dt);
      } catch (_) {}
    }

    return DietRecord(
      id: json['id'] ?? 0,
      mealType: json['mealType'] ?? 'LUNCH',
      imageUrl: imgUrl, // 연결된 이미지 URL
      foods: parsedFoods, // 파싱된 음식 리스트
      memo: parsedMemo,   // 파싱된 메모
      time: timeStr,
    );
  }
}