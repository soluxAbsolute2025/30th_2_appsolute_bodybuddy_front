import 'package:flutter/material.dart';
import '../widgets/ongoing_challenge_card.dart';
import '../data/dummy_challenges.dart';
import '../data/dummy_recommended_challenges.dart';
import '../widgets/recommended_challenge_card.dart';
import '../data/dummy_completed_challenges.dart';
import '../widgets/completed_challenge_card.dart';
import '../widgets/challenge_summary_card.dart';
import '../data/dummy_challenge_summary.dart';

class PersonalChallengePage extends StatefulWidget {
  const PersonalChallengePage({super.key});

  @override
  State<PersonalChallengePage> createState() => _PersonalChallengePageState();
}

class _PersonalChallengePageState extends State<PersonalChallengePage> {
  @override
  Widget build(BuildContext context) {
    final challenges = dummyPersonalChallenges;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),

          /// 진행 중인 챌린지
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 17),
            child: Text(
              '진행 중인 챌린지',
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: challenges
                  .map((challenge) => OngoingChallengeCard(challenge: challenge))
                  .toList(),
            ),
          ),

          const SizedBox(height: 24),

          /// 추천 챌린지
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 17),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '추천 챌린지',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '더보기',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF999999),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: dummyRecommendedChallenges
                  .map((challenge) => RecommendedChallengeCard(challenge: challenge))
                  .toList(),
            ),
          ),

          const SizedBox(height: 24),

          Container(
            width: double.infinity,
            height: 15,
            color: const Color(0xFFF8F8F8),
          ),

          const SizedBox(height: 16),

          /// 완료한 챌린지
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 17),
            child: Text(
              '완료한 챌린지',
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: dummyCompletedChallenges
                  .map((challenge) => CompletedChallengeCard(challenge: challenge))
                  .toList(),
            ),
          ),

          const SizedBox(height: 16),

          ChallengeSummaryCard(
            summary: dummyChallengeSummary,
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
