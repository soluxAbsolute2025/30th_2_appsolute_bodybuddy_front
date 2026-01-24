// features/home/widgets/home_content.dart
import 'package:bodybuddy_frontend/features/buddyzone/api/buddyzone_friends_api.dart';
import 'package:bodybuddy_frontend/features/buddyzone/models/friends/buddy_list_model.dart';
import 'package:flutter/material.dart';
import '../friends/friendrequestBlock.dart';

class FriendRequestSection extends StatefulWidget {
  BuddyResponse myFriends;
  FriendRequestSection({super.key, required this.myFriends});

  @override
  State<FriendRequestSection> createState() => _FriendRequestSectionState();
}

class _FriendRequestSectionState extends State<FriendRequestSection> {
  BuddyResponse? _buddyResponse;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _acceptBuddyRequest({required int requestId}) async {
    try {
      await BuddysApi().acceptBuddyRequest(requestId: requestId);
      widget.myFriends.requests.removeWhere(
        (request) => request.requestId == requestId,
      );
    } catch (e) {
      print("삭제 실패 (서버 에러): $e");
    }
  }

  void _rejectBuddyRequest({required int requestId}) async {
    try {
      await BuddysApi().deleteBuddyRequest(requestId: requestId);

      setState(() {
        widget.myFriends.requests.removeWhere(
          (request) => request.requestId == requestId,
        );
      });
    } catch (e) {
      print("삭제 실패 (서버 에러): $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
        bottom: 25.0,
        right: 16.0,
        left: 16.0,
        top: 25.0,
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      '친구 요청',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 5.0),
                    Text(
                      widget.myFriends.requests.length.toString(),
                      style: TextStyle(
                        color: Color(0xFF1AEDB1),
                        fontSize: 17.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ...widget.myFriends.requests.map(
            (e) => Column(
              children: [
                FriendrequestBlock(
                  buddyRequest: e,
                  onAccept: _acceptBuddyRequest,
                  onReject: _rejectBuddyRequest,
                ),
                SizedBox(height: 8.0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
