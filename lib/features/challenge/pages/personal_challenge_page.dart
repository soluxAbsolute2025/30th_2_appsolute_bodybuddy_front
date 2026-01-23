import 'package:flutter/material.dart';

import '../widgets/ongoing_challenge_card.dart';
import '../widgets/recommended_challenge_card.dart';
import '../widgets/completed_challenge_card.dart';
import '../widgets/challenge_summary_card.dart';

import '../data/dummy_challenges.dart';
import '../data/dummy_recommended_challenges.dart';
import '../data/dummy_completed_challenges.dart';
import '../data/dummy_challenge_summary.dart';

import '../modal/ongoing_challenge_detail_modal.dart';
import '../modal/recommended_challenge_more_modal.dart';

class PersonalChallengePage extends StatefulWidget {
  const PersonalChallengePage({super.key});

  @override
  State<PersonalChallengePage> createState() => _PersonalChallengePageState();
}

class _PersonalChallengePageState extends State<PersonalChallengePage> {
  @override
  Widget build(BuildContext context) {
    final challenges = dummyPersonalChallenges;

    // 전체 진행 중
    final ongoingAll = challenges
        .where((c) => c.category == 'WEEKLY' || c.category == 'DAILY')
        .toList();

    // 주간 + 일일 각 1개만 노출
    final weeklyOne =
        challenges.where((c) => c.category == 'WEEKLY').take(1);
    final dailyOne =
        challenges.where((c) => c.category == 'DAILY').take(1);
    final ongoingShow = [...weeklyOne, ...dailyOne];

    // 추천 2개만
    final recommendedShow = dummyRecommendedChallenges.take(2).toList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),

          /// ================= 진행 중인 챌린지 =================
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 17),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '진행 중인 챌린지',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    OngoingChallengeMoreModal.show(
                      context,
                      items: ongoingAll.map((challenge) {
                        return OngoingChallengeModalItem(
                          challenge: challenge,
                          onTap: () {
                            Navigator.pop(context);
                            // TODO: 상세 페이지 or 상세 모달
                          },
                        );
                      }).toList(),
                    );
                  },
                  child: const Text(
                    '더보기',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFFA8A8A8),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: ongoingShow
                  .map((c) => OngoingChallengeCard(challenge: c))
                  .toList(),
            ),
          ),

          const SizedBox(height: 24),

          /// ================= 추천 챌린지 =================
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 17),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '추천 챌린지',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    RecommendedChallengeMoreModal.show(
                      context,
                      items: dummyRecommendedChallenges.map((challenge) {
                        return RecommendedChallengeModalItem(
                          challenge: challenge,
                          onTap: () {
                            Navigator.pop(context);
                            // TODO: 추천 챌린지 상세
                          },
                        );
                      }).toList(),
                    );
                  },
                  child: const Text(
                    '더보기',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFFA8A8A8),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: recommendedShow
                  .map((c) => RecommendedChallengeCard(challenge: c))
                  .toList(),
            ),
          ),

          const SizedBox(height: 24),

          /// ================= 구분선 =================
          Container(
            width: double.infinity,
            height: 10,
            color: const Color(0xFFF8F8F8),
          ),

          const SizedBox(height: 16),

          /// ================= 완료한 챌린지 =================
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
                  .map((c) => CompletedChallengeCard(challenge: c))
                  .toList(),
            ),
          ),

          const SizedBox(height: 16),

          ChallengeSummaryCard(summary: dummyChallengeSummary),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
