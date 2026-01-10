class BodyStatus {
  final DateTime date;
  final Metric water;
  final Metric meal;
  final Metric sleep;

  BodyStatus({
    required this.date,
    required this.water,
    required this.meal,
    required this.sleep,
  });

  factory BodyStatus.fromJson(Map<String, dynamic> json) {
    return BodyStatus(
      date: DateTime.parse(json['date']),
      water: Metric.fromJson(json['water']),
      meal: Metric.fromJson(json['meal']),
      sleep: Metric.fromJson(json['sleep']),
    );
  }
}

class Metric {
  final int current;
  final int goal;

  Metric({
    required this.current,
    required this.goal,
  });

  factory Metric.fromJson(Map<String, dynamic> json) {
    return Metric(
      current: json['current'],
      goal: json['goal'],
    );
  }

  double get progress =>
      goal == 0 ? 0 : current / goal;
}
