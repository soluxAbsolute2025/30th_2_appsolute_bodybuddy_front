import 'dart:async';
import 'package:flutter/material.dart';
import '../data/dummy_group_challenges.dart';
import '../data/dummy_completed_group_challenge.dart';
import '../widgets/participating_group_challenge_card.dart';
import '../widgets/new_group_challenge_card.dart';
import '../data/dummy_recruiting_group_challenges.dart';
import '../widgets/create_group_challenge_banner.dart';
import '../widgets/completed_group_challenge_card.dart';
import '../pages/group_challenge_detail_page.dart';
import '../data/dummy_group_challenge_detail.dart';
import '../modal/participating_challenge_more_modal.dart';

class GroupChallengePage extends StatefulWidget {
  const GroupChallengePage({super.key});

  @override
  State<GroupChallengePage> createState() => _GroupChallengePageState();
}

class _GroupChallengePageState extends State<GroupChallengePage> {
  final ScrollController _recruitingController = ScrollController();
  final ScrollController _completedController = ScrollController();

  Timer? _recruitingTimer;
  Timer? _completedTimer;

  @override
  void initState() {
    super.initState();

    // 새로운 그룹 챌린지 자동 스크롤
    _recruitingTimer = Timer.periodic(const Duration(milliseconds: 30), (_) {
      if (!_recruitingController.hasClients) return;

      final maxScroll = _recruitingController.position.maxScrollExtent;
      final current = _recruitingController.offset;

      if (current >= maxScroll) {
        _recruitingController.jumpTo(0);
      } else {
        _recruitingController.jumpTo(current + 0.4);
      }
    });

    // 완료한 그룹 챌린지 자동 스크롤
    _completedTimer = Timer.periodic(const Duration(milliseconds: 30), (_) {
      if (!_completedController.hasClients) return;

      final maxScroll = _completedController.position.maxScrollExtent;
      final current = _completedController.offset;

      if (current >= maxScroll) {
        _completedController.jumpTo(0);
      } else {
        _completedController.jumpTo(current + 0.4);
      }
    });
  }

  @override
  void dispose() {
    _recruitingTimer?.cancel();
    _completedTimer?.cancel();
    _recruitingController.dispose();
    _completedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final participatingChallenges = dummyGroupChallenges
        .where((c) => !c.isRecruiting)
        .toList();

    final recruitingChallenges = dummyRecruitingGroupChallenges;

    final completedChallenges = dummyCompletedGroupChallenges;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),

          /// 참여 중인 챌린지
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 17),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '참여 중인 챌린지',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    ParticipatingChallengeMoreModal.show(
                      context,
                      items: participatingChallenges.map((c) {
                        return ParticipatingChallengeModalItem(
                          title: c.title,
                          rank: c.rank,
                          remainDays: c.remainDays,
                          members: c.members,
                          imageUrl: c.imageUrl,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => GroupChallengeDetailPage(
                                  challenge: dummyGroupChallengeDetail,
                                ),
                              ),
                            );
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

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: participatingChallenges.isEmpty
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: Text(
                        '참여 중인 그룹 챌린지가 없어요',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF999999),
                        ),
                      ),
                    ),
                  )
                : Column(
                    children: participatingChallenges
                        .take(1)
                        .map(
                          (challenge) => ParticipatingGroupChallengeCard(
                            title: challenge.title,
                            rank: challenge.rank,
                            members: challenge.members,
                            remainDays: challenge.remainDays,
                            imageUrl: challenge.imageUrl,

                            onImageTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => GroupChallengeDetailPage(
                                    challenge: dummyGroupChallengeDetail,
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                        .toList(),
                  ),
          ),

          const SizedBox(height: 32),

          Container(
            width: double.infinity,
            height: 10,
            color: const Color(0xFFF8F8F8),
          ),

          const SizedBox(height: 30),

          /// 새로운 그룹 챌린지
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 17),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  '새로운 그룹 챌린지',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          /// 자동으로 천천히 이동하는 가로 리스트
          SizedBox(
            height: 180,
            child: ListView.separated(
              controller: _recruitingController,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 16, right: 16),
              itemCount: recruitingChallenges.length,
              separatorBuilder: (_, __) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                final challenge = recruitingChallenges[index];
                return NewGroupChallengeCard(challenge: challenge);
              },
            ),
          ),

          const SizedBox(height: 16),
          const CreateGroupChallengeBanner(),
          const SizedBox(height: 40),

          Container(
            width: double.infinity,
            height: 20,
            color: const Color(0xFFF8F8F8),
          ),

          const SizedBox(height: 24),

          /// 완료한 챌린지
          Padding( 
            padding: const EdgeInsets.symmetric(horizontal: 17),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, 
              children: const [ 
                Text( 
                  '완료한 챌린지', 
                  style: TextStyle( 
                    fontFamily: 'Pretendard', 
                    fontSize: 16, 
                    fontWeight: FontWeight.w600, 
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: completedChallenges.isEmpty
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: Text(
                        '완료한 그룹 챌린지가 없어요',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF999999),
                        ),
                      ),
                    ),
                  )
                : SizedBox(
                    height: 180, // 카드 높이에 맞게 150~180 사이로 조절
                    child: ListView.separated(
                      controller: _completedController,
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.zero,
                      itemCount: completedChallenges.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 16),
                      itemBuilder: (context, index) {
                        return CompletedGroupChallengeCard(
                          challenge: completedChallenges[index],
                        );
                      },
                    ),
                  ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
