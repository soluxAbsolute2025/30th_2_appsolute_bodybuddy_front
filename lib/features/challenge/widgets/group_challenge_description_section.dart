import 'package:flutter/material.dart';
import '../models/group_challenge.dart';

class GroupChallengeDescriptionSection extends StatelessWidget {
  final GroupChallenge challenge;

  const GroupChallengeDescriptionSection({
    super.key,
    required this.challenge,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            '챌린지 내용',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(challenge.description),
        ],
      ),
    );
  }
}
