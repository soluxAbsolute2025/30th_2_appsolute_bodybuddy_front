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
    final info = challenge.challengeInfo; // ✅ 핵심

    return Column(
      children: [
        /// 이미지 영역
        Container(
          height: 250,
          decoration: BoxDecoration(
            color: info.imageUrl == null ? const Color(0xFFF5F5F5) : null,
            image: info.imageUrl != null
                ? DecorationImage(
                    image: NetworkImage(info.imageUrl!),
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
                info.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 16),

              /// 기간 (API: "2025.11.27" 문자열)
              _InfoRow(
                iconPath: 'assets/challenge/calender.png',
                text: '${_formatDateStr(info.startDate)} ~ ${_formatDateStr(info.endDate)}',
              ),

              /// 참여 인원
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
                            text: '${info.currentParticipantCount}명 참여 ',
                          ),
                          TextSpan(
                            text: '/ ${info.maxParticipantCount}명',
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
                text: info.isPublic ? '친구 공개' : '비공개',
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// API가 "2025.11.27" / "2025.11.27" 같은 문자열을 준다는 전제
  /// 표시를 "2025. 11. 27" 형태로만 맞춰줌
  String _formatDateStr(String raw) {
    // raw가 이미 "2025.11.27" 또는 "2025. 11. 27" 등일 수 있음
    final cleaned = raw.replaceAll(' ', '');
    final parts = cleaned.split('.');
    if (parts.length != 3) return raw; // 예상 포맷 아니면 원본 그대로

    final y = parts[0];
    final m = parts[1];
    final d = parts[2];
    return '$y. $m. $d';
  }
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
