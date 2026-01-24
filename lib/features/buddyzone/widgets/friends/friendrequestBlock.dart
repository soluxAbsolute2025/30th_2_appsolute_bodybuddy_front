// features/home/widgets/home_content.dart

import 'package:bodybuddy_frontend/features/buddyzone/models/friends/buddy_list_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FriendrequestBlock extends StatefulWidget {
  BuddyRequest buddyRequest;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  FriendrequestBlock({
    super.key,
    required this.buddyRequest,
    required this.onAccept,
    required this.onReject,
  });

  @override
  State<FriendrequestBlock> createState() => _FriendrequestState();
}

class _FriendrequestState extends State<FriendrequestBlock> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFFBFBFB),
        borderRadius: BorderRadius.circular(10.0),
      ),
      // margin: EdgeInsets.symmetric(horizontal: 16.0),
      padding: EdgeInsets.only(top: 8.0, bottom: 8.0, right: 6.0, left: 6.0),
      child: Row(
        children: [
          SizedBox(
            width: 50.0,
            height: 50.0,
            child: ClipOval(
              child: Image(
                fit: BoxFit.cover, // 이미지가 꽉 차도록 설정
                image:
                    (widget.buddyRequest.profileImageUrl != null &&
                        widget.buddyRequest.profileImageUrl!.isNotEmpty)
                    ? NetworkImage(
                        widget.buddyRequest.profileImageUrl.toString(),
                      )
                    : AssetImage('assets/buddyzone/myprofile.jpg'),
              ),
            ),
          ),
          SizedBox(width: 16.0),
          Expanded(
            child: Column(
              children: <Widget>[
                Row(
                  children: [
                    Text(
                      widget.buddyRequest.nickname.toString(),
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
                          'Lv. ${widget.buddyRequest.level.toString()}',
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
                    Container(
                      child: Text(
                        textAlign: TextAlign.left,
                        '${widget.buddyRequest.lastActiveTime} 활동',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(right: 5.0),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: Color(0xFF1AEDB1),
                  ),
                  child: TextButton(
                    onPressed: widget.onAccept,
                    style: TextButton.styleFrom(
                      foregroundColor: Color(0xFF669688),
                      padding: EdgeInsets.symmetric(
                        vertical: 6.0,
                        horizontal: 14.0,
                      ),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      minimumSize: Size.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '수락',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 5.0),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: Colors.white,
                  ),
                  child: TextButton(
                    onPressed: widget.onReject,
                    style: TextButton.styleFrom(
                      foregroundColor: Color(0xFFF65A33),
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
                      child: SvgPicture.asset('assets/images/common/x.svg'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
