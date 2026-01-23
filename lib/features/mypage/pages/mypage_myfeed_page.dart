import 'package:bodybuddy_frontend/common/widgets/sub_appbar.dart';
import 'package:bodybuddy_frontend/features/buddyzone/api/buddyzone_hottag_api.dart';
import 'package:bodybuddy_frontend/features/buddyzone/models/feeds/feed_content_model.dart';
import 'package:bodybuddy_frontend/features/buddyzone/models/feeds/feed_type_model.dart';
import 'package:bodybuddy_frontend/features/buddyzone/widgets/feeds/feed_frame_widget.dart';
import 'package:bodybuddy_frontend/features/mypage/api/mypage_api.dart';
import 'package:bodybuddy_frontend/features/mypage/models/mypage_myfeed_model.dart';
import 'package:bodybuddy_frontend/features/mypage/widgets/mypage_myfeed_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MypageMyfeedPage extends StatefulWidget {
  const MypageMyfeedPage({super.key});

  @override
  State<MypageMyfeedPage> createState() => _MypageMyfeedPageState();
}

class _MypageMyfeedPageState extends State<MypageMyfeedPage> {
  List<FeedPost> feeds = [];
  bool isLoading = false;
  MyFeedModel? myFeedModel;

  @override
  void initState() {
    super.initState();
    _getMyFeedList();
  }

  Future<void> _getMyFeedList() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });

    myFeedModel = await MyPageAPI().getMyPageMyFeed();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SubAppbar(titleText: '내가 쓴 글'),
      body: isLoading && myFeedModel == null
          ? const Center(child: CircularProgressIndicator()) // 로딩 중일 때 표시
          : (myFeedModel?.data == null || myFeedModel!.data.isEmpty)
          ? _nullCommentText()
          : CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: TextButton(
                    onPressed: _getMyFeedList,
                    child: Text('새로고침'),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 16.0,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final item = myFeedModel!.data[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10.0),
                        child: MypageMyFeedWidget(
                          feed: item,
                          onLikeToggle: () {
                            setState(() {
                              if (feeds[index].liked) {
                                feeds[index].likeCount--;
                              } else {
                                feeds[index].likeCount++;
                              }
                              feeds[index].liked = !feeds[index].liked;
                            });
                          },
                          onDelete: () {
                            setState(() {
                              myFeedModel!.data.removeAt(index);
                            });
                          },
                        ),
                      );
                    }, childCount: myFeedModel?.data.length ?? 0),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _nullCommentText() {
    return Container(
      padding: EdgeInsets.only(bottom: 16.0),
      height: 350.0,
      alignment: Alignment.center,
      child: Text(
        '아직 작성한 글이 없습니다.\n'
        '버디존에서 원하는 글을 생성해보세요',
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
