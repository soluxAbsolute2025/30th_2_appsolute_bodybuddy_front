// features/home/widgets/home_content.dart

import 'package:bodybuddy_frontend/common/widgets/toast_widget.dart';
import 'package:bodybuddy_frontend/features/buddyzone/api/buddyzone_friends_api.dart';
import 'package:bodybuddy_frontend/features/buddyzone/models/friends/buddy_detail_model.dart';
import 'package:bodybuddy_frontend/features/buddyzone/models/friends/buddy_list_model.dart';
import 'package:bodybuddy_frontend/features/buddyzone/widgets/friends/friends_buddy_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyfriendBlock extends StatefulWidget {
  Buddy? buddy;
  MyfriendBlock({super.key, required this.buddy});

  @override
  State<MyfriendBlock> createState() => _MyfriendBlockState();
}

class _MyfriendBlockState extends State<MyfriendBlock> {
  bool isPocked = false;

  @override
  void initState() {
    super.initState();
    isPocked = widget.buddy!.isPokedToday;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _postPock({required int userId}) async {
    try {
      await PockApi().postPock(userId: userId);
      print("포크 성공 : $userId");

      if (mounted) {
        setState(() {
          isPocked = true;
        });
      }
    } catch (e) {
      print("포크 실패: $e");
    }
  }

  Future<Buddy> _getPockList() async {
    Buddy? buddy;

    final response = await PockApi().getPockList();
    buddy = response;

    return buddy;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 6.0),
      child: Row(
        children: [
          SizedBox(
            width: 50.0,
            height: 50.0,
            child: ClipOval(
              child: Image(image: AssetImage('assets/buddyzone/myprofile.png')),
            ),
          ),
          SizedBox(width: 16.0),
          Expanded(
            child: GestureDetector(
              onTap: () {
                print("친구 클릭 : ${widget.buddy!.userId}");
                showDialog(
                  context: context,
                  builder: (BuildContext context) => BuddyProfileDialog(
                    buddyId: widget.buddy!.userId,
                    isPocked: isPocked,
                    onPocked: _postPock,
                  ),
                );
              },
              child: Column(
                children: <Widget>[
                  Row(
                    children: [
                      Text(
                        widget.buddy!.nickname,
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 10.0),
                      Container(
                        // height: 17.0,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 1.0,
                            horizontal: 10.0,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFFE9FFF9),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Text(
                            'Lv. ${widget.buddy!.level}',
                            style: TextStyle(
                              color: Color(0xFF1AEDB1),
                              fontSize: 11.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.0),
                  Row(
                    children: [
                      Text(
                        textAlign: TextAlign.left,
                        '${widget.buddy!.lastActiveTime} 활동',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 5.0),

            child: TextButton(
              onPressed: isPocked
                  ? null
                  : () {
                      print("손 흔들기 클릭!");
                      _postPock(userId: widget.buddy!.userId);
                      CustomToast.show(
                        context,
                        "${widget.buddy!.nickname}님을 콕 찔렀습니다!",
                      );
                      setState(() {
                        isPocked = !isPocked;
                      });
                    },
              style: TextButton.styleFrom(
                foregroundColor: Color(0x1188D3BD),
                padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
                minimumSize: Size.zero,
                tapTargetSize:
                    MaterialTapTargetSize.shrinkWrap, // 터치 영역을 내용물에 맞춤
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),

              child: Center(
                child: isPocked
                    ? SvgPicture.asset(
                        'assets/buddyzone/friend_profile/hand_true.svg',
                        width: 16.0,
                        height: 21.0,
                      )
                    : SvgPicture.asset(
                        'assets/buddyzone/friend_profile/hand_false.svg',
                        width: 16.0,
                        height: 21.0,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
