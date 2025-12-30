import 'package:flutter/material.dart';
import '../widgets/friends/friends_request_section.dart';
import '../widgets/friends/my_friends_section.dart';

class BuddyFriendPage extends StatelessWidget {
  const BuddyFriendPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        MyFriendsSection(),
        SizedBox(height: 10.0),
        FriendRequestSection(),
      ],
    );
  }
}
