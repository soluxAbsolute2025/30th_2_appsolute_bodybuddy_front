import 'package:bodybuddy_frontend/common/widgets/sub_appbar.dart';
import 'package:bodybuddy_frontend/features/buddyzone/api/buddyzone_hottag_api.dart';
import 'package:bodybuddy_frontend/features/buddyzone/models/feeds/feed_content_model.dart';
import 'package:bodybuddy_frontend/features/buddyzone/widgets/feeds/feed_my_comment_widget.dart';
import 'package:bodybuddy_frontend/features/mypage/api/mypage_api.dart';
import 'package:bodybuddy_frontend/features/mypage/models/mypage_info_model.dart';
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
  final FocusNode _focusNode = FocusNode();
  MyPageResponse? myPageResponse;
  bool _isLoading = true;

  bool isButtonEnabled = false;
  int? editingCommentId;
  int? editingCommentIndex;

  @override
  void initState() {
    super.initState();

    textController.addListener(() {
      setState(() {
        isButtonEnabled = textController.text.isNotEmpty;
      });
    });

    _setMyInfo();
  }

  @override
  void dispose() {
    textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _setMyInfo() async {
    try {
      MyPageResponse response = await MyPageAPI().getMyPageAllInfo();

      if (mounted) {
        setState(() {
          myPageResponse = response;
          _isLoading = false;
        });
      }
    } catch (e) {
      print("프로필 로딩 실패: $e");
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // void _sendMessage() async {
  //   final text = textController.text.trim();
  //   if (text.isEmpty || text.length < 2) {
  //     textController.clear();
  //     return;
  //   }
  //
  //   await FeedsApi().postFeedComment(widget.feed.id, text);
  //
  //   if (widget.onCommentAdd != null) {
  //     widget.onCommentAdd!(text);
  //   }
  //
  //   setState(() {});
  //
  //   print('text : ' + text);
  //   textController.clear();
  // }

  // [핵심 1] 전송 버튼 로직 수정
  void _sendMessage() async {
    final text = textController.text.trim();
    if (text.isEmpty || text.length < 2) return;

    if (editingCommentId == null) {
      // 1. [새 댓글 작성 모드]
      await FeedsApi().postFeedComment(widget.feed.id, text);
      if (widget.onCommentAdd != null) widget.onCommentAdd!(text);

      // (리스트 새로고침 로직이 없다면 임시로 UI에 추가하는 코드 필요할 수 있음)
    } else {
      // 2. [댓글 수정 모드]
      // API 호출 (FeedsApi에 patchFeedComment 메서드가 수정되었다고 가정)
      await FeedsApi().patchFeedComment(editingCommentId!, text);

      // UI 갱신: 리스트 데이터를 직접 수정해서 화면을 바꿈
      setState(() {
        // 현재 리스트에서 수정된 댓글을 찾아 내용을 바꿈
        if (editingCommentIndex != null &&
            editingCommentIndex! < widget.feed.comments.length) {
          widget.feed.comments[editingCommentIndex!].content = text;
        }
      });
    }

    // 3. 초기화 (공통)
    setState(() {
      editingCommentId = null;
      editingCommentIndex = null;
      textController.clear();
      isButtonEnabled = false;
    });
    FocusScope.of(context).unfocus(); // 키보드 내리기
  }

  // [핵심 2] 수정 모드 진입 함수
  void _onEditComment(int commentId, String oldContent, int index) {
    setState(() {
      editingCommentId = commentId; // ID 저장
      editingCommentIndex = index; // 인덱스 저장 (나중에 UI 갱신용)
      textController.text = oldContent; // 입력창에 기존 글 채우기
      isButtonEnabled = true; // 버튼 활성화
    });

    Future.delayed(Duration(milliseconds: 100), () {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  void _cancelEdit() {
    setState(() {
      editingCommentId = null;
      textController.clear();
      FocusScope.of(context).unfocus();
    });
  }

  void deleteComment(int commentId) async {
    try {
      await FeedsApi().deleteFeedComment(commentId);

      setState(() {
        widget.feed.comments.removeWhere((comment) => comment.id == commentId);
      });
      print("삭제 성공!"); // 로그 확인용
    } catch (e) {
      print("삭제 실패 (서버 에러): $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || myPageResponse == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF1AEDB0)),
        ),
      );
    }

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
                          if (comment.writerNickname ==
                              myPageResponse!.userProfile.nickname) {
                            return FeedMyCommentWidget(
                              comment: comment,
                              onEdit: () => _onEditComment(
                                comment.id,
                                comment.content,
                                widget.feed.comments.indexOf(comment),
                              ),
                              onDelete: () {
                                deleteComment(comment.id);
                              },
                            );
                          }
                          return FeedCommentWidget(comment: comment);
                        }).toList(),
                        // if (widget.feed.comments.isNotEmpty) ...[
                        //   FeedMyCommentWidget(
                        //     comment: widget.feed.comments[0], // 예시용
                        //     onEdit: () {
                        //       // [중요] 여기서 함수를 연결합니다!
                        //       _onEditComment(
                        //         widget.feed.comments[0].id,
                        //         widget.feed.comments[0].content,
                        //         0, // 인덱스
                        //       );
                        //     },
                        //     onDelete: () {
                        //       print(widget.feed.comments[0].id);
                        //       deleteComment(1);
                        //     },
                        //   ),
                        // ],
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
                focusNode: _focusNode,
                textInputAction: TextInputAction.done,
                onSubmitted: (value) {
                  _sendMessage();
                },
                maxLines: 1,
                style: const TextStyle(fontSize: 14.0),
                decoration: InputDecoration(
                  hintText: editingCommentId == null
                      ? '댓글을 작성해보세요'
                      : '댓글 수정 중...',
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
