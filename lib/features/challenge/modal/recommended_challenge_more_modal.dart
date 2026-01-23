import 'package:flutter/material.dart';
import '../data/dummy_recommended_challenges.dart';
import '../widgets/recommended_challenge_card.dart'; // 너 카드 파일 경로에 맞게 수정

class RecommendedChallengeMoreModal {
  static Future<void> show(
    BuildContext context, {
    required List<RecommendedChallengeModalItem> items,
    String title = '추천 챌린지',
  }) {
    return showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.89,
          minChildSize: 0.35,
          maxChildSize: 0.89,
          builder: (context, scrollController) {
            return Column(
              children: [
                const SizedBox(height: 16),
                Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEBEBEB),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                const SizedBox(height: 16),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      const SizedBox(width: 20), // 닫기 아이콘 균형용
                      Expanded(
                        child: Text(
                          title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.close, size: 20),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                Expanded(
                  child: ListView.separated(
                    controller: scrollController,
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = items[index];

                      return GestureDetector(
                        onTap: item.onTap, // 카드 탭 액션(원하면)
                        child: RecommendedChallengeCard(challenge: item.challenge),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

/// 모달에서 사용할 데이터 모델(가볍게)
class RecommendedChallengeModalItem {
  final RecommendedChallenge challenge;
  final VoidCallback? onTap;

  const RecommendedChallengeModalItem({
    required this.challenge,
    this.onTap,
  });
}
