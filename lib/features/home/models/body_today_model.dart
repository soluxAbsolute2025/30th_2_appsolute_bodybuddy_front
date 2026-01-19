class BodyMetric {
  final int current;
  final int goal;

  const BodyMetric({
    required this.current,
    required this.goal,
  });

  factory BodyMetric.fromJson(Map<String, dynamic> json) {
    return BodyMetric(
      current: json['current'] as int,
      goal: json['goal'] as int,
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
    return BodyToday(
      date: json['date'] as String,
      water: BodyMetric.fromJson(json['water']),
      meal: BodyMetric.fromJson(json['meal']),
      sleep: BodyMetric.fromJson(json['sleep']),
    );
  }
}
