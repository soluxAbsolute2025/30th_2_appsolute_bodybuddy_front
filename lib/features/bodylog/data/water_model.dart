// lib/features/bodylog/data/water_model.dart

class WaterLog {
  final int id;
  final int amount; // 섭취량 (ml)
  final String time; // "14:30" (화면 표시용)

  WaterLog({
    required this.id,
    required this.amount,
    required this.time,
  });

  factory WaterLog.fromJson(Map<String, dynamic> json) {
    // 서버의 createdAt ("2025-01-24T14:30:00")에서 시간만 추출
    String timeStr = "00:00";
    if (json['createdAt'] != null && json['createdAt'].toString().length > 16) {
      timeStr = json['createdAt'].toString().substring(11, 16);
    }

    return WaterLog(
      id: json['id'] ?? 0,
      amount: json['amount'] ?? 0,
      time: timeStr,
    );
  }
}

// 주간 차트용 데이터 모델
class WaterDailyStat {
  final String day; // "25", "26" (일) 또는 "월", "화" (요일)
  final int totalAmount; // 그날 마신 총량

  WaterDailyStat({required this.day, required this.totalAmount});
}