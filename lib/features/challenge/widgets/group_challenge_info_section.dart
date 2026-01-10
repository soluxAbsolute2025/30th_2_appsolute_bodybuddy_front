import 'package:flutter/material.dart';
import '../models/group_challenge_detail_model.dart';

class GroupChallengeInfoSection extends StatelessWidget {
  final GroupChallengeDetail challenge;

  const GroupChallengeInfoSection({
    super.key,
    required this.challenge,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// 이미지 영역
        Container(
          height: 250,
          decoration: BoxDecoration(
            color: challenge.imageUrl == null
                ? const Color(0xFFF5F5F5)
                : null,
            image: challenge.imageUrl != null
                ? DecorationImage(
                    image: NetworkImage(challenge.imageUrl!),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
        ),

        /// 정보 카드
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 제목
              Text(
                challenge.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 16),

              /// 기간
              _InfoRow(
                iconPath: 'assets/challenge/calender.png',
                text:
                    '${_format(challenge.startDate)} ~ ${_format(challenge.endDate)}',
              ),

              /// 참여 인원 (🔥 부분 스타일)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/challenge/person.png',
                      width: 20,
                      height: 20,
                    ),
                    const SizedBox(width: 8),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF000000),
                        ),
                        children: [
                          TextSpan(
                            text:
                                '${challenge.currentParticipants}명 참여 ',
                          ),
                          TextSpan(
                            text: '/ ${challenge.maxParticipants}명',
                            style: const TextStyle(
                              color: Color(0xFFA8A8A8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              /// 공개 여부
              _InfoRow(
                iconPath: 'assets/challenge/lock.png',
                text: challenge.isPublic ? '친구 공개' : '비공개',
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _format(DateTime d) => '${d.year}. ${d.month}. ${d.day}';
}

class _InfoRow extends StatelessWidget {
  final String iconPath;
  final String text;

  const _InfoRow({
    required this.iconPath,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Image.asset(
            iconPath,
            width: 20,
            height: 20,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF000000),
            ),
          ),
        ],
      ),
    );
  }
}
