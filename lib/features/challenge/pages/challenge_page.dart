import 'package:flutter/material.dart';
import '../../../common/widgets/main_appbar.dart';
import '../widgets/challenge_summary_card.dart';
import '../data/dummy_challenge_summary.dart';
import '../widgets/challenge_floating_button.dart';
import '../modal/ongoing_challenge_detail_modal.dart';
import '../modal/recommended_challenge_more_modal.dart';
import '../widgets/challenge_floating_button.dart'; 
import 'personal_challenge_page.dart';
import 'group_challenge_page.dart';
import '../widgets/challenge_scope_toggle.dart';
import '../../shop/pages/shop_page.dart'; 
import '../create/personal/pages/personal_challenge_type_page.dart';

class ChallengePage extends StatefulWidget {
  const ChallengePage({super.key});

  @override
  State<ChallengePage> createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengePage> {
  bool isPersonalSelected = true;

  @override
  Widget build(BuildContext context) {
    final challenges = isPersonalSelected
        ? dummyPersonalChallenges
        : dummyGroupChallenges;

    final ongoingAll = challenges
      .where((c) => c.category == 'WEEKLY' || c.category == 'DAILY')
      .toList();

    final weeklyOne = challenges.where((c) => c.category == 'WEEKLY').take(1);
    final dailyOne = challenges.where((c) => c.category == 'DAILY').take(1);
    final ongoingShow = [...weeklyOne, ...dailyOne].toList();

    final recommendedShow = dummyRecommendedChallenges.take(2).toList();

    return Scaffold(
      appBar: MainAppbar(
        navIndex: 2,
        titleText: '바디 챌린지',
        imageUrl: 'assets/challenge/shop.svg',
        buttonText: '상점',
        onButtonPressed: () {},
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ChallengeScopeToggle(
              isPersonalSelected: isPersonalSelected,
              onChanged: (value) {
                setState(() {
                  isPersonalSelected = value;
                });
              },
            ),

            const SizedBox(height: 30),

            // 진행 중인 챌린지 (개인일 때만)
            if (isPersonalSelected) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 17),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '진행 중인 챌린지',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        height: 1.0,
                        color: Colors.black,
                      ),
                    ),

                    /// 더보기 버튼
                    GestureDetector(
                      onTap: () {
                        OngoingChallengeMoreModal.show(
                          context,
                          items: ongoingAll.map((challenge) {
                            return OngoingChallengeModalItem(
                              challenge: challenge,
                              onTap: () {
                                Navigator.pop(context); 
                                // TODO: 상세 모달 or 상세 페이지 이동
                              },
                            );
                          }).toList(),
                        );
                      },
                      child: const Text(
                        '더보기',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFFA8A8A8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: ongoingShow
                      .map(
                        (challenge) =>
                            OngoingChallengeCard(challenge: challenge),
                      )
                      .toList(),
                ),
              ),

              const SizedBox(height: 24),
            ],

            // 추천 챌린지
            if (isPersonalSelected) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 17),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '추천 챌린지',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        height: 1.0,
                        color: Colors.black,
                      ),
                    ),

                    /// 헤더의 더보기만 눌렀을 때 모달
                    GestureDetector(
                      onTap: () {
                        RecommendedChallengeMoreModal.show(
                          context,
                          items: dummyRecommendedChallenges.map((c) {
                            return RecommendedChallengeModalItem(
                              challenge: c,
                              onTap: () {
                                Navigator.pop(context);
                                // TODO: 추천 챌린지 상세 모달/상세페이지 이동
                              },
                            );
                          }).toList(),
                        );
                      },
                      child: const Text(
                        '더보기',
                        style: TextStyle(fontSize: 13, color: Color(0xFFA8A8A8)),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              /// 추천 카드 2개만 보여주기
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: recommendedShow
                      .map((c) => RecommendedChallengeCard(challenge: c))
                      .toList(),
                ),
              ),

              const SizedBox(height: 24),
            ],

            Container(
              width: double.infinity,
              height: 10,
              color: const Color(0xFFF8F8F8),
            ),
            const SizedBox(height: 16),

            // 완료한 챌린지 (개인일 때만)
            if (isPersonalSelected) ...[
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 17),
                child: Text(
                  '완료한 챌린지',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    height: 1.0,
                    color: Colors.black,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: dummyCompletedChallenges
                      .map(
                        (challenge) =>
                            CompletedChallengeCard(challenge: challenge),
                      )
                      .toList(),
                ),
              ),

              const SizedBox(height: 16),

              ChallengeSummaryCard(summary: dummyChallengeSummary),

              const SizedBox(height: 24),
            ],
          ],
        ),
      ),
      floatingActionButton: isPersonalSelected
          ? ChallengeFloatingButton(
              onPressed: () {
                // TODO: 새 챌린지 생성 페이지 이동
                // Navigator.pushNamed(context, '/challenge/create');
              },
            )
          : null,

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        onButtonPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const ShopPage(),
            ),
          );
        },
      ),
      body: Column(
        children: [
          ChallengeScopeToggle(
            isPersonalSelected: isPersonalSelected,
            onChanged: (value) {
              setState(() {
                isPersonalSelected = value;
              });
            },
          ),
          Expanded(
            child: isPersonalSelected
                ? const PersonalChallengePage()
                : const GroupChallengePage(),
          ),
        ],
      ),
      floatingActionButton: Visibility(
      visible: isPersonalSelected,
      maintainState: true,
      maintainAnimation: true,
      maintainSize: true,
      child: ChallengeFloatingButton(
        onPressed: () {
          Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(
              builder: (_) => const PersonalChallengeTypePage(),
            ),
          );
        },
      ),
    ),
    );
  }
}
