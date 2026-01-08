import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/feeds/feed_search_widget.dart';
import '../widgets/feeds/feed_hottag_widget.dart';
import '../widgets/feeds/feed_frame_widget.dart';
import './subPages/sub_feed_pages.dart';

class BuddyFeedPage extends StatelessWidget {
  const BuddyFeedPage({super.key});

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
          FeedFrameWidget(),
          SizedBox(height: 16.0),
          FeedFrameWidget(),
          SizedBox(height: 70.0),
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
      ),
    );
  }
}
