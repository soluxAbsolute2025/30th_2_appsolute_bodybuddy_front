import 'package:flutter/material.dart';
import '../models/group_challenge_list_item.dart';

class NewGroupChallengeCard extends StatelessWidget {
  final GroupChallengeListItem challenge;

  const NewGroupChallengeCard({
    super.key,
    required this.challenge,
  });

  @override
  Widget build(BuildContext context) {
    final isFull = challenge.currentParticipants >= challenge.maxParticipants;

    // status가 RECRUITING이 아닌데도 이 카드에 들어오면 (실수 방지)
    final isRecruiting = challenge.isRecruiting;

    return SizedBox(
      width: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 이미지 영역
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: (challenge.imageUrl != null &&
                        challenge.imageUrl!.isNotEmpty)
                    ? Image.network(
                        challenge.imageUrl!,
                        height: 96,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          height: 96,
                          width: double.infinity,
                          color: const Color(0xFFF5F5F5),
                        ),
                      )
                    : Container(
                        height: 96,
                        width: double.infinity,
                        color: const Color(0xFFF5F5F5),
                      ),
              ),

              if (isFull)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

              /// 모집중/모집완료 뱃지
              Positioned(
                right: 8,
                bottom: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: (!isRecruiting || isFull)
                        ? const Color(0xFFA8A8A8)
                        : const Color(0xFF1AEDB1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    (!isRecruiting || isFull) ? '모집완료' : '모집중',
                    style: const TextStyle(
                      color: Color(0xFFF4F4F4),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// 제목 + 인원수
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  challenge.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Pretendard',
                  ),
                  children: [
                    TextSpan(
                      text: '${challenge.currentParticipants}',
                      style: const TextStyle(
                        color: Color(0xFFFF4806),
                      ),
                    ),
                    const TextSpan(
                      text: '/',
                      style: TextStyle(
                        color: Color(0xFF7D7C7C),
                      ),
                    ),
                    TextSpan(
                      text: '${challenge.maxParticipants}명',
                      style: const TextStyle(
                        color: Color(0xFF7D7C7C),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),

          /// 설명
          Text(
            challenge.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF7D7C7C),
            ),
          ),
        ],
      ),
    );
  }
}
