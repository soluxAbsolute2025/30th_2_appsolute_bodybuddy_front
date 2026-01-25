import 'package:bodybuddy_frontend/features/buddyzone/api/buddyzone_hottag_api.dart';
import 'package:bodybuddy_frontend/features/buddyzone/models/feeds/feed_content_model.dart';
import 'package:bodybuddy_frontend/features/buddyzone/pages/subPages/sub_feed_page.dart';
import 'package:bodybuddy_frontend/features/carebuddy/providers/custom_ko_messages.dart';
import 'package:bodybuddy_frontend/features/mypage/models/mypage_myfeed_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:timeago/timeago.dart' as timeago;

class MypageMyFeedWidget extends StatefulWidget {
  final FeedItem feed;
  final double? profileSize;
  final double? fontSize;
  final bool? isCommentOpen;
  final List<String> tags;
  final VoidCallback? onLikeToggle;
  final VoidCallback? onDelete;

  const MypageMyFeedWidget({
    super.key,
    required this.feed,
    this.profileSize = 33.0,
    this.fontSize = 12.0,
    this.isCommentOpen = true,
    this.tags = const [],
    this.onLikeToggle,
    this.onDelete,
  });

  @override
  State<MypageMyFeedWidget> createState() => _MypageMyFeedWidget();
}

class _MypageMyFeedWidget extends State<MypageMyFeedWidget> {
  FeedPost? detailFeed;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    timeago.setLocaleMessages('ko_custom', MyCustomKomassages());
    getPostInfo();
  }

  Future<void> deleteFeed() async {
    isLoading = true;

    await FeedsApi().deleteFeed(feedId: widget.feed.postId);

    if (widget.onDelete != null) {
      widget.onDelete!();
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> getPostInfo() async {
    try {
      final FeedPost response = await FeedsApi().detailFeeds(
        feedId: widget.feed.postId,
      );

      if (mounted) {
        setState(() {
          detailFeed = response;

          widget.feed.liked = response.liked;
          widget.feed.likeCount = response.likeCount;
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("상세 정보 로드 실패: $e");
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  void _clickHeart() async {
    await FeedsApi().postFeedLike(widget.feed.postId);

    setState(() {
      if (detailFeed != null) {
        detailFeed!.liked = !detailFeed!.liked;
        detailFeed!.liked ? detailFeed!.likeCount++ : detailFeed!.likeCount--;

        // 부모 리스트 데이터도 동기화
        widget.feed.liked = detailFeed!.liked;
        widget.feed.likeCount = detailFeed!.likeCount;
      }
    });

    if (widget.onLikeToggle != null) {
      widget.onLikeToggle!();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Column(
      children: [
        Column(
          children: <Widget>[
            Row(
              children: [
                SizedBox(
                  width: widget.profileSize,
                  height: widget.profileSize,
                  child: ClipOval(
                    child: Image(
                      fit: BoxFit.fitWidth,
                      image: widget.feed.profileImageUrl != null
                          ? NetworkImage(widget.feed.profileImageUrl!)
                          : AssetImage('assets/buddyzone/myprofile.png'),
                    ),
                  ),
                ),
                SizedBox(width: 10.0),
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        widget.feed.nickname,
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
            Row(children: [_contentText(content: widget.feed.content)]),
            SizedBox(height: 16.0),
            Container(
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image(
                  fit: BoxFit.fitWidth,
                  image:
                      widget.feed?.postImageUrl != null ||
                          widget.feed.postImageUrl != ''
                      ? NetworkImage(widget.feed.postImageUrl)
                      : AssetImage('assets/buddyzone/feed_image.png'),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        _clickHeart();
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Color(0xFF87D2BD),
                        padding: EdgeInsets.symmetric(
                          vertical: 6.0,
                          horizontal: 6.0,
                        ),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        minimumSize: Size.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      child: SvgPicture.asset(
                        width: 22,
                        height: 19,
                        detailFeed!.liked
                            ? 'assets/buddyzone/heart.svg'
                            : 'assets/buddyzone/false_heart.svg',
                      ),
                    ),
                    SizedBox(width: 2.0),
                    Text(
                      detailFeed!.likeCount.toString(),
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
                              await Navigator.of(
                                context,
                                rootNavigator: true,
                              ).push(
                                MaterialPageRoute(
                                  builder: (context) => SubFeedPages(
                                    feed: detailFeed!,
                                    onLikeToggle: () {
                                      setState(() {
                                        if (detailFeed!.liked) {
                                          detailFeed!.likeCount--;
                                        } else {
                                          detailFeed!.likeCount++;
                                        }
                                        detailFeed!.liked = detailFeed!.liked;
                                      });
                                    },
                                    onCommentAdd: (String userContent) {
                                      if (userContent == null) return;
                                      setState(() {
                                        detailFeed!.comments.add(
                                          FeedComment(
                                            id: detailFeed!.comments.length + 1,
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
                                        detailFeed!.commentCount++;
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
                        padding: EdgeInsets.symmetric(
                          vertical: 6.0,
                          horizontal: 6.0,
                        ),
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
                            detailFeed!.comments.length.toString(),
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
                Row(
                  children: [
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        foregroundColor: Color(0xFF87D2BD),
                        padding: EdgeInsets.symmetric(
                          vertical: 9.0,
                          horizontal: 9.0,
                        ),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        minimumSize: Size.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      child: SvgPicture.asset('assets/mypage/pencil_black.svg'),
                    ),
                    SizedBox(width: 8.0),
                    TextButton(
                      onPressed: () {
                        deleteFeed();
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Color(0xFFF65A33),
                        padding: EdgeInsets.symmetric(
                          vertical: 6.0,
                          horizontal: 6.0,
                        ),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        minimumSize: Size.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            '삭제',
                            style: TextStyle(
                              color: Color(0xFFEB441B),
                              fontSize: 14,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 18.0),
        Divider(color: Color(0xFFD8D8D8)),
        SizedBox(height: 18.0),
      ],
    );
  }

  Widget _LevelBadge() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 10.0),
      decoration: BoxDecoration(
        color: Color(0xFFE9FFF9),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Text(
        'Lv.${widget.feed.userLevel}',
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
        if (widget.feed.place != null) ...[
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
        ],
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
