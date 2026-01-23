// lib/features/bodylog/data/sleep_model.dart

class SleepRecord {
  final int sleepId;
  final String sleepDate; // "2025-01-24"
  final String sleepTime; // "23:00" (취침)
  final String wakeTime;  // "07:00" (기상)
  final String sleepQuality; // "GOOD", "BAD" 등 (서버 값)
  final int totalSleepMinute; // 총 수면 시간(분) - 서버에서 주거나 계산

  SleepRecord({
    required this.sleepId,
    required this.sleepDate,
    required this.sleepTime,
    required this.wakeTime,
    required this.sleepQuality,
    required this.totalSleepMinute,
  });

  factory SleepRecord.fromJson(Map<String, dynamic> json) {
    return SleepRecord(
      sleepId: json['sleepId'] ?? 0,
      sleepDate: json['sleepDate'] ?? '',
      sleepTime: json['sleepTime'] ?? '00:00',
      wakeTime: json['wakeTime'] ?? '00:00',
      sleepQuality: json['sleepQuality'] ?? '보통',
      totalSleepMinute: json['totalSleepMinute'] ?? 0,
    );
  }

  // 화면 표시용 품질 한글 변환
  String get qualityKor {
    switch (sleepQuality) {
      case 'VERY_GOOD': return '매우 좋음';
      case 'GOOD': return '좋음';
      case 'NORMAL': return '보통';
      case 'BAD': return '나쁨';
      default: return '보통';
    }
  }

  // "7시간 30분" 형태의 문자열 반환
  String get durationString {
    int hour = totalSleepMinute ~/ 60;
    int minute = totalSleepMinute % 60;
    return '${hour}시간 ${minute}분';
  }
}