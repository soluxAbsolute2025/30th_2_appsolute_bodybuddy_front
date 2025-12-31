import 'package:flutter/material.dart';
import '../models/group_challenge.dart';
import 'group_challenge_rank_item.dart';

class GroupChallengeRankSection extends StatelessWidget {
  final GroupChallenge challenge;

  const GroupChallengeRankSection({
    super.key,
    required this.challenge,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '순위',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...challenge.ranks.map(
            (rank) => GroupChallengeRankItem(rank: rank),
          ),
        ],
      ),
    );
  }
}
