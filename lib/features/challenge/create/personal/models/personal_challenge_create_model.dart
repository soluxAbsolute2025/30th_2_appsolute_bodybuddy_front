enum PersonalGoalType { period, count }
enum PersonalCategory { daily, weekly }

class PersonalChallengeCreateModel {
  PersonalGoalType goalType;
  PersonalCategory category;

  int? targetDays;
  int? dailyGoal;
  String unit;

  String title;
  String description;
  String? imageUrl;

  int estimatedReward;

  PersonalChallengeCreateModel({
    this.goalType = PersonalGoalType.period,
    this.category = PersonalCategory.daily,
    this.targetDays,
    this.dailyGoal,
    this.unit = '',
    this.title = '',
    this.description = '',
    this.imageUrl,
    this.estimatedReward = 0,
  });
}
