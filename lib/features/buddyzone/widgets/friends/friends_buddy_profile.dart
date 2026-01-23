import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:timeago/timeago.dart' as timeago;

class BuddyProfileDialog extends StatefulWidget {
  int? userId;
  BuddyProfileDialog({super.key, this.userId});

  @override
  State<BuddyProfileDialog> createState() => _BuddyProfileDialogState();
}

class _BuddyProfileDialogState extends State<BuddyProfileDialog> {
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20.0),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(22.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 5.0, bottom: 17.0),
              child: _friendProfile(),
            ),

            Divider(color: Color(0xFFF5F5F5)),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 17.0),
                  child: Text(
                    '오늘의 목표 달성률',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'Pretendard Variable',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                _dialogButtonWidget(
                  text: '운동',
                  start: 45,
                  end: 60,
                  imageUrl: 'assets/buddyzone/friend_profile/heart.svg',
                  offset: '분',
                ),
                SizedBox(height: 12.0),
                _dialogButtonWidget(
                  text: '식사',
                  start: 7500,
                  end: 10000,
                  imageUrl: 'assets/buddyzone/friend_profile/diet.svg',
                  offset: '걸음',
                ),
                SizedBox(height: 12.0),
                _dialogButtonWidget(
                  text: '수면',
                  start: 7.5,
                  end: 8,
                  imageUrl: 'assets/buddyzone/friend_profile/medi.svg',
                  offset: '시간',
                ),
              ],
            ),
            SizedBox(height: 40.0),
            Row(
              children: [
                // 취소 버튼
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      // horizontal: 16.0,
                      // vertical: 5.0,
                    ),
                    alignment: Alignment.center,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      color: Color(0xFF1AEDB0),
                    ),
                    child: TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        foregroundColor: Color(0xFF669588),
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Container(
                        padding: EdgeInsets.all(16.0),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/buddyzone/friend_profile/hand_white.svg',
                              ),
                              SizedBox(width: 12.0),
                              Text(
                                '콕 찌르기',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: 'Pretendard Variable',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _dialogButtonWidget({
    required String text,
    required double start,
    required double end,
    required String imageUrl,
    required String offset,
  }) {
    double? ratio = start / end;
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(imageUrl),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontFamily: 'Pretendard Variable',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Text(
              '${start}/${end}${offset}',
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontFamily: 'Pretendard Variable',
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
        SizedBox(height: 10.0),

        Container(
          width: double.infinity,
          alignment: Alignment.centerLeft,
          height: 10.0,
          decoration: BoxDecoration(
            color: Color(0xFFEBEBEB),
            borderRadius: BorderRadius.circular(10.0),
          ),
          // 경험치 비율에 맞게 조정
          child: FractionallySizedBox(
            widthFactor: ratio,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFF1AEDB0),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _friendProfile() {
    return Row(
      children: [
        SizedBox(
          width: 51.0,
          height: 51.0,
          child: ClipOval(
            child: Image(
              // image: widget.comment.writerProfileImageUrl == null
              //     ? AssetImage('assets/buddyzone/myprofile.png')
              //     : NetworkImage(widget.comment.writerProfileImageUrl!),
              image: AssetImage('assets/buddyzone/myprofile.png'),
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
                    '김헬스',
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
                        // 'Lv.${widget.comment.writerLevel}',
                        'Lv. 15',
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
              SizedBox(height: 6.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  textAlign: TextAlign.left,
                  '${timeago.format(DateTime.now(), locale: 'ko_custom')} 활동',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14.0),
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.white,
          ),
          child: Align(
            alignment: Alignment.topLeft,
            child: TextButton(
              onPressed: () {
                print("친구 추가 클릭!");
                // _showdialog(context);
              },
              style: TextButton.styleFrom(
                foregroundColor: Color(0x1188D3BD),
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                minimumSize: Size.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/buddyzone/friend_profile/x_button.svg',
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
