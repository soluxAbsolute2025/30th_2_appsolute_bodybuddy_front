import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:timeago/timeago.dart' as timeage;
import 'package:bodybuddy_frontend/features/carebuddy/providers/custom_ko_messages.dart';

import '../../models/feeds/feed_content_model.dart';

class FeedMyCommentWidget extends StatefulWidget {
  final FeedComment comment;
  // [추가] 부모로부터 받을 함수들 정의
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const FeedMyCommentWidget({
    super.key,
    required this.comment,
    required this.onEdit, // 필수 인자로 받기
    required this.onDelete, // 필수 인자로 받기
  });

  @override
  State<FeedMyCommentWidget> createState() => _FeedMyCommentWidgetState();
}

class _FeedMyCommentWidgetState extends State<FeedMyCommentWidget> {
  @override
  void initState() {
    super.initState();
    timeage.setLocaleMessages('ko_custom', MyCustomKomassages());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 37.0,
              height: 37.0,
              child: ClipOval(
                child: Image(
                  image: AssetImage('assets/images/common/profile1.jpg'),
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
                        widget.comment.writerNickname,
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF17D8A1),
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
                            'Lv.${widget.comment.id}',
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
                  // SizedBox(height: 2.0),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      textAlign: TextAlign.left,
                      timeage.format(
                        widget.comment.createdAt,
                        locale: 'ko_custom',
                      ),
                      style: TextStyle(color: Colors.grey[600], fontSize: 14.0),
                    ),
                  ),
                ],
              ),
            ),
            Theme(
              data: Theme.of(context).copyWith(
                popupMenuTheme: PopupMenuThemeData(
                  color: Colors.white,
                  surfaceTintColor: Colors.transparent,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(color: Color(0xFFEEEEEE)),
                  ),

                  elevation: 5,
                  shadowColor: Color(0xAAE3E3E3),
                ),
              ),
              child: PopupMenuButton<String>(
                icon: SvgPicture.asset('assets/buddyzone/dot3.svg'),

                // 버튼 자체의 터치 영역과 패딩을 최소화
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),

                // 위치 조정 (버튼 아래로 35px 이동)
                offset: const Offset(-20, 40),

                onSelected: (value) {
                  if (value == 'edit') {
                    widget.onEdit(); // 부모가 준 수정 함수 실행!
                  } else if (value == 'delete') {
                    widget.onDelete(); // 부모가 준 삭제 함수 실행!
                  }
                },

                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'edit',
                    height: 36,
                    padding: EdgeInsets.symmetric(horizontal: 14),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 3.0),
                          child: SvgPicture.asset(
                            'assets/buddyzone/pencil.svg',
                          ),
                        ),
                        SizedBox(width: 6.0),
                        Text(
                          '수정하기',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: 'Pretendard Variable',
                            fontWeight: FontWeight.w400,
                            height: 1.50,
                          ),
                        ),
                        SizedBox(width: 10.0),
                      ],
                    ),
                  ),
                  const PopupMenuDivider(
                    height: 12,
                    thickness: 1,
                    color: Color(0xFFF5F5F5),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    height: 36,
                    padding: EdgeInsets.symmetric(horizontal: 14),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 3.0),
                          child: SvgPicture.asset(
                            'assets/buddyzone/del_red.svg',
                          ),
                        ),
                        SizedBox(width: 6.0),
                        Text(
                          '삭제하기',
                          style: TextStyle(
                            color: Color(0xFFEA441A),
                            fontSize: 14,
                            fontFamily: 'Pretendard Variable',
                            fontWeight: FontWeight.w400,
                            height: 1.50,
                          ),
                        ),
                        SizedBox(width: 30.0),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.only(top: 6.0, left: 53.0),
          alignment: Alignment.centerLeft,
          child: Text('${widget.comment.content} ', style: TextStyle()),
        ),
        SizedBox(height: 30.0),
      ],
    );
  }
}
