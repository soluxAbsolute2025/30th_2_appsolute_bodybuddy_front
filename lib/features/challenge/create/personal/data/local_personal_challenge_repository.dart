import 'personal_challenge_repository.dart';
import 'in_memory_personal_store.dart';

class LocalPersonalChallengeRepository implements PersonalChallengeRepository {
  final InMemoryPersonalStore store;

  LocalPersonalChallengeRepository(this.store);

  @override
  Future<int> createPersonalChallenge({
    required String title,
    required String description,
    required String? imageUrl,
    required String goalType,
    required int targetDays,
    required int dailyGoal,
    required String unit,
    required String category,
    required int estimatedReward,
  }) async {
    // 네트워크 흉내(원하면 지워도 됨)
    await Future.delayed(const Duration(milliseconds: 200));

    return store.insert({
      "title": title,
      "description": description,
      "imageUrl": imageUrl,
      "goalType": goalType,
      "targetDays": targetDays,
      "dailyGoal": dailyGoal,
      "unit": unit,
      "category": category,
      "estimatedReward": estimatedReward,
    });
  }
}
