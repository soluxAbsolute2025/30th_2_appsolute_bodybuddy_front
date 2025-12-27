// features/home/widgets/home_content.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../friends/myfriendBlock.dart';

class MyFriendsSection extends StatelessWidget {
  const MyFriendsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 16.0),
      child: Column(
        children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: 16.0),
                  child: Row(
                    children: [
                      Text(
                        '나의 친구',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '3',
                        style: TextStyle(
                          color: Colors.white30,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(right: 16.0),
                  child: SvgPicture.asset(
                    'assets/images/common/friend_add.svg',
                    width: 22.0,
                    height: 15.0,
                  ),
                ),
              ],
            ),
          ),
          MyfriendBlock(),
          MyfriendBlock(),
        ],
      ),
    );
  }
}
