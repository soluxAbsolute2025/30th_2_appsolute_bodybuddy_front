// features/home/widgets/home_content.dart
import 'package:flutter/material.dart';
import '../friends/friendrequestBlock.dart';

class FriendRequestSection extends StatelessWidget {
  const FriendRequestSection({super.key});

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
                        '친구 요청',
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
                          color: Color(0xFF1AEDB1),
                          fontSize: 17.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          FriendrequestBlock(),
          SizedBox(height: 8.0),
          FriendrequestBlock(),
          SizedBox(height: 8.0),
          FriendrequestBlock(),
        ],
      ),
    );
  }
}
