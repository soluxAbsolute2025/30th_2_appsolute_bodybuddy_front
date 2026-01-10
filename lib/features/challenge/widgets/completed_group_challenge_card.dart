import 'package:flutter/material.dart';
import '../models/completed_group_challenge_model.dart';
import '../data/dummy_completed_group_challenge.dart';

class CompletedGroupChallengeCard extends StatelessWidget {
  final CompletedGroupChallenge challenge;

  const CompletedGroupChallengeCard({
    super.key,
    required this.challenge,
  });

  @override
  Widget build(BuildContext context) {
    final badgeText = challenge.isSuccess ? '챌린지 성공!' : '챌린지 실패';

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
                child: challenge.imageUrl.isNotEmpty
                    ? Image.network(
                        challenge.imageUrl,
                        height: 96,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _imageFallback(),
                      )
                    : _imageFallback(),
              ),

              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.35),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              /// 오른쪽 아래 배지
              Positioned(
                right: 8,
                bottom: 8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFA8A8A8),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    badgeText,
                    style: const TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFF4F4F4),
                      height: 1.0,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// 제목 + 인원수(오른쪽, 빨간색)
          Row(
            children: [
              Expanded(
                child: Text(
                  challenge.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF747474),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                challenge.memberText,
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF747474),
                  height: 1.0,
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),

          /// 설명
          Text(
            challenge.description,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Color(0xFF7D7C7C),
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _imageFallback() {
    return Container(
      height: 96,
      width: double.infinity,
      color: const Color(0xFFE0E0E0),
    );
  }
}

/// ✅ 샘플: "완료한 챌린지" 섹션 (원하면 다른 파일로 빼도 됨)
class CompletedGroupChallengeSection extends StatelessWidget {
  const CompletedGroupChallengeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 17),
          child: Text(
            '완료한 챌린지',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF464646),
              height: 1.0,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 160,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 17),
            scrollDirection: Axis.horizontal,
            itemCount: dummyCompletedGroupChallenges.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              return CompletedGroupChallengeCard(
                challenge: dummyCompletedGroupChallenges[index],
              );
            },
          ),
        ),
      ],
    );
  }
}