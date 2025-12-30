import 'package:flutter/material.dart';
import '../widgets/challenge_scope_toggle.dart';
import '../widgets/ongoing_challenge_card.dart';
import '../data/dummy_challenges.dart';
import '../data/dummy_recommended_challenges.dart';
import '../widgets/recommended_challenge_card.dart';
import '../data/dummy_completed_challenges.dart';
import '../widgets/completed_challenge_card.dart';
import '../../../common/widgets/main_appbar.dart';
import '../widgets/challenge_summary_card.dart';
import '../data/dummy_challenge_summary.dart';
import '../widgets/challenge_floating_button.dart';

class ChallengePage extends StatefulWidget {
  const ChallengePage({super.key});

  @override
  State<ChallengePage> createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengePage> {
  /// true = 개인, false = 그룹
  bool isPersonalSelected = true;

  @override
  Widget build(BuildContext context) {
    final challenges = isPersonalSelected
        ? dummyPersonalChallenges
        : dummyGroupChallenges;

    return Scaffold(
      appBar: MainAppbar(
      navIndex: 2,
      titleText: '바디 챌린지',
      imageUrl: 'assets/challenge/shop.svg',
      buttonText: '상점',
      onButtonPressed: () {
      },
    ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ChallengeScopeToggle(
              isPersonalSelected: isPersonalSelected,
              onChanged: (value) {
                setState(() {
                  isPersonalSelected = value;
                });
              },
            ),

            const SizedBox(height: 30),

            // 진행 중인 챌린지 (개인일 때만)
            if (isPersonalSelected) ...[
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 17),
                child: Text(
                  '진행 중인 챌린지',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    height: 1.0,
                    letterSpacing: 0,
                    color: Colors.black,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: challenges
                      .map(
                        (challenge) =>
                            OngoingChallengeCard(challenge: challenge),
                      )
                      .toList(),
                ),
              ),

              const SizedBox(height: 24),
            ],

            // 추천 챌린지
            if (isPersonalSelected) ...[
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
                        height: 1.0,
                        color: Colors.black,
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
                      .map(
                        (challenge) =>
                            RecommendedChallengeCard(challenge: challenge),
                      )
                      .toList(),
                ),
              ),

              const SizedBox(height: 24),
            ],

            Container(
              width: double.infinity,
              height: 10,
              color: const Color(0xFFF8F8F8),
            ),
            const SizedBox(height: 16),

            // 완료한 챌린지 (개인일 때만)
            if (isPersonalSelected) ...[
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 17),
                child: Text(
                  '완료한 챌린지',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    height: 1.0,
                    color: Colors.black,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: dummyCompletedChallenges
                      .map(
                        (challenge) =>
                            CompletedChallengeCard(challenge: challenge),
                      )
                      .toList(),
                ),
              ),

              const SizedBox(height: 16),
              
              ChallengeSummaryCard(
                summary: dummyChallengeSummary,
              ),

              const SizedBox(height: 24),
            ],

          ],
        ),
      ),
      floatingActionButton: isPersonalSelected
          ? ChallengeFloatingButton(
              onPressed: () {
                // TODO: 새 챌린지 생성 페이지 이동
                // Navigator.pushNamed(context, '/challenge/create');
              },
            )
          : null,

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      
    );
  }
}