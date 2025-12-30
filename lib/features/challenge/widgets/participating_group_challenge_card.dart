import 'package:flutter/material.dart';
import 'overlapping_profile_stack.dart';
import '../models/group_member_model.dart';
import 'rank_badge.dart';
import 'group_code_join_button.dart';


class ParticipatingGroupChallengeCard extends StatelessWidget {
  final String title;
  final int rank;
  final int remainDays;
  final List<GroupMember> members;
  final String? imageUrl;

  const ParticipatingGroupChallengeCard({
    super.key,
    required this.title,
    required this.rank,
    required this.remainDays,
    required this.members,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final memberCount = members.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// 카드 영역
        Container(
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
                child: Positioned(
                  top: 12,
                  right: 12,
                  child: RankBadge(rank: rank),
                ),
              ),

              /// 하단 프로필 자리 (placeholder)
              Positioned(
                bottom: 16,
                left: 16,
                child: OverlappingProfileStack(members: members),
              ),
            ],
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

        const SizedBox(height: 40),

        /// 그룹 코드로 참여 버튼
        GroupCodeJoinButton(
          onTap: () {
            // TODO: 그룹 코드 입력 BottomSheet 열기
          },
        ),
      ],
    );
  }
}
