import 'package:flutter/material.dart';
import '../models/challenge_model.dart';
import '../widgets/progress_bar.dart';


class OngoingChallengeMoreModal {
  static Future<void> show(
    BuildContext context, {
    required List<OngoingChallengeModalItem> items,
    String title = '진행 중인 챌린지',
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
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 0),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return _OngoingChallengeCardOnlyUI(
                        challenge: item.challenge,
                        onTap: item.onTap,
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
class OngoingChallengeModalItem {
  final Challenge challenge;
  final VoidCallback? onTap;

  const OngoingChallengeModalItem({
    required this.challenge,
    this.onTap,
  });
}

/// ✅ OngoingChallengeCard의 UI를 "모달 리스트용"으로만 재구성
class _OngoingChallengeCardOnlyUI extends StatelessWidget {
  final Challenge challenge;
  final VoidCallback? onTap;

  const _OngoingChallengeCardOnlyUI({
    required this.challenge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final progressBg = challenge.category == 'WEEKLY'
        ? const Color(0xFFD6FEFF)
        : const Color(0xFFBDFFEE);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // ✅ 아래 진행 카드 (원래 카드처럼 겹치기)
            Positioned(
              top: 85,
              left: 0,
              right: 0,
              child: Container(
                height: 110,
                padding: const EdgeInsets.fromLTRB(16, 28, 16, 16),
                decoration: BoxDecoration(
                  color: progressBg,
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
                            color: Color(0xFF505050),
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
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF666666),
                          ),
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

            // ✅ 위 흰 카드
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
                  // 아이콘/이미지
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
                          ? const SizedBox()
                          : Image.network(
                              challenge.imageUrl!,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return const SizedBox();
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return const SizedBox();
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
            // 🔽 전체 높이 확보용 (중요)
            const SizedBox(height: 200),
          ],
        ),
      ),
    );
  }
}