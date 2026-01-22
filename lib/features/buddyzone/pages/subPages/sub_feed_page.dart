import 'package:bodybuddy_frontend/common/widgets/sub_appbar.dart';
import 'package:bodybuddy_frontend/features/buddyzone/api/buddyzone_hottag_api.dart';
import 'package:bodybuddy_frontend/features/buddyzone/models/feeds/feed_content_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../widgets/feeds/feed_only_widget.dart';
import '../../widgets/feeds/feed_comment_widget.dart';
import '../../../../common/widgets/sub_appbar.dart';

class SubFeedPages extends StatefulWidget {
  final FeedPost feed;
  final Function(String)? onCommentAdd;
  final VoidCallback? onLikeToggle;
  const SubFeedPages({
    super.key,
    required this.feed,
    required this.onCommentAdd,
    this.onLikeToggle,
  });

  @override
  State<SubFeedPages> createState() => _SubFeedPagesState();
}

class _SubFeedPagesState extends State<SubFeedPages> {
  final textController = TextEditingController();
  bool isButtonEnabled = false;

  void initState() {
    super.initState();

    textController.addListener(() {
      setState(() {
        isButtonEnabled = textController.text.isNotEmpty;
      });
    });
  }

  void _sendMessage() async {
    final text = textController.text.trim();
    if (text.isEmpty || text.length < 2) {
      textController.clear();
      return;
    }

    await FeedsApi().postFeedComment(widget.feed.id, text);

    if (widget.onCommentAdd != null) {
      widget.onCommentAdd!(text);
    }

    setState(() {});

    print('text : ' + text);
    textController.clear();
  }

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
                      onLikeToggle: () {
                        setState(() {
                          if (widget.feed.liked) {
                            widget.feed.likeCount--;
                          } else {
                            widget.feed.likeCount++;
                          }
                          widget.feed.liked = !widget.feed.liked;
                        });
                      },
                      profileSize: 37.0,
                      fontSize: 14.0,
                      isCommentOpen: false,
                    ),
                  ),
                  SizedBox(height: 12.0),
                  Divider(),
                  SizedBox(height: 12.0),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '댓글 ${widget.feed.comments.length}',
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
                        if (widget.feed.comments.isEmpty)
                          Container(
                            width: double.infinity,
                            child: _nullCommentText(),
                          ),
                        ...widget.feed.comments.map((comment) {
                          return FeedCommentWidget(comment: comment);
                        }).toList(),
                        // FeedCommentWidget(widget.feed),
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
              // 배경색과 둥근 모서리 설정
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: TextField(
                controller: textController,
                textInputAction: TextInputAction.done,
                onSubmitted: (value) {
                  _sendMessage();
                },
                maxLines: 1,
                style: const TextStyle(fontSize: 14.0),
                decoration: InputDecoration(
                  hintText: '댓글을 작성해보세요',
                  hintStyle: const TextStyle(
                    color: Color(0xFFA7A7A7),
                    fontSize: 14.0,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 12.0,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                  // 2. TextField 내부에 전송 아이콘(SuffixIcon) 배치
                  suffixIcon: _textFieldButton(),
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
      padding: EdgeInsets.symmetric(vertical: 55.0),
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

  Widget _textFieldButton() {
    return Container(
      margin: EdgeInsets.all(5.0),
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: Color(0xFF669688),
          backgroundColor: isButtonEnabled
              ? Color(0xFF1AEDB1)
              : Color(0xFFF8F8F8),
          padding: EdgeInsets.fromLTRB(2.0, 0.0, 0.0, 0.0),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: CircleBorder(),
        ),
        onPressed: isButtonEnabled ? _sendMessage : null,
        child: SvgPicture.asset(
          isButtonEnabled
              ? 'assets/carebuddy/send_active.svg'
              : 'assets/carebuddy/send.svg',
          key: ValueKey(isButtonEnabled),
        ),
      ),
    );
  }
}
