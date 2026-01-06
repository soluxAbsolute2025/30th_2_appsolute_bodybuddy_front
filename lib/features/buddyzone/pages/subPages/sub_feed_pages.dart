import 'package:bodybuddy_frontend/common/widgets/sub_appbar.dart';
import 'package:flutter/material.dart';

import '../../widgets/feeds/feed_only_widget.dart';
import '../../widgets/feeds/feed_comment_widget.dart';
import '../../../../common/widgets/sub_appbar.dart';

class SubFeedPages extends StatelessWidget {
  const SubFeedPages({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SubAppbar(),
      body: SingleChildScrollView(
        // appBar: SubAppbar(titleText: ''),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              child: FeedOnlyWidget(profileSize: 37.0, fontSize: 14.0),
            ),
            SizedBox(height: 12.0),
            Divider(),
            SizedBox(height: 12.0),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.centerLeft,
              child: Text(
                '댓글 '
                '8',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w400,
                  height: 1.50,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 20.0),
              alignment: Alignment.centerLeft,
              child: Column(
                children: [
                  FeedCommentWidget(),
                  FeedCommentWidget(),
                  FeedCommentWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
