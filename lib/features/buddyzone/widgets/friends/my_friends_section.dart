// features/home/widgets/home_content.dart
import 'package:bodybuddy_frontend/common/widgets/toast_widget.dart';
import 'package:bodybuddy_frontend/features/buddyzone/api/buddyzone_friends_api.dart';
import 'package:bodybuddy_frontend/features/buddyzone/models/friends/buddy_detail_model.dart';
import 'package:bodybuddy_frontend/features/buddyzone/models/friends/buddy_list_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../friends/myfriendBlock.dart';

class MyFriendsSection extends StatefulWidget {
  final BuddyResponse myFriends;
  final Function({required int userId}) onMyFriendDetail;

  const MyFriendsSection({
    super.key,
    required this.myFriends,
    required this.onMyFriendDetail,
  });

  @override
  State<MyFriendsSection> createState() => _MyFriendsSectionState();
}

class _MyFriendsSectionState extends State<MyFriendsSection> {
  final TextEditingController _nicknameController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // 2. [수정] 메모리 누수 방지를 위해 컨트롤러 해제
    _nicknameController.dispose();
    super.dispose();
  }

  // 3. [수정] 인자를 int가 아닌 String(nickname)으로 변경
  Future<void> _buddyRequest({required String nickname}) async {
    BuddyDetail? buddyDetail;

    try {
      final response = await BuddysApi().getBuddySearch(
        userName: nickname.toString(),
      );
      print("친구 요청 성공: $nickname : ${response.toJson()}");

      buddyDetail = response;
    } catch (e) {
      print("친구 요청 실패: $e");

      buddyDetail = null;
    }

    if (buddyDetail == null) return;

    try {
      await BuddysApi().postBuddyRequest(userId: buddyDetail.userId);
      print("친구 요청 성공: ${buddyDetail.userId}");
    } catch (e) {
      print("친구 요청 실패: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
        bottom: 17.0,
        right: 16.0,
        left: 16.0,
        top: 20.0,
      ),
      constraints: BoxConstraints(minHeight: 200.0),
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
                      '나의 친구',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 5.0),
                    Text(
                      widget.myFriends.myBuddies.length.toString(),
                      style: TextStyle(
                        color: Color(0xFFA8A8A8),
                        fontSize: 17.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: Colors.white,
                  ),
                  child: TextButton(
                    onPressed: () {
                      print("친구 추가 클릭!");
                      _showdialog(context);
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Color(0x1188D3BD),
                      padding: EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 8.0,
                      ),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      minimumSize: Size.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/images/common/friend_add.svg',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (widget.myFriends.myBuddies.length == 0) ...[_nullCommentText()],
          ...widget.myFriends.myBuddies
              .map(
                (e) => Column(
                  children: [
                    MyfriendBlock(buddy: e),
                    SizedBox(height: 8.0),
                  ],
                ),
              )
              .toList(),
        ],
      ),
    );
  }

  Future<dynamic> _showdialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16.0),
        contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
        buttonPadding: EdgeInsets.zero,
        title: Column(
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  'assets/images/common/friend_add.svg',
                  width: 22.3,
                  height: 15.0,
                ),
                SizedBox(width: 10.0),
                Text(
                  '버디 추가',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Pretendard Variable',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.0),
          ],
        ),
        content: Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.symmetric(horizontal: 16.0),
          child: _TextFromFieldWidget(
            hintText: '친구 아이디 입력',
            controller: _nicknameController,
          ),
        ),
        actions: [
          _dialogButtonWidget(
            text: '취소',
            context: context,
            onPressed: () => Navigator.of(context).pop(),
          ),
          SizedBox(width: 8.0),
          _dialogButtonWidget(
            text: '추가',
            context: context,
            onPressed: () async {
              final nickname = _nicknameController.text;
              await _buddyRequest(nickname: nickname);
              CustomToast.show(
                context,
                "${nickname}님에게 친구 신청을 보냈습니다!",
                subMessage: "친구 추가",
              );
              _nicknameController.clear();

              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
          ),
        ],
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      barrierDismissible: true,
      barrierColor: Color(0x963A3A3A),
    );
  }

  Widget _dialogButtonWidget({
    required String text,
    required BuildContext context,
    Function()? onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: Colors.white,
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: Color(0x1188D3BD),
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          minimumSize: Size.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            color: const Color(0xFF17D8A1),
            fontSize: 14,
            fontFamily: 'Pretendard Variable',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _TextFromFieldWidget({
    required String hintText,
    required TextEditingController controller,
  }) {
    return Expanded(
      child: TextFormField(
        controller: controller,
        style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Color(0xFFA6A6A6),
            fontSize: 16.0,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w500,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 16,
          ),
          fillColor: Colors.white,
          filled: true,
          // 둥근 모서리를 주고 싶을 때 사용
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Color(0xFFD8D8D8)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Color(0xFF1AEDB0), width: 1),
          ),
        ),
      ),
    );
  }

  Widget _nullCommentText() {
    return Container(
      padding: EdgeInsets.only(bottom: 16.0),
      height: 127.0,
      alignment: Alignment.center,
      child: Text(
        '나의 버디가 존재하지 않아요\n'
        '어서 버디를 추가 해보세요!',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: const Color(0xFFA6A6A6),
          fontSize: 14,
          fontFamily: 'Pretendard Variable',
          fontWeight: FontWeight.w400,
          height: 1.50,
        ),
      ),
    );
  }
}
