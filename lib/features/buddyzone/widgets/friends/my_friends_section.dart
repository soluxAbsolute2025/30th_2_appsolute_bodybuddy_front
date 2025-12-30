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
                Container(
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
                      SizedBox(width: 5.0),
                      Text(
                        '3',
                        style: TextStyle(
                          color: Color(0xFFA8A8A8),
                          fontSize: 17.0,
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
          SizedBox(height: 8.0),
          MyfriendBlock(),
          SizedBox(height: 8.0),
          MyfriendBlock(),
        ],
      ),
    );
  }
}
