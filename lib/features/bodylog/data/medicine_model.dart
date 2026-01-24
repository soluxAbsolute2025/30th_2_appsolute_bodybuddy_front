class MedicineRecord {
  final int id;
  final String name;       // 약 이름
  final String timing;     // 식전, 식후 등

  final bool takeMorning;
  final bool takeLunch;
  final bool takeDinner;

  bool isTaken;

  MedicineRecord({
    required this.id,
    required this.name,
    required this.timing,
    required this.takeMorning,
    required this.takeLunch,
    required this.takeDinner,
    this.isTaken = false,
  });

  factory MedicineRecord.fromJson(Map<String, dynamic> json) {
    // 🕵️‍♂️ [디버깅용] 이 로그가 콘솔에 뜨면 "이름"이 어떤 영어 단어로 오는지 확인해보세요!
    print("🔍 [데이터 확인] ID:${json['presetId']} / 전체: $json");

    return MedicineRecord(
      id: json['presetId'] ?? 0,

      // 🚨 [수정] 서버가 줄 수 있는 모든 이름표를 다 검사합니다.
      // 순서대로 찾아서 있으면 그걸 씁니다.
      name: json['medicationName'] ??
          json['medicineName'] ??
          json['name'] ??          // 혹시 그냥 'name'일 수도 있음
          json['itemName'] ??      // 혹시 'itemName'?
          '이름 없음',             // 다 없으면 그때 '이름 없음'

      timing: json['timing'] ?? '식후',

      takeMorning: json['takeMorning'] == true,
      takeLunch: json['takeLunch'] == true,
      takeDinner: json['takeDinner'] == true,

      isTaken: false,
    );
  }

  String get frequencyKor {
    List<String> parts = [];
    if (takeMorning) parts.add('아침');
    if (takeLunch) parts.add('점심');
    if (takeDinner) parts.add('저녁');

    if (parts.isEmpty) return '매일';
    return parts.join(', ');
  }

  String get timeKor => timing;
}