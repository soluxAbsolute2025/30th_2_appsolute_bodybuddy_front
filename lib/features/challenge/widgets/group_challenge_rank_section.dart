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
    final participants = challenge.participants;

    // 내 랭크 찾기 (없으면 null)
    GroupChallengeParticipant? myRank;
    for (final p in participants) {
      if (p.isMe) {
        myRank = p;
        break;
      }
    }

    // 정렬 (rank 오름차순)
    final sorted = [...participants]..sort((a, b) => a.rank.compareTo(b.rank));

    final List<Widget> items = [];

    // 내 랭크가 4위 밖이면: 상위 4 + ... + 내 랭크
    if (myRank != null && myRank.rank > 4) {
      final top4 = sorted.where((p) => p.rank <= 4).toList();

      for (final p in top4) {
        items.add(GroupChallengeRankItem(participant: p));
      }

      items.add(
        const Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: Center(
            child: Text(
              '...',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFFA8A8A8),
              ),
            ),
          ),
        ),
      );

      items.add(GroupChallengeRankItem(participant: myRank));
    } else {
      // 그 외: 전부 노출
      for (final p in sorted) {
        items.add(GroupChallengeRankItem(participant: p));
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
