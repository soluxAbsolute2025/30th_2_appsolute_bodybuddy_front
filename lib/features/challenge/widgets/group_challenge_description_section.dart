import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/group_challenge_detail_model.dart';

class GroupChallengeDescriptionSection extends StatelessWidget {
  final GroupChallengeDetail challenge;

  const GroupChallengeDescriptionSection({super.key, required this.challenge});

  @override
  Widget build(BuildContext context) {
    final info = challenge.challengeInfo;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 챌린지 내용
          Row(
            children: [
              const Text(
                '챌린지 내용',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const Spacer(),

              GestureDetector(
                onTap: () {
                  // TODO: 수정 로직
                },
                child: SvgPicture.asset(
                  'assets/challenge/pencil.svg',
                  width: 18,
                  height: 18,
                  colorFilter: const ColorFilter.mode(
                    Color(0xFF9E9E9E),
                    BlendMode.srcIn,
                  ),
                ),
              ),

              const SizedBox(width: 18),

              GestureDetector(
                onTap: () {
                  // TODO: 삭제 로직
                },
                child: SvgPicture.asset(
                  'assets/challenge/trash.svg',
                  width: 18,
                  height: 18,
                  colorFilter: const ColorFilter.mode(
                    Color(0xFFFF4D4F),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          Padding(
            padding: const EdgeInsets.only(left: 1),
            child: Text(
              info.description, // ✅ 여기
              style: const TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 1.4,
                color: Color(0xFF464646),
              ),
            ),
          ),

          const SizedBox(height: 15),

          Container(
            width: double.infinity,
            height: 3,
            color: const Color(0xFFF8F8F8),
          ),

          const SizedBox(height: 15),

          /// 그룹 코드
          Row(
            children: [
              const Text(
                '그룹 코드',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  info.groupCode,
                  style: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF464646),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
