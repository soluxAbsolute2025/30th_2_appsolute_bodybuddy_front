import 'package:flutter/material.dart';
import '../models/group_challenge_detail_model.dart';
import 'group_challenge_rank_item.dart';

class GroupChallengeRankSection extends StatelessWidget {
  final GroupChallengeDetail challenge;

  const GroupChallengeRankSection({
    super.key,
    required this.challenge,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '순위',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          ...challenge.ranks.map(
            (rank) => GroupChallengeRankItem(rank: rank),
          ),
        ],
      ),
    );
  }
}
