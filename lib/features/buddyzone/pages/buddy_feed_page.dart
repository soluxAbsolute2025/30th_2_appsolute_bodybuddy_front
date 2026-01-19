import 'package:bodybuddy_frontend/features/buddyzone/api/buddyzone_hottag_api.dart';
import 'package:bodybuddy_frontend/features/buddyzone/models/feeds/feed_content_model.dart';
import 'package:bodybuddy_frontend/features/buddyzone/models/feeds/feed_type_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/feeds/feed_search_widget.dart';
import '../widgets/feeds/feed_hottag_widget.dart';
import '../widgets/feeds/feed_frame_widget.dart';
import './subPages/sub_feed_page.dart';

class BuddyFeedPage extends StatefulWidget {
  const BuddyFeedPage({super.key});

  @override
  State<BuddyFeedPage> createState() => _BuddyFeedPageState();
}

class _BuddyFeedPageState extends State<BuddyFeedPage> {
  FeedRequest _currentRequest = FeedRequest(mode: FeedMode.normal);

  List<FeedPost> feeds = [];
  int currentPage = 0;
  bool isLoading = false;
  bool isLast = false;

  void initState() {
    super.initState();
    _setFeedList();
  }

  Future<void> _setFeedList() async {
    if (isLoading || isLast) return;
    setState(() {
      isLoading = true;
    });

    print("일단 들어오기는 했음");
    final response = await FeedRequestAPI().getFeedRequest(
      accessToken:
          'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJycnJyIiwidXNlcklkIjozMzksImlhdCI6MTc2ODgxMTUyMywiZXhwIjoxNzY4ODE1MTIzfQ.1ODFmXvhfa7Xbb6Q0DyDgwlZdSjGylbdz2fqm8ewnEo',
      request: _currentRequest,
    );

    print(response.content);

    setState(() {
      feeds.addAll(response.content);
      currentPage++;
      isLast = response.last;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          FeedSearchWidget(),
          SizedBox(height: 16.0),
          FeedHottagWidget(),
          SizedBox(height: 24.0),
          TextButton(
            onPressed: () {
              _setFeedList();
            },
            child: Text('임시 확인 버튼'),
          ),
          TextButton(
            onPressed: () {
              FeedsApi().postFeeds(
                'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ3d3d3IiwidXNlcklkIjozMzgsImlhdCI6MTc2ODgxMDU1OCwiZXhwIjoxNzY4ODE0MTU4fQ.D1MEwdTfXHJaGddkxJLKMQpW-GE_0nFPR_qEqxaa3mU',
              );
            },
            child: Text('임시 생성 버튼'),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: feeds.length,
            itemBuilder: (context, index) {
              return FeedFrameWidget();
            },
          ),
        ],
      ),
    );
  }

  Widget _endFeeds() {
    return Column(
      children: [
        SizedBox(height: 54.0),
        Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              Center(child: SvgPicture.asset('assets/buddyzone/check.svg')),
              SizedBox(height: 16.0),
              Text(
                '최신 소식을 전부 확인했습니다.',
                style: TextStyle(
                  color: const Color(0xFF2B2B2B),
                  fontSize: 16,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 75.0),
      ],
    );
  }
}
