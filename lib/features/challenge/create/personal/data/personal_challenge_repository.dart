abstract class PersonalChallengeRepository {
  Future<int> createPersonalChallenge({
    required String title,
    required String description,
    required String? imageUrl,
    required String goalType,      // "PERIOD" / "COUNT"
    required int targetDays,
    required int dailyGoal,
    required String unit,
    required String category,      // "DAILY" / "WEEKLY"
    required int estimatedReward,
  });
}
