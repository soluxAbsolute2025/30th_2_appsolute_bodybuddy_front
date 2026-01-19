import 'package:flutter/material.dart';
import '../data/dummy_ongoing_challenges.dart';
import 'ongoing_challenge_item.dart';

class OngoingChallengeSection extends StatefulWidget {
  const OngoingChallengeSection({super.key});

  @override
  State<OngoingChallengeSection> createState() =>
      _OngoingChallengeSectionState();
}

class _OngoingChallengeSectionState extends State<OngoingChallengeSection> {
  bool isPersonalSelected = true;

  @override
  Widget build(BuildContext context) {
    final challenges = isPersonalSelected
        ? dummyPersonalChallenges
        : dummyGroupChallenges;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFD8D8D8),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 타이틀
          const Text(
            '진행 중인 챌린지',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),

          const SizedBox(height: 20),

          /// 탭
          Row(
            children: [
              _TabButton(
                title: '개인 챌린지',
                isSelected: isPersonalSelected,
                onTap: () {
                  setState(() => isPersonalSelected = true);
                },
              ),
              _TabButton(
                title: '그룹 챌린지',
                isSelected: !isPersonalSelected,
                onTap: () {
                  setState(() => isPersonalSelected = false);
                },
              ),
            ],
          ),

          const SizedBox(height: 20),

          /// 리스트
          ...challenges.asMap().entries.map((entry) {
            final index = entry.key;
            final challenge = entry.value;
            final isLast = index == challenges.length - 1;

            return Padding(
              padding: EdgeInsets.only(
                bottom: isLast ? 0 : 12,
              ),
              child: OngoingChallengeItem(
                challenge: challenge,
                isGroup: !isPersonalSelected,
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 14,
                  fontWeight: isSelected
                      ? FontWeight.w700
                      : FontWeight.w500,
                  color: Colors.black, 
                ),
              ),
            ),

            /// 밑줄
             AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              height: 1,
              width: double.infinity,
              color: isSelected
                  ? Colors.black
                  : const Color(0xFFF5F5F5),
            ),
          ],
        ),
      ),
    );
  }
}
