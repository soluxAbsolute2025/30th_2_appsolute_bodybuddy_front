// lib/features/bodylog/data/water_model.dart

class WaterLog {
  final int id;
  final int amount;
  final String time;

  WaterLog({required this.id, required this.amount, required this.time});

  factory WaterLog.fromJson(Map<String, dynamic> json) {
    return WaterLog(
      // 서버 필드명에 맞춰서 매핑
      id: json['waterLogId'] ?? 0,
      amount: json['amountMl'] ?? 0,
      // "2025-12-30T00:00:00"에서 시간만 추출 (00:00)
      time: json['loggedAt'] != null
          ? json['loggedAt'].toString().substring(11, 16)
          : '00:00',
    );
  }
}

// 주간 차트용 데이터 모델
class WaterDailyStat {
  final String day; // "25", "26" (일) 또는 "월", "화" (요일)
  final int totalAmount; // 그날 마신 총량

  WaterDailyStat({required this.day, required this.totalAmount});
}