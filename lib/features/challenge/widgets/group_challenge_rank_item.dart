import 'package:flutter/material.dart';
import '../models/group_challenge.dart';

class GroupChallengeRankItem extends StatelessWidget {
  final ChallengeRank rank;

  const GroupChallengeRankItem({
    super.key,
    required this.rank,
  });

  @override
  Widget build(BuildContext context) {
    final isMe = rank.isMe;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isMe
            ? const Color(0xFFC8FFF1)
            : rank.rank == 1
                ? const Color(0xFFFFF9C4)
                : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Row(
        children: [
          Text('${rank.rank}'),
          const SizedBox(width: 12),
          Text(rank.name),
        ],
      ),
    );
  }
}
