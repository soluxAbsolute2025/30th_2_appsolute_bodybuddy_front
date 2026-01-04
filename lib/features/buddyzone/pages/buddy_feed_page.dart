import 'package:flutter/material.dart';
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
          SizedBox(height: 16.0),
        ],
      ),
    );
  }
}
