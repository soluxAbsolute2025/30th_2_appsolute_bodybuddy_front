import 'package:flutter/material.dart';
import '../data/dummy_recommended_challenges.dart';

class RecommendedChallengeCard extends StatelessWidget {
  final RecommendedChallenge challenge;

  const RecommendedChallengeCard({
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 왼쪽 아이콘 영역
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(10),
              image: challenge.imageUrl != null
                  ? DecorationImage(
                      image: NetworkImage(challenge.imageUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: challenge.imageUrl == null
                ? const Icon(
                    Icons.fitness_center,
                    color: Colors.grey,
                  )
                : null,
          ),

          const SizedBox(width: 12),

          // 텍스트 영역
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  challenge.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
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

          // 시작하기 버튼
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF1AEDB1),
              borderRadius: BorderRadius.circular(5),
            ),
            child: const Text(
              '시작하기',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
