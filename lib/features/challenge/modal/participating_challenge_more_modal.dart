import 'package:flutter/material.dart';
import '../models/group_member_model.dart';
import '../widgets/overlapping_profile_stack.dart';
import '../widgets/rank_badge.dart';

class ParticipatingChallengeMoreModal {
  static Future<void> show(
    BuildContext context, {
    required List<ParticipatingChallengeModalItem> items,
    String title = '참여 중인 챌린지',
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
                    separatorBuilder: (_, __) => const SizedBox(height: 40),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return _ParticipatingChallengeCardOnlyUI(
                        title: item.title,
                        rank: item.rank,
                        remainDays: item.remainDays,
                        members: item.members,
                        imageUrl: item.imageUrl,
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
class ParticipatingChallengeModalItem {
  final String title;
  final int rank;
  final int remainDays;
  final List<GroupMember> members;
  final String? imageUrl;
  final VoidCallback? onTap;

  const ParticipatingChallengeModalItem({
    required this.title,
    required this.rank,
    required this.remainDays,
    required this.members,
    this.imageUrl,
    this.onTap,
  });
}

/// ✅ ParticipatingGroupChallengeCard에서 "그룹 코드 참여 버튼"만 뺀 UI
class _ParticipatingChallengeCardOnlyUI extends StatelessWidget {
  final String title;
  final int rank;
  final int remainDays;
  final List<GroupMember> members;
  final String? imageUrl;
  final VoidCallback? onTap;

  const _ParticipatingChallengeCardOnlyUI({
    required this.title,
    required this.rank,
    required this.remainDays,
    required this.members,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final memberCount = members.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// 카드 영역
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              color: imageUrl == null ? const Color(0xFFF5F5F5) : null,
              borderRadius: BorderRadius.circular(10),
              image: imageUrl != null
                  ? DecorationImage(
                      image: NetworkImage(imageUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: Stack(
              children: [
                /// 우측 상단 순위 뱃지
                Positioned(
                  top: 12,
                  right: 12,
                  child: RankBadge(rank: rank),
                ),

                /// 하단 프로필
                Positioned(
                  bottom: 16,
                  left: 16,
                  child: OverlappingProfileStack(members: members),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 12),

        /// 챌린지 제목 + 정보
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  height: 1.0,
                  letterSpacing: 0,
                ),
              ),
              Text(
                '$memberCount명 참여중 · $remainDays일 남음',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF7D7C7C),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
