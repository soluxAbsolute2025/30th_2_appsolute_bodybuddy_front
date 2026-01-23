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
  final TextEditingController searchController = TextEditingController();

  List<FeedPost> feeds = [];
  List<String> hashtags = [];
  int currentPage = 0;
  bool isLoading = false;
  bool isLast = false;

  void initState() {
    super.initState();
    _setHashtagList();
    _setFeedList();
  }

  Future<void> _setHashtagList() async {
    final data = await FeedsApi().getHashtag();

    if (data != null) {
      setState(() {
        hashtags = List<String>.from(data);
      });
    }
  }

  void onSearchFeed({required String keyword}) {
    if (keyword.isEmpty || keyword.length < 2) return;
    _currentRequest = FeedRequest(mode: FeedMode.search, keyword: keyword);
    _resetAndFetch();
  }

  void onTagFeed({required String tag}) {
    _currentRequest = FeedRequest(mode: FeedMode.tag, tag: tag);
    _resetAndFetch();
  }

  void onNormalFeed() {
    _currentRequest = FeedRequest(mode: FeedMode.normal);
    _resetAndFetch();
  }

  void _resetAndFetch() {
    currentPage = 0;
    isLast = false;
    feeds.clear();

    _setFeedList();
  }

  Future<void> _setFeedList() async {
    if (isLoading || isLast) return;
    setState(() {
      isLoading = true;
    });

    final response = await FeedRequestAPI().getFeedRequest(
      request: _currentRequest,
    );

    // print(response.content);

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
      color: Colors.white,
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 16.0,
            ),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  FeedSearchWidget(
                    onSearchFeed: onSearchFeed,
                    controller: searchController,
                  ),
                  SizedBox(height: 16.0),
                  hashtags.isEmpty
                      ? Container()
                      : FeedHottagWidget(
                          onTagFeed: onTagFeed,
                          hashList: hashtags,
                        ),
                ],
              ),
            ),
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
                  child: FeedFrameWidget(
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
                    feed: feeds[index],
                  ),
                );
              }, childCount: feeds.length),
            ),
          ),

          // 로딩 중 또는 마지막 페이지에 도달한 경우
          SliverToBoxAdapter(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : (isLast ? _endFeeds() : const SizedBox(height: 80)),
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
        SizedBox(height: 80.0),
      ],
    );
  }
}
