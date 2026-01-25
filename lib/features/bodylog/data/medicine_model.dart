class MedicineRecord {
  final int id;            // 프리셋 ID
  final String name;       // 약 이름
  final String timing;     // 식전, 식후
  final String frequencyKor; // 매일
  final String timeKor;    // 아침, 점심, 저녁

  // 상태 관리 변수
  bool isTaken;            // 복용 여부
  int? logId;              // 서버 기록 ID

  MedicineRecord({
    required this.id,
    required this.name,
    required this.timing,
    required this.frequencyKor,
    required this.timeKor,
    this.isTaken = false,
    this.logId,
  });

  factory MedicineRecord.fromJson(Map<String, dynamic> json) {
    // 1. 이름 안전하게 가져오기 (없으면 '이름 없음')
    String nameValue = json['medicineName'] ?? json['medicationName'] ?? json['name'] ?? '이름 없음';

    // 2. 시간대 안전하게 만들기
    List<String> times = [];
    if (json['takeMorning'] == true) times.add('아침');
    if (json['takeLunch'] == true) times.add('점심');
    if (json['takeDinner'] == true) times.add('저녁');
    String timeStr = times.isEmpty ? '시간 미정' : times.join(', ');

    // 3. 타이밍 안전하게 가져오기
    String timingValue = json['timing'] ?? '식후';

    // 🚨 4. [에러 원인 해결] 빈도(frequencyKor)가 null이면 '매일'로 강제 고정
    String freqValue = json['frequencyKor'] ?? json['frequency'] ?? '매일';

    return MedicineRecord(
      id: json['presetId'] ?? 0,
      name: nameValue,
      timing: timingValue,
      frequencyKor: freqValue, // 👈 여기가 Null이라서 터졌던 것임!
      timeKor: timeStr,
      isTaken: false,
      logId: null,
    );
  }
}