import 'package:bodybuddy_frontend/features/buddyzone/api/buddyzone_hottag_api.dart';

import '../../pages/subPages/sub_feed_page.dart';
import 'package:bodybuddy_frontend/features/buddyzone/pages/subPages/sub_feed_page.dart';
import '../../models/feeds/feed_content_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FeedOnlyWidget extends StatefulWidget {
  final VoidCallback? onLikeToggle;
  final double? profileSize;
  final double? fontSize;
  final bool? isCommentOpen;
  final FeedPost feed;

  const FeedOnlyWidget({
    super.key,
    this.profileSize = 33.0,
    this.fontSize = 12.0,
    this.isCommentOpen = true,
    this.onLikeToggle,
    required this.feed,
  });

  @override
  State<FeedOnlyWidget> createState() => _FeedOnlyWidgetState();
}

class _FeedOnlyWidgetState extends State<FeedOnlyWidget> {
  int commentCount = 0;
  void _clickHeart() async {
    await FeedsApi().postFeedLike(widget.feed.id);
    if (widget.onLikeToggle != null) {
      widget.onLikeToggle!();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: [
            SizedBox(
              width: widget.profileSize,
              height: widget.profileSize,
              child: ClipOval(
                child: Image(
                  image: AssetImage('assets/buddyzone/myprofile.png'),
                ),
              ),
            ),
            SizedBox(width: 10.0),
            Expanded(
              child: Row(
                children: [
                  Text(
                    widget.feed.writerNickname,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'Pretendard',
                    ),
                  ),
                  SizedBox(width: 10.0),
                  _LevelBadge(),
                ],
              ),
            ),
            _metaInfo(),
          ],
        ),
        SizedBox(height: 16.0),
        Row(
          children: [
            Expanded(
              child: Text(
                widget.feed.content,
                softWrap: true,
                style: TextStyle(
                  fontSize: widget.fontSize,
                  height: 1.5,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Pretendard',
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.0),
        // Row(
        //   children: [
        //     Text(
        //       '#텍스트',
        //       style: TextStyle(
        //         fontSize: widget.fontSize,
        //         height: 1.5,
        //         fontWeight: FontWeight.w400,
        //         fontFamily: 'Pretendard',
        //         color: Color(0xFF18D9A2),
        //       ),
        //     ),
        //     SizedBox(width: 8.0),
        //     Text(
        //       '#텍스트',
        //       style: TextStyle(
        //         fontSize: widget.fontSize,
        //         height: 1.5,
        //         fontWeight: FontWeight.w400,
        //         color: Color(0xFF18D9A2),
        //         fontFamily: 'Pretendard',
        //       ),
        //     ),
        //     SizedBox(width: 8.0),
        //   ],
        // ),
        SizedBox(height: 16.0),
        Container(
          width: double.infinity,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image(
              fit: BoxFit.fitWidth,
              image: AssetImage('assets/images/common/profile1.jpg'),
            ),
          ),
        ),
        SizedBox(height: 16.0),
        Row(
          children: [
            TextButton(
              onPressed: () {
                _clickHeart();
              },
              style: TextButton.styleFrom(
                foregroundColor: Color(0xFF87D2BD),
                padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 6.0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                minimumSize: Size.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              child: SvgPicture.asset(
                width: 22,
                height: 19,
                widget.feed.liked
                    ? 'assets/buddyzone/heart.svg'
                    : 'assets/buddyzone/false_heart.svg',
              ),
            ),
            SizedBox(width: 2.0),
            Text(
              widget.feed.likeCount.toString(),
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(width: 10.0),
            TextButton(
              onPressed: () async {
                await Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(
                    builder: (context) => SubFeedPages(
                      feed: widget.feed,
                      onLikeToggle: () {
                        _clickHeart();
                      },
                      onCommentAdd: (String userContent) {
                        if (userContent == null) return;
                        setState(() {
                          widget.feed.comments.add(
                            FeedComment(
                              id: widget.feed.comments.length + 1,
                              content: userContent!, // 2. 전달받은 진짜 내용 저장
                              writerNickname: '나(테스트)', // 실제 유저 닉네임 연동 필요
                              createdAt: DateTime.now(),
                              updatedAt: DateTime.now(),
                              edited: false,
                            ),
                          );
                          widget.feed.commentCount++;
                        });
                      },
                    ),
                  ),
                );
                setState(() {});
              },
              style: TextButton.styleFrom(
                foregroundColor: Color(0xFF87D2BD),
                padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 6.0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                minimumSize: Size.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              child: Row(
                children: [
                  SvgPicture.asset('assets/buddyzone/talk.svg'),
                  SizedBox(width: 8.0),
                  Text(
                    widget.feed.comments.length.toString(),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Widget _tagText() {
  //   return
  // }

  Widget _LevelBadge() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 10.0),
      decoration: BoxDecoration(
        color: Color(0xFFE9FFF9),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Text(
        'Lv.15',
        style: TextStyle(
          color: Color(0xFF1AEDB1),
          fontSize: 11.0,
          fontWeight: FontWeight.w500,
          fontFamily: 'Pretendard',
        ),
      ),
    );
  }

  Widget _metaInfo() {
    return Row(
      children: [
        SvgPicture.asset('assets/buddyzone/time.svg'),
        SizedBox(width: 5.0),
        Text(
          '30'
          '분 전',
          style: TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.w400,
            color: Color(0xFF7D7C7C),
            fontFamily: 'Pretendard',
          ),
        ),
        SizedBox(width: 5.0),
        Text(
          '·',
          style: TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.w400,
            color: Color(0xFF7D7C7C),
            fontFamily: 'Pretendard',
          ),
        ),
        SizedBox(width: 5.0),
        SvgPicture.asset('assets/buddyzone/gps.svg'),
        SizedBox(width: 5.0),
        Text(
          '헬스장',
          style: TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.w400,
            color: Color(0xFF7D7C7C),
            fontFamily: 'Pretendard',
          ),
        ),
      ],
    );
  }
}
