import 'package:bodybuddy_frontend/features/buddyzone/models/friends/buddy_list_model.dart';
import 'package:flutter/material.dart';
import '../friends/friendrequestBlock.dart';

class FriendRequestSection extends StatelessWidget {
  final BuddyResponse myFriends;
  // 🔥 [수정] 함수 타입 명확하게 정의 (int를 받아서 void 반환)
  final Function(int requestId) onAccept;
  final Function(int requestId) onReject;

  const FriendRequestSection({
    super.key,
    required this.myFriends,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    // StatefulWidget이 아니므로 context에서 테마나 사이즈를 바로 가져옵니다.
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 16.0),
      constraints: const BoxConstraints(minHeight: 200.0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      '친구 요청',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 5.0),
                    Text(
                      myFriends.requests.length.toString(),
                      style: const TextStyle(
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

          // 요청이 없을 때 텍스트 표시
          if (myFriends.requests.isEmpty) _nullCommentText(),

          // 요청 목록 표시
          ...myFriends.requests.map(
            (e) => Column(
              children: [
                FriendrequestBlock(
                  buddyRequest: e,
                  onAccept: () => onAccept(e.requestId),
                  onReject: () => onReject(e.requestId),
                ),
                const SizedBox(height: 8.0),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _nullCommentText() {
    return Container(
      padding: const EdgeInsets.only(bottom: 16.0),
      height: 127.0,
      alignment: Alignment.center,
      child: const Text(
        '친구 요청이 들어오지 않았습니다\n',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color(0xFFA6A6A6),
          fontSize: 14,
          fontFamily: 'Pretendard Variable',
          fontWeight: FontWeight.w400,
          height: 1.50,
        ),
      ),
    );
  }
}
