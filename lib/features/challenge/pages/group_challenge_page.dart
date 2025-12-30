import 'package:flutter/material.dart';
import '../data/dummy_group_challenges.dart';
import '../widgets/participating_group_challenge_card.dart';

class GroupChallengePage extends StatelessWidget {
  const GroupChallengePage({super.key});

  @override
  Widget build(BuildContext context) {
    final participatingChallenges =
        dummyGroupChallenges.where((c) => !c.isRecruiting).toList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),

          /// 참여 중인 챌린지
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 17),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '참여 중인 챌린지',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    height: 1.0,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // TODO: 참여 중 챌린지 전체 페이지 이동
                  },
                  child: const Text(
                    '더보기',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF999999),
                      height: 1.0,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: participatingChallenges.isEmpty
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: Text(
                        '참여 중인 그룹 챌린지가 없어요',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF999999),
                        ),
                      ),
                    ),
                  )
                : Column(
                    children: participatingChallenges
                        .map(
                          (challenge) =>
                            ParticipatingGroupChallengeCard(
                              title: challenge.title,
                              rank: challenge.rank,
                              members: challenge.members,
                              remainDays: challenge.remainDays,
                              imageUrl: challenge.imageUrl,
                          ),
                        )
                        .toList(),
                  ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
