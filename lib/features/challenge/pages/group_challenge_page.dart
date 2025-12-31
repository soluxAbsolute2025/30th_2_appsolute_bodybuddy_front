import 'dart:async';
import 'package:flutter/material.dart';
import '../data/dummy_group_challenges.dart';
import '../widgets/participating_group_challenge_card.dart';
import '../widgets/new_group_challenge_card.dart';
import '../data/dummy_recruiting_group_challenges.dart';
import '../widgets/create_group_challenge_banner.dart';

class GroupChallengePage extends StatefulWidget {
  const GroupChallengePage({super.key});

  @override
  State<GroupChallengePage> createState() => _GroupChallengePageState();
}

class _GroupChallengePageState extends State<GroupChallengePage> {
  final ScrollController _scrollController = ScrollController();
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(milliseconds: 30), (_) {
      if (!_scrollController.hasClients) return;

      final maxScroll = _scrollController.position.maxScrollExtent;
      final current = _scrollController.offset;

      if (current >= maxScroll) {
        _scrollController.jumpTo(0);
      } else {
        _scrollController.jumpTo(current + 0.4);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final participatingChallenges = dummyGroupChallenges
        .where((c) => !c.isRecruiting)
        .toList();

    final recruitingChallenges = dummyRecruitingGroupChallenges;

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
              children: const [
                Text(
                  '참여 중인 챌린지',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '더보기',
                  style: TextStyle(fontSize: 13, color: Color(0xFF999999)),
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
                        .map(
                          (challenge) => ParticipatingGroupChallengeCard(
                            title: challenge.title,
                            rank: challenge.rank,
                            members: challenge.members,
                            remainDays: challenge.remainDays,
                            imageUrl: challenge.imageUrl,
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
                Text(
                  '더보기',
                  style: TextStyle(fontSize: 13, color: Color(0xFF999999)),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          /// 자동으로 천천히 이동하는 가로 리스트
          SizedBox(
            height: 180,
            child: ListView.separated(
              controller: _scrollController,
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

          const SizedBox(height: 40),
          const CreateGroupChallengeBanner(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
