import 'package:flutter/material.dart';

import '../widgets/challenge_scope_toggle.dart';
import '../widgets/ongoing_challenge_card.dart';
import '../data/dummy_challenges.dart';

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
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        titleSpacing: 16,
        centerTitle: false,
        title: const Text(
          '바디 챌린지',
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            height: 1.0,
            color: Colors.black,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Image.asset(
              'asset/challenge/shop.png',
              width: 24,
              height: 24,
            ),
          ),
        ],
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
        ),
      ),
    );
  }
}