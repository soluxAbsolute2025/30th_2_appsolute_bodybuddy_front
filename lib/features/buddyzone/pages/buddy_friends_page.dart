import 'package:bodybuddy_frontend/features/buddyzone/api/buddyzone_friends_api.dart';
import 'package:bodybuddy_frontend/features/buddyzone/models/friends/buddy_detail_model.dart';
import 'package:bodybuddy_frontend/features/buddyzone/models/friends/buddy_list_model.dart';
import 'package:flutter/material.dart';
import '../widgets/friends/friends_request_section.dart';
import '../widgets/friends/my_friends_section.dart';

class BuddyFriendPage extends StatefulWidget {
  const BuddyFriendPage({super.key});

  @override
  State<BuddyFriendPage> createState() => _BuddyFriendPageState();
}

class _BuddyFriendPageState extends State<BuddyFriendPage> {
  BuddyResponse? _buddyResponse;
  BuddyDetail? _buddyDetail;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getBuddyList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _getBuddyList() async {
    final response = await BuddysApi().getBuddyList();

    _buddyResponse = response;
    setState(() {
      isLoading = false;
    });
  }

  void _getBuddyDetail({required int userId}) async {
    final response = await BuddysApi().getBuddyDetail(userId: userId);

    _buddyDetail = response;
    setState(() {});
  }

  void _handleAcceptBuddy(int requestId) async {
    try {
      await BuddysApi().acceptBuddyRequest(requestId: requestId);

      setState(() {
        // 1. 요청 목록 속, 해당하는 요청 찾기
        final targetRequest = _buddyResponse!.requests.firstWhere(
          (req) => req.requestId == requestId,
        );

        // 2. 요청 목록에서 제거
        _buddyResponse!.requests.removeWhere(
          (req) => req.requestId == requestId,
        );

        // 3. 친구 목록에 추가
        _buddyResponse!.myBuddies.add(
          Buddy(
            userId: targetRequest.userId,
            // 요청한 사람의 ID
            level: targetRequest.level,
            lastActiveTime: targetRequest.lastActiveTime,
            nickname: targetRequest.nickname,
            profileImageUrl: targetRequest.profileImageUrl,
            isPokedToday: false,
          ),
        );
      });
    } catch (e) {
      print("수락 실패: $e");
      // 에러 시 다시 되돌리는 로직이 있으면 더 좋음
    }
  }

  // 🔥 [핵심 2] 거절 로직: API 호출 후 목록에서만 제거
  void _handleRejectBuddy(int requestId) async {
    try {
      await BuddysApi().deleteBuddyRequest(requestId: requestId);

      if (mounted) {
        setState(() {
          _buddyResponse!.requests.removeWhere(
            (req) => req.requestId == requestId,
          );
        });
      }
    } catch (e) {
      print("거절 실패: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading || _buddyResponse == null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(30.0),
          child: CircularProgressIndicator(color: Color(0xFF1AEDB0)),
        ),
      );
    }

    return Column(
      children: <Widget>[
        MyFriendsSection(
          myFriends: _buddyResponse!,
          onMyFriendDetail: _getBuddyDetail,
        ),
        SizedBox(height: 10.0),
        FriendRequestSection(
          myFriends: _buddyResponse!,
          onAccept: _handleAcceptBuddy,
          onReject: _handleRejectBuddy,
        ),
      ],
    );
  }
}
