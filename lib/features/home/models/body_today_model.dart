class BodyMetric {
  final int current;
  final int goal;

  const BodyMetric({
    required this.current,
    required this.goal,
  });

  factory BodyMetric.fromJson(Map<String, dynamic>? json) {
    final currentRaw = json?['current'];
    final goalRaw = json?['goal'];

    return BodyMetric(
      current: currentRaw is int
          ? currentRaw
          : int.tryParse(currentRaw?.toString() ?? '') ?? 0,
      goal: goalRaw is int
          ? goalRaw
          : int.tryParse(goalRaw?.toString() ?? '') ?? 0,
    );
  }
}

class BodyToday {
  final String date;
  final BodyMetric water;
  final BodyMetric meal;
  final BodyMetric sleep;

  const BodyToday({
    required this.date,
    required this.water,
    required this.meal,
    required this.sleep,
  });

  factory BodyToday.fromJson(Map<String, dynamic> json) {
    final date = json['date']?.toString() ?? '';

    Map<String, dynamic>? asMap(dynamic v) =>
        (v is Map) ? v.cast<String, dynamic>() : null;

    return BodyToday(
      date: date,
      water: BodyMetric.fromJson(asMap(json['water'])),
      meal: BodyMetric.fromJson(asMap(json['meal'])),
      sleep: BodyMetric.fromJson(asMap(json['sleep'])),
    );
  }
}
