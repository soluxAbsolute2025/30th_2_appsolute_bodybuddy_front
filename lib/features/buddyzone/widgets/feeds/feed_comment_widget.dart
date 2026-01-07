import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

class FeedCommentWidget extends StatefulWidget {
  final String profileName;
  final int profileTime;
  final int profileLevel;
  final String comment;

  const FeedCommentWidget({
    super.key,
    this.profileName = '익명',
    this.profileTime = 30,
    this.profileLevel = 15,
    this.comment = '열심히 운동하시는 모습 너무 멋있습니다~^^',
  });

  @override
  State<FeedCommentWidget> createState() => _FeedCommentWidgetState();
}

class _FeedCommentWidgetState extends State<FeedCommentWidget> {
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
                        widget.profileName,
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
                            'Lv.${widget.profileLevel}',
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
                      '${widget.profileTime}분 전',
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
          child: Text('${widget.comment} ', style: TextStyle()),
        ),
        SizedBox(height: 30.0),
      ],
    );
  }
}
