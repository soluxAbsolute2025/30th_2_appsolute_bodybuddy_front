import '../models/body_status_model.dart';

final dummyBodyStatus = BodyStatus(
  date: DateTime(2025, 9, 25),
  water: Metric(current: 300, goal: 2000),
  meal: Metric(current: 1000, goal: 1000),
  sleep: Metric(current: 3, goal: 3),
);
