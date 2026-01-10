import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/group_challenge_detail_model.dart';
import '../widgets/group_challenge_info_section.dart';
import '../widgets/group_challenge_description_section.dart';
import '../widgets/group_challenge_rank_section.dart';
import '../widgets/group_challenge_bottom_buttons.dart';

class GroupChallengeDetailPage extends StatelessWidget {
  final GroupChallengeDetail challenge;

  const GroupChallengeDetailPage({
    super.key,
    required this.challenge,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,

      leadingWidth: 48,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Image.asset(
          'assets/challenge/back_vector.png',
          width: 24,
          height: 24,
        ),
      ),

      titleSpacing: 0,
      title: const Text(
        '그룹 챌린지',
        style: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),

      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: TextButton(
            onPressed: () {
              // TODO: 상점 이동
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 4.0,
                horizontal: 8.0,
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xFFD8D8D8),
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/shop.svg', // 🔥 상점 아이콘
                    width: 14,
                    height: 14,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    '상점',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
    body: SingleChildScrollView(
        child: Column(
          children: [
            GroupChallengeInfoSection(challenge: challenge),
            Container(
              width: double.infinity,
              height: 10,
              color: const Color(0xFFF8F8F8),
            ),
            GroupChallengeDescriptionSection(challenge: challenge),
            Container(
              width: double.infinity,
              height: 20,
              color: const Color(0xFFF8F8F8),
            ),
            GroupChallengeRankSection(challenge: challenge),
            const SizedBox(height: 0),
          ],
        ),
      ),

      bottomNavigationBar: const GroupChallengeBottomButtons(),
    );
  }
}
