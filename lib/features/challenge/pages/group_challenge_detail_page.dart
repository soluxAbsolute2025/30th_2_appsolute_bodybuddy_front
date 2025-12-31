import 'package:flutter/material.dart';
import '../models/group_challenge.dart';
import '../widgets/group_challenge_info_section.dart';
import '../widgets/group_challenge_description_section.dart';
import '../widgets/group_challenge_rank_section.dart';
import '../widgets/group_challenge_bottom_buttons.dart';

class GroupChallengeDetailPage extends StatelessWidget {
  final GroupChallenge challenge;

  const GroupChallengeDetailPage({
    super.key,
    required this.challenge,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          '그룹 챌린지',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  GroupChallengeInfoSection(challenge: challenge),
                  GroupChallengeDescriptionSection(challenge: challenge),
                  GroupChallengeRankSection(challenge: challenge),
                ],
              ),
            ),
          ),
          const GroupChallengeBottomButtons(),
        ],
      ),
    );
  }
}
