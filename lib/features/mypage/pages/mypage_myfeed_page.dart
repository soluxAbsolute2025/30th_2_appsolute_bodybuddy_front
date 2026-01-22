import 'package:bodybuddy_frontend/common/widgets/sub_appbar.dart';
import 'package:bodybuddy_frontend/features/buddyzone/api/buddyzone_hottag_api.dart';
import 'package:bodybuddy_frontend/features/buddyzone/models/feeds/feed_content_model.dart';
import 'package:bodybuddy_frontend/features/buddyzone/models/feeds/feed_type_model.dart';
import 'package:bodybuddy_frontend/features/buddyzone/widgets/feeds/feed_frame_widget.dart';
import 'package:bodybuddy_frontend/features/mypage/api/mypage_api.dart';
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

  void initState() {
    super.initState();
    _setFeedList();
  }

  Future<void> _setFeedList() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });

    // final response = await FeedRequestAPI().getFeedRequest(
    //   // request: _currentRequest,
    // );

    // print(response.content);

    setState(() {
      // feeds.addAll(response.content);
      isLoading = false;
    });
  }

  Future<void> _getMyFeedList() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });

    await MyPageAPI().getMyPageMyFeed();

    // print(response);

    setState(() {
      // feeds.addAll(response.content);
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SubAppbar(titleText: '내가 쓴 글'),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: TextButton(onPressed: _getMyFeedList, child: Text('테스트')),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 16.0,
            ),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return Container(
                  margin: EdgeInsets.only(bottom: 10.0),
                  child: MypageMyFeedWidget(feed: feeds[index]),
                );
              }, childCount: feeds.length),
            ),
          ),
        ],
      ),
    );
  }
}
