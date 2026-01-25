// lib/features/bodylog/data/sleep_model.dart

class SleepRecord {
  final int sleepRecordId;
  final String sleepDate;
  final String bedTime; // ★ [수정] sleepTime -> bedTime (서버 필드명과 통일)
  final String wakeTime;
  final String sleepQuality;
  final int totalSleepMinute;

  SleepRecord({
    required this.sleepRecordId,
    required this.sleepDate,
    required this.bedTime, // ★ 생성자도 수정
    required this.wakeTime,
    required this.sleepQuality,
    required this.totalSleepMinute,
  });

  factory SleepRecord.fromJson(Map<String, dynamic> json) {
    // 1. 시간 파싱 (초 단위 제거)
    // 서버가 'bedTime'을 주므로 그것을 최우선으로 받음
    String rawBedTime = json['bedTime'] ?? '00:00';
    String rawWakeTime = json['wakeTime'] ?? '00:00';

    // 00:00:00 -> 00:00 (앞 5글자만 자르기)
    String cleanBedTime = rawBedTime.length >= 5 ? rawBedTime.substring(0, 5) : rawBedTime;
    String cleanWakeTime = rawWakeTime.length >= 5 ? rawWakeTime.substring(0, 5) : rawWakeTime;

    // 2. 수면 시간 (서버가 안 주면 0으로 처리)
    int serverMinutes = json['totalMinutes'] ?? json['totalSleepMinute'] ?? 0;

    return SleepRecord(
      sleepRecordId: json['sleepRecordId'] ??  0,
      sleepDate: json['sleepDate'] ?? '',
      bedTime: cleanBedTime, // ★ 여기에 할당
      wakeTime: cleanWakeTime,
      sleepQuality: json['sleepQuality'] ?? 'NORMAL', // 기본값 영어로
      totalSleepMinute: serverMinutes,
    );
  }

  // 화면에 "7시간 30분" 처럼 보여주는 함수
  String get durationString {
    if (totalSleepMinute == 0) return '0시간';
    int hour = totalSleepMinute ~/ 60;
    int minute = totalSleepMinute % 60;
    if (hour > 0 && minute > 0) return '${hour}시간 ${minute}분';
    if (hour > 0) return '${hour}시간';
    return '${minute}분';
  }

  // 화면에 "좋음", "나쁨" 보여주는 함수
  String get qualityKor {
    switch (sleepQuality) {
      case 'VERY_GOOD': return '매우 좋음';
      case 'GOOD': return '좋음';
      case 'NORMAL': return '보통';
      case 'BAD': return '나쁨';
      case 'VERY_BAD': return '매우 나쁨';
      default: return '보통';
    }
  }
}

// [신규] 주간 데이터를 받는 클래스
class WeeklySleepStats {
  final double averageSleepHours;
  final String weeklyQuality;
  final List<SleepRecord> dailyLogs;

  WeeklySleepStats({
    required this.averageSleepHours,
    required this.weeklyQuality,
    required this.dailyLogs,
  });

  factory WeeklySleepStats.fromJson(Map<String, dynamic> json) {
    var list = json['dailyLogs'] as List? ?? [];
    List<SleepRecord> logs = list.map((i) => SleepRecord.fromJson(i)).toList();

    return WeeklySleepStats(
      averageSleepHours: (json['averageSleepHours'] ?? 0.0).toDouble(),
      weeklyQuality: json['sleepQuality'] ?? 'NORMAL',
      dailyLogs: logs,
    );
  }
}