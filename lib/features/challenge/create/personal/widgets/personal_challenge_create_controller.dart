import '../models/personal_challenge_create_model.dart';

class PersonalChallengeCreateController {
  final PersonalChallengeCreateModel model;

  PersonalChallengeCreateController(this.model);

  bool get _isCountType => model.goalType == 'COUNT';

  bool get isTypePageValid {
    final hasDailyGoal = model.dailyGoal != null && model.dailyGoal! > 0;
    final hasUnit = model.unit.trim().isNotEmpty;

    if (_isCountType) {
      return hasDailyGoal && hasUnit;
    }

    final hasDays = model.targetDays != null && model.targetDays! >= 7;
    return hasDays && hasDailyGoal && hasUnit;
  }

  bool get isInfoPageValid {
    return model.title.trim().isNotEmpty && model.description.trim().isNotEmpty;
  }

  bool get isCreateValid => isTypePageValid && isInfoPageValid;

  int get rewardXp {
    final days = model.targetDays ?? 0;
    final daily = model.dailyGoal ?? 0;

    final base = (days * 10) + (daily ~/ 1000) * 5;
    return base.clamp(50, 500);
  }
}
