import 'package:flutter/material.dart';
import '../models/ongoing_challenge_model.dart';
import '../../challenge/widgets/rank_badge.dart';

class OngoingChallengeItem extends StatelessWidget {
  final OngoingChallenge challenge;
  final bool isGroup;

  const OngoingChallengeItem({
    super.key,
    required this.challenge,
    required this.isGroup,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        /// 썸네일
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            shape: isGroup ? BoxShape.circle : BoxShape.rectangle,
            borderRadius: isGroup ? null : BorderRadius.circular(10),
          ),
          child: challenge.profileUrl != null
              ? ClipRRect(
                  borderRadius: isGroup
                      ? BorderRadius.circular(26)
                      : BorderRadius.circular(10),
                  child: Image.network(
                    challenge.profileUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const SizedBox(),
                  ),
                )
              : const SizedBox(),
        ),

        const SizedBox(width: 12),

        /// 제목
        Expanded(
          child: Text(
            challenge.title,
            style: const TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        /// 개인 / 그룹 분기 뱃지
        isGroup
            ? RankBadge(
                rank: challenge.rank ?? 0,
              )
            : _DDayBadge(
                dday: challenge.dday ?? 0,
              ),
      ],
    );
  }
}

/// dday
class _DDayBadge extends StatelessWidget {
  final int dday;

  const _DDayBadge({required this.dday});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFE9FFF9),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: const Color(0xFF1AEDB1),
          width: 1,
        ),
      ),
      child: Text(
        'D + $dday',
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1AEDB1),
        ),
      ),
    );
  }
}
