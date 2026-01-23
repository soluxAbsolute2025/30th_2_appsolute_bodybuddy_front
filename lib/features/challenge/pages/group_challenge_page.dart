import 'dart:async';
import 'package:flutter/material.dart';

import '../data/dummy_completed_group_challenge.dart';
import '../widgets/participating_group_challenge_card.dart';
import '../widgets/new_group_challenge_card.dart';
import '../widgets/create_group_challenge_banner.dart';
import '../widgets/completed_group_challenge_card.dart';
import '../pages/group_challenge_detail_page.dart';
import '../modal/participating_challenge_more_modal.dart';
import '../models/top_participant_mapper.dart';
import '../api/ongoing_group_challenge_api.dart';
import '../models/ongoing_group_challenge.dart';

import '../api/group_challenge_list_api.dart';
import '../models/group_challenge_list_item.dart';

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

  // 참여중(ongoing) API
  final ongoingApi = OngoingGroupChallengeApi();
  List<OngoingGroupChallenge> participatingChallenges = [];
  bool participatingLoading = true;
  bool participatingError = false;

  // 새로운(Recruiting) API: /api/challenges/group 에서 RECRUITING만 추림
  final groupListApi = GroupChallengeListApi();
  List<GroupChallengeListItem> recruitingChallenges = [];
  bool recruitingLoading = true;
  bool recruitingError = false;

  bool _isRecruitingUserScrolling = false;

  @override
  void initState() {
    super.initState();

    _loadParticipatingChallenges();
    _loadRecruitingChallenges();

    // 새로운 그룹 챌린지 자동 스크롤
    _recruitingTimer = Timer.periodic(const Duration(milliseconds: 30), (_) {
      if (!_recruitingController.hasClients) return;
      if (_isRecruitingUserScrolling) return;

      final maxScroll = _recruitingController.position.maxScrollExtent;
      final current = _recruitingController.offset;

      if (current >= maxScroll) {
        _recruitingController.jumpTo(0);
      } else {
        _recruitingController.jumpTo(current + 0.4);
      }
    });

    // 완료한 그룹 챌린지 자동 스크롤(더미)
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
      participatingLoading = true;
      participatingError = false;
    });

    try {
      final result = await ongoingApi.fetchOngoingGroupChallenges();
      if (!mounted) return;
      setState(() {
        participatingChallenges = result;
        participatingLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        participatingError = true;
        participatingLoading = false;
      });
    }
  }

  Future<void> _loadRecruitingChallenges() async {
    setState(() {
      recruitingLoading = true;
      recruitingError = false;
    });

    try {
      final all = await groupListApi.fetchGroupChallenges();

      // ✅ RECRUITING만 "새로운 그룹 챌린지" 섹션으로 사용
      final recruiting = all.where((c) => c.isRecruiting).toList();

      if (!mounted) return;
      setState(() {
        recruitingChallenges = recruiting;
        recruitingLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        recruitingError = true;
        recruitingLoading = false;
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
                          rank: c.myRank,
                          remainDays: c.remainingDays,
                          members: c.topParticipants
                              .map((p) => p.toGroupMember())
                              .toList(),
                          imageUrl: c.imageUrl,
                          onTap: () {
                            Navigator.of(context, rootNavigator: true).pop();
                            Navigator.of(context, rootNavigator: true).push(
                              MaterialPageRoute(
                                builder: (_) => GroupChallengeDetailPage(
                                  challengeId: c.challengeId,
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
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 17),
            child: Text(
              '새로운 그룹 챌린지',
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(height: 16),

          /// 자동으로 천천히 이동하는 가로 리스트 (RECRUITING)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildRecruitingSection(),
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

          /// 완료한 챌린지 (더미)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 17),
            child: Text(
              '완료한 챌린지',
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
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
    if (participatingLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (participatingError) {
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
            style: TextStyle(fontSize: 14, color: Color(0xFF999999)),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => GroupChallengeDetailPage(
                      challengeId: challenge.challengeId, // ✅ 여기!
                    ),
                  ),
                );
              },
            ),
          )
          .toList(),
    );
  }

  Widget _buildRecruitingSection() {
    if (recruitingLoading) {
      return const SizedBox(
        height: 180,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (recruitingError) {
      return SizedBox(
        height: 180,
        child: Center(
          child: GestureDetector(
            onTap: _loadRecruitingChallenges,
            child: const Text(
              '새로운 그룹 챌린지를 불러오지 못했어요\n(다시 시도)',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Color(0xFF3B82F6)),
            ),
          ),
        ),
      );
    }

    if (recruitingChallenges.isEmpty) {
      return const SizedBox(
        height: 180,
        child: Center(
          child: Text(
            '새로운 그룹 챌린지가 없어요',
            style: TextStyle(fontSize: 14, color: Color(0xFF999999)),
          ),
        ),
      );
    }

    return SizedBox(
      height: 180,
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollStartNotification) {
            _isRecruitingUserScrolling = true;
          } else if (notification is ScrollEndNotification) {
            _isRecruitingUserScrolling = false;
          }
          return false;
        },
        child: ListView.separated(
          controller: _recruitingController,
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: recruitingChallenges.length,
          separatorBuilder: (_, __) => const SizedBox(width: 16),
          itemBuilder: (context, index) {
            final challenge = recruitingChallenges[index];
            return NewGroupChallengeCard(challenge: challenge);
          },
        ),
      ),
    );
  }
}
