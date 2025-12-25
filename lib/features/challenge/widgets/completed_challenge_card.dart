import 'package:flutter/material.dart';
import '../data/dummy_completed_challenges.dart';

class CompletedChallengeCard extends StatelessWidget {
  final CompletedChallenge challenge;

  const CompletedChallengeCard({
    super.key,
    required this.challenge,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD8D8D8)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 이미지 영역
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // 이미지 or 회색 네모
                  challenge.imageUrl != null
                      ? Image.network(
                          challenge.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: const Color(0xFFD8D8D8),
                            );
                          },
                        )
                      : Container(
                          color: const Color(0xFFD8D8D8),
                          child: const Icon(
                            Icons.check_circle_outline,
                            color: Colors.grey,
                          ),
                        ),

                  Container(
                    color: Colors.black.withOpacity(0.35),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 12),

          // 텍스트
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  challenge.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF747474),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  challenge.description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF7D7C7C),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // 성공 버튼 (비활성)
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFA8A8A8),
              borderRadius: BorderRadius.circular(5),
            ),
            child: const Text(
              '챌린지 성공!',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: const Color(0xFFF4F4F4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
