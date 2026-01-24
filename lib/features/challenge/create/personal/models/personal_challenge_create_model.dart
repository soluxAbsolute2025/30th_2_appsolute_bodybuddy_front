import 'dart:io';
import '../widgets/personal_challenge_options.dart';

enum PersonalGoalType { period, count }

extension PersonalGoalTypeApiX on PersonalGoalType {
  String toApi() => this == PersonalGoalType.period ? 'PERIOD' : 'COUNT';
}

class PersonalChallengeCreateModel {
  String title;
  String description;

  PersonalGoalType goalType;

  int? targetDays;
  int? dailyGoal;

  String unit;       // "걸음/분/회/km" 같은 UI값이면 서버용 변환 필요
  String category;   // DAILY / WEEKLY
  int estimatedReward;

  File? imageFile;

  PersonalChallengeCreateModel({
    this.title = '',
    this.description = '',
    this.goalType = PersonalGoalType.period,
    this.targetDays,
    this.dailyGoal,
    this.unit = '',
    this.category = 'DAILY',
    this.estimatedReward = 0,
    this.imageFile,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'goalType': goalType.toApi(),
    'targetDays': targetDays,
    'dailyGoal': dailyGoal,
    'unit': PersonalChallengeOptions.unitToApi[unit] ?? unit,
    'category': category,
    'estimatedReward': estimatedReward,
  };
}
