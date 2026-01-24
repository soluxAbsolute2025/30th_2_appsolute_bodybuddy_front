import 'package:flutter/material.dart';

import 'overlapping_profile_stack.dart';
import '../models/group_member_model.dart';
import 'rank_badge.dart';
import 'group_code_join_button.dart';
import 'group_code_join_dialog.dart';
import '../pages/group_challenge_detail_page.dart';
import '../models/ongoing_group_challenge.dart';

class ParticipatingGroupChallengeCard extends StatelessWidget {
  final OngoingGroupChallenge challenge;
  final VoidCallback onImageTap;

  const ParticipatingGroupChallengeCard({
    super.key,
    required this.challenge,
    required this.onImageTap,
  });

  @override
  Widget build(BuildContext context) {
    final members = challenge.topParticipants
        .map(
          (p) => GroupMember(
            id: p.nickname, // ✅ 현재 GroupMember에 nickname 필드가 없으니 id에 넣어 사용
            profileImageUrl: p.profileImageUrl ?? '',
            isMe: p.isMe,
          ),
        )
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// 카드 영역
        GestureDetector(
          onTap: onImageTap,
          child: Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              color: challenge.imageUrl == null
                  ? const Color(0xFFF5F5F5)
                  : null,
              borderRadius: BorderRadius.circular(10),
              image: challenge.imageUrl != null
                  ? DecorationImage(
                      image: NetworkImage(challenge.imageUrl!),
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
                  child: RankBadge(rank: challenge.myRank),
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
                challenge.title,
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  height: 1.0,
                  letterSpacing: 0,
                ),
              ),
              Text(
                '${challenge.participantCount}명 참여중 · ${challenge.remainingDays}일 남음',
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

        /// 그룹 코드로 참여 버튼 (참여중 카드라면 보통 "코드 공유/복사"가 더 자연스럽긴 함)
        GroupCodeJoinButton(
          onTap: () async {
            final challengeId = await showJoinGroupCodeDialog(context: context);
            if (!context.mounted) return;
            if (challengeId == null) return;

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('그룹 참여 완료!')),
            );

            Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute(
                builder: (_) => GroupChallengeDetailPage(challengeId: challengeId),
              ),
            );
          },
        ),
      ],
    );
  }
}
