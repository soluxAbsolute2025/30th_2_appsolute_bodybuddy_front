import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/group_challenge_detail_model.dart';
import '../widgets/group_challenge_info_section.dart';
import '../widgets/group_challenge_description_section.dart';
import '../widgets/group_challenge_rank_section.dart';
import '../widgets/group_challenge_bottom_buttons.dart';

import '../data/dummy_challenge_verify.dart';
import '../modal/challenge_verify_confirm_modal.dart';
import '../modal/challenge_verify_complete_modal.dart';

class GroupChallengeDetailPage extends StatefulWidget {
  final GroupChallengeDetail challenge;

  const GroupChallengeDetailPage({super.key, required this.challenge});

  @override
  State<GroupChallengeDetailPage> createState() =>
      _GroupChallengeDetailPageState();
}

class _GroupChallengeDetailPageState extends State<GroupChallengeDetailPage> {
  bool isVerified = false;
  bool isLoading = false;

    Future<void> _onPressVerify() async {
      if (isLoading || isVerified) return;

      await showChallengeVerifyConfirmModal(
        context: context,
        challengeTitle: DummyChallengeVerify.dailyTitle,
        onConfirm: () async {
          setState(() => isLoading = true);

          // TODO: 백엔드 API 자리
          // await api.verify();

          // ✅ 완료 모달을 "닫힐 때까지" 기다림
          await showChallengeVerifyCompleteModal(
            context: context,
            point: DummyChallengeVerify.rewardPoint,
          );

          if (!mounted) return;
          setState(() {
            isLoading = false;
            isVerified = true;
          });
        },
      );
    }

  @override
  Widget build(BuildContext context) {
    final challenge = widget.challenge;

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
                      'assets/challenge/shop.svg',
                      width: 14,
                      height: 14,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      '상점',
                      style: TextStyle(fontSize: 14.0, color: Colors.black),
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

      // 여기서 isVerified 전달해야 버튼이 바뀜
      bottomNavigationBar: GroupChallengeBottomButtons(
        onPressedVerify: _onPressVerify,
        isLoading: isLoading,
        isVerified: isVerified,
      ),
    );
  }
}
