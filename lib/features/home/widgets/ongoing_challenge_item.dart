import 'package:flutter/material.dart';
import '../models/ongoing_challenge_model.dart';

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

        /// D-Day
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFE9FFF9),
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: const Color(0xFF1AEDB1)),
          ),
          child: Text(
            'D + ${challenge.dday}',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1AEDB1),
            ),
          ),
        ),
      ],
    );
  }
}
