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

  @override
  Widget build(BuildContext context) {
    if (isLoading || _buddyResponse == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: <Widget>[
        TextButton(onPressed: () {}, child: Text('테스트 확인')),
        TextButton(onPressed: () {}, child: Text('테스트 확인')),
        MyFriendsSection(
          myFriends: _buddyResponse!,
          onMyFriendDetail: _getBuddyDetail,
        ),
        SizedBox(height: 10.0),
        FriendRequestSection(),
      ],
    );
  }
}
