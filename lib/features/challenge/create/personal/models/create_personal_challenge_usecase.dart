import 'personal_challenge_create_model.dart';
import '../data/personal_challenge_repository.dart';

class CreatePersonalChallengeUseCase {
  final PersonalChallengeRepository repo;

  CreatePersonalChallengeUseCase(this.repo);

  bool isTypeValid(PersonalChallengeCreateModel m) =>
      m.targetDays != null &&
      m.dailyGoal != null &&
      (m.dailyGoal ?? 0) > 0 &&
      m.unit.trim().isNotEmpty;

  bool isInfoValid(PersonalChallengeCreateModel m) =>
      m.title.trim().isNotEmpty && m.description.trim().isNotEmpty;

  int computeEstimatedReward(PersonalChallengeCreateModel m) {
    final days = m.targetDays ?? 0;
    final goal = m.dailyGoal ?? 0;
    final base = (days * 3) + (goal ~/ 1000) * 5;
    return base.clamp(50, 500);
  }

  Future<int> execute(PersonalChallengeCreateModel m) async {
    // reward 계산해서 모델에 반영
    m.estimatedReward = computeEstimatedReward(m);

    final goalTypeStr = m.goalType == PersonalGoalType.period ? 'PERIOD' : 'COUNT';
    final categoryStr = m.category == PersonalCategory.daily ? 'DAILY' : 'WEEKLY';

    return repo.createPersonalChallenge(
      title: m.title.trim(),
      description: m.description.trim(),
      imageUrl: m.imageUrl,
      goalType: goalTypeStr,
      targetDays: m.targetDays!,
      dailyGoal: m.dailyGoal!,
      unit: m.unit.trim(),
      category: categoryStr,
      estimatedReward: m.estimatedReward,
    );
  }
}
