// lib/features/bodylog/data/medicine_model.dart

class MedicineRecord {
  final int id;
  final String name;      // 약 이름
  final String frequency; // 빈도 (BREAKFAST, LUNCH, DINNER)
  final String time;      // 시간 (AFTER_MEAL, BEFORE_MEAL, etc)
  final bool isTaken;     // 복용 여부

  MedicineRecord({
    required this.id,
    required this.name,
    required this.frequency,
    required this.time,
    required this.isTaken,
  });

  factory MedicineRecord.fromJson(Map<String, dynamic> json) {
    return MedicineRecord(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      frequency: json['frequency'] ?? 'BREAKFAST', // 기본값
      time: json['time'] ?? 'AFTER_MEAL',          // 기본값
      isTaken: json['isTaken'] ?? false,
    );
  }

  // 화면 표시용 한글 변환 (빈도)
  String get frequencyKor {
    switch (frequency) {
      case 'BREAKFAST': return '아침';
      case 'LUNCH': return '점심';
      case 'DINNER': return '저녁';
      default: return '아침';
    }
  }

  // 화면 표시용 한글 변환 (시간)
  String get timeKor {
    switch (time) {
      case 'AFTER_MEAL': return '식후';
      case 'BEFORE_MEAL': return '식전';
      case 'EMPTY_STOMACH': return '공복';
      case 'BEFORE_SLEEP': return '취침 전';
      default: return '식후';
    }
  }
}