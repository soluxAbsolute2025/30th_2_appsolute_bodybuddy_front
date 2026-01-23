// lib/features/bodylog/data/diet_model.dart

class DietRecord {
  final int dietRecordId;
  final String mealType;   // "BREAKFAST", "LUNCH", "DINNER", "SNACK"
  final String intakeDate; // "2025-01-23"
  final String intakeTime; // "08:30"
  final List<String> foods;
  final String? memo;
  final String? imageUrl;

  DietRecord({
    required this.dietRecordId,
    required this.mealType,
    required this.intakeDate,
    required this.intakeTime,
    required this.foods,
    this.memo,
    this.imageUrl,
  });

  // JSON -> Dart 객체 변환 (GET 요청 시 사용)
  factory DietRecord.fromJson(Map<String, dynamic> json) {
    return DietRecord(
      dietRecordId: json['dietRecordId'] ?? 0,
      mealType: json['mealType'] ?? 'LUNCH',
      intakeDate: json['intakeDate'] ?? '',
      intakeTime: json['intakeTime'] ?? '',
      foods: List<String>.from(json['foods'] ?? []),
      memo: json['memo'],
      imageUrl: json['imageUrl'],
    );
  }

  // 화면 표시용: 한글 식사 이름 변환
  String get mealTypeKor {
    switch (mealType) {
      case 'BREAKFAST': return '아침 식사';
      case 'LUNCH': return '점심 식사';
      case 'DINNER': return '저녁 식사';
      case 'SNACK': return '간식';
      default: return '식사';
    }
  }
}