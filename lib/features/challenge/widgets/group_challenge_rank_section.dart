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
    final ranks = challenge.ranks;
    final myRank = ranks.where((r) => r.isMe).isNotEmpty
        ? ranks.firstWhere((r) => r.isMe)
        : null;

    final List<Widget> items = [];
    if (myRank != null && myRank.rank > 4) {
      final top4 = ranks.where((r) => r.rank <= 4).toList()
        ..sort((a, b) => a.rank.compareTo(b.rank));

      for (final r in top4) {
        items.add(
          GroupChallengeRankItem(
            rank: r,
            progress: r.progress, // (rank에 progress 넣어둔 상태 기준)
          ),
        );
      }

      items.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Center(
            child: Text(
              '...',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFA8A8A8),
              ),
            ),
          ),
        ),
      );

      items.add(
        GroupChallengeRankItem(
          rank: myRank,
          progress: myRank.progress,
        ),
      );
    } else {
      final sorted = [...ranks]..sort((a, b) => a.rank.compareTo(b.rank));
      for (final r in sorted) {
        items.add(
          GroupChallengeRankItem(
            rank: r,
            progress: r.progress,
          ),
        );
      }
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(color: Colors.white),
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
          const SizedBox(height: 10),
          ...items,
        ],
      ),
    );
  }
}
