import 'package:bodybuddy_frontend/common/widgets/sub_appbar.dart';
import 'package:bodybuddy_frontend/features/buddyzone/models/feeds/feed_content_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../widgets/feeds/feed_only_widget.dart';
import '../../widgets/feeds/feed_comment_widget.dart';
import '../../../../common/widgets/sub_appbar.dart';

class SubFeedPages extends StatefulWidget {
  final FeedPost feed;
  const SubFeedPages({super.key, required this.feed});

  @override
  State<SubFeedPages> createState() => _SubFeedPagesState();
}

class _SubFeedPagesState extends State<SubFeedPages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SubAppbar(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              // appBar: SubAppbar(titleText: ''),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 16.0, right: 16.0),
                    child: FeedOnlyWidget(
                      feed: widget.feed,
                      profileSize: 37.0,
                      fontSize: 14.0,
                    ),
                  ),
                  SizedBox(height: 12.0),
                  Divider(),
                  SizedBox(height: 12.0),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '댓글 '
                      '0',
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
                    padding: EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                      top: 20.0,
                    ),
                    alignment: Alignment.centerLeft,
                    child: Column(
                      children: [
                        if (false) _nullCommentText(),
                        FeedCommentWidget(),
                        FeedCommentWidget(),
                        FeedCommentWidget(),
                        _nullCommentText(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Color(0xFFE8E8E8), width: 1.0),
              ),
            ),
            child: Container(
              decoration: ShapeDecoration(
                color: const Color(0xFFF5F5F5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(127),
                ), // 둥근 타원형
              ),
              child: TextField(
                style: const TextStyle(fontSize: 14.0),
                decoration: InputDecoration(
                  hintText: '댓글을 작성해 보세요',
                  hintStyle: const TextStyle(
                    color: Color(0xFFA7A7A7),
                    fontSize: 14.0,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 12.0,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    icon: SvgPicture.asset(
                      'assets/carebuddy/send.svg', // 전송 아이콘 경로
                      width: 20,
                      height: 20,
                    ),
                    onPressed: () {
                      print("전송 클릭!");
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _nullCommentText() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 70.0),
      child: Text(
        '아직 댓글이 없어요\n'
        '가장 먼저 댓글을 남겨보세요',
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
