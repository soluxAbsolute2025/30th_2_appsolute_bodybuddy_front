import 'dart:async';
import 'package:flutter/material.dart';

import '../data/dummy_completed_group_challenge.dart';
import '../data/dummy_recruiting_group_challenges.dart';
import '../widgets/participating_group_challenge_card.dart';
import '../widgets/new_group_challenge_card.dart';
import '../widgets/create_group_challenge_banner.dart';
import '../widgets/completed_group_challenge_card.dart';
import '../pages/group_challenge_detail_page.dart';
import '../data/dummy_group_challenge_detail.dart';
import '../modal/participating_challenge_more_modal.dart';

import '../api/ongoing_group_challenge_api.dart';
import '../models/ongoing_group_challenge.dart';

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

  final api = OngoingGroupChallengeApi();

  List<OngoingGroupChallenge> participatingChallenges = [];
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();

    _loadParticipatingChallenges();

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

  Future<void> _loadParticipatingChallenges() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      final result = await api.fetchOngoingGroupChallenges();
      if (!mounted) return;
      setState(() {
        participatingChallenges = result;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
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
    // ✅ 참여중은 API로 가져온 state 변수 사용
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
                    // ✅ 모달은 아직 더미용(ParticipatingChallengeModalItem)이면 타입이 안 맞을 수 있음
                    // 지금은 참여중 API로 바꿨으니, 모달도 같이 바꾸는 게 정석.
                    // 일단 "최소 수정"으로: 참여중이 있을 때만 열고, 내용은 API 기반으로 채움(필드 매핑)
                    ParticipatingChallengeMoreModal.show(
                      context,
                      items: participatingChallenges.map((c) {
                        return ParticipatingChallengeModalItem(
                          title: c.title,
                          rank: c.myRank,
                          remainDays: c.remainingDays,
                          // members는 모달이 GroupMember(List<GroupMember>)를 받는 구조라면
                          // ParticipatingGroupChallengeCard처럼 매핑이 필요.
                          // 여기서는 기존 모달 구조 유지 위해 "비워두는" 대신,
                          // 모달의 item 모델을 API용으로 바꾸는 걸 추천.
                          members: const [], // TODO: 모달 모델 리팩토링 권장
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
            child: _buildParticipatingSection(),
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
                    height: 180,
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

  Widget _buildParticipatingSection() {
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (hasError) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Column(
            children: [
              const Text(
                '참여 중인 그룹 챌린지를 불러오지 못했어요',
                style: TextStyle(fontSize: 14, color: Color(0xFF999999)),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: _loadParticipatingChallenges,
                child: const Text(
                  '다시 시도',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF3B82F6),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (participatingChallenges.isEmpty) {
      return const Padding(
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
      );
    }

    return Column(
      children: participatingChallenges
          .take(1)
          .map(
            (challenge) => ParticipatingGroupChallengeCard(
              challenge: challenge,
              onImageTap: () {
                // TODO: 그룹 챌린지 상세 페이지 이동
              },
            ),
          )
          .toList(),
    );
  }
}
