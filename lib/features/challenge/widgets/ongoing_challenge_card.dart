import 'package:flutter/material.dart';
import '../models/challenge_model.dart';
import 'progress_bar.dart';

class OngoingChallengeCard extends StatelessWidget {
  final Challenge challenge;

  const OngoingChallengeCard({
    super.key,
    required this.challenge,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 85,
            left: 0,
            right: 0,
            child: Container(
              height: 110,
              padding: const EdgeInsets.fromLTRB(16, 28, 16, 16),
              decoration: BoxDecoration(
                color: challenge.type == ChallengeType.weekly
                    ? const Color(0xFFD6FEFF)
                    : const Color(0xFFBDFFEE),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  ProgressBar(value: challenge.progress),
                  const SizedBox(height: 12),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '진행률',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF505050)
                         ),
                      ),
                      Text(
                        '${challenge.current} / ${challenge.total} 일',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '예상 보상',
                        style: TextStyle(fontSize: 12, color: Color(0xFF666666)),
                      ),
                      Text(
                        '${challenge.rewardXp} XP',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ================== 🔼 상단 흰 카드 ==================
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFD8D8D8)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 아이콘
                Container(
                  width: 66,
                  height: 66,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: challenge.imageUrl == null
                        ? const SizedBox() // ❗ 이미지 없으면 회색 네모 그대로
                        : Image.network(
                            challenge.imageUrl!,
                            fit: BoxFit.cover,
                            // 로딩 중일 때
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const SizedBox(); // 회색 유지
                            },
                            // 에러 났을 때
                            errorBuilder: (context, error, stackTrace) {
                              return const SizedBox(); // 회색 유지
                            },
                          ),
                  ),
                ),
                const SizedBox(width: 12),

                // 텍스트 영역
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          challenge.title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            height: 1.0,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          challenge.description,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF7D7C7C),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // D+N 배지
                Container(
                  width: 56,
                  height: 22,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE9FFF9),
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: const Color(0xFF1AEDB1)),
                  ),
                  child: Text(
                    'D + ${challenge.current}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1AEDB1),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 전체 카드 높이 확보용
          const SizedBox(height: 200),
        ],
      ),
    );
  }
}
