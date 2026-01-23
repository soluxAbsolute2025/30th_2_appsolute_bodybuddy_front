import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:timeago/timeago.dart' as timeage;
import 'package:bodybuddy_frontend/features/carebuddy/providers/custom_ko_messages.dart';

import '../../models/feeds/feed_content_model.dart';

class FeedCommentWidget extends StatefulWidget {
  final FeedComment comment;

  const FeedCommentWidget({super.key, required this.comment});

  @override
  State<FeedCommentWidget> createState() => _FeedCommentWidgetState();
}

class _FeedCommentWidgetState extends State<FeedCommentWidget> {
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
                  image: widget.comment.writerProfileImageUrl == null
                      ? AssetImage('assets/buddyzone/myprofile.png')
                      : NetworkImage(widget.comment.writerProfileImageUrl!),
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
                            'Lv.${widget.comment.writerLevel}',
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
