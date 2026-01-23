import 'package:bodybuddy_frontend/features/buddyzone/api/buddyzone_hottag_api.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:bodybuddy_frontend/features/carebuddy/providers/custom_ko_messages.dart';

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

  @override
  void initState() {
    super.initState();
    timeago.setLocaleMessages('ko_custom', MyCustomKomassages());
  }

  void _checkUserId() async {
    final respone = await FeedsApi().checkUserInfo();
    // print(respone);
  }

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
                  fit: BoxFit.fitWidth,
                  image: widget.feed.writerProfileImageUrl != null
                      ? NetworkImage(widget.feed.writerProfileImageUrl!)
                      : AssetImage('assets/buddyzone/myprofile.png'),
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
            // content 부부분
            Expanded(child: _contentText(content: widget.feed.content)),
          ],
        ),
        SizedBox(height: 16.0),
        if (widget.feed.imageUrl != null) ...[
          Container(
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image(
                fit: BoxFit.fitWidth,
                image: NetworkImage(widget.feed.imageUrl!),
              ),
            ),
          ),
          SizedBox(height: 16.0),
        ],

        Row(
          children: [
            TextButton(
              onPressed: () {
                _checkUserId();
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
              onPressed: widget.isCommentOpen == true
                  ? () async {
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
                                    content: userContent,
                                    writerProfileImageUrl:
                                        'assets/buddyzone/myprofile.png',
                                    writerNickname: '나(테스트)',
                                    writerLevel: 1,
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
                    }
                  : null,
              style: TextButton.styleFrom(
                foregroundColor: widget.isCommentOpen == true
                    ? Color(0xFF87D2BD)
                    : null,
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
        'Lv.${widget.feed.writerLevel}',
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
          timeago.format(widget.feed.createdAt, locale: 'ko_custom'),
          style: TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.w400,
            color: Color(0xFF7D7C7C),
            fontFamily: 'Pretendard',
          ),
        ),

        if (widget.feed.place != null) ...[
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
            widget.feed.place.toString(),
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w400,
              color: Color(0xFF7D7C7C),
              fontFamily: 'Pretendard',
            ),
          ),
        ],
      ],
    );
  }

  Widget _contentText({required String content}) {
    final List<String> hashTags = [];

    final RegExp regExp = RegExp(r'#[^\s#]+|[^#]+');
    final matches = regExp.allMatches(content);

    List<TextSpan> spans = [];

    for (final match in matches) {
      final text = match.group(0)!;

      if (text.startsWith('#')) {
        // # 제거 후 저장
        hashTags.add(text.substring(1));

        spans.add(
          TextSpan(
            text: text,
            style: TextStyle(
              fontSize: widget.fontSize,
              height: 1.5,
              fontWeight: FontWeight.w400,
              fontFamily: 'Pretendard',
              color: Color(0xFF18D9A2),
            ),
          ),
        );
      } else {
        spans.add(
          TextSpan(
            text: text,
            style: const TextStyle(color: Colors.black),
          ),
        );
      }
    }

    // 필요하다면 여기서 hashTags 사용 가능
    debugPrint(hashTags.toString());

    return Text.rich(
      TextSpan(
        style: TextStyle(fontSize: widget.fontSize, color: Colors.black),
        children: spans,
      ),
    );
  }
}
