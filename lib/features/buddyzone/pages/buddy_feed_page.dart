import 'package:flutter/material.dart';
import '../widgets/feeds/feed_only_widget.dart';
import '../widgets/feeds/feed_search_widget.dart';
import '../widgets/feeds/feed_hottag_widget.dart';

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
          FeedOnlyWidget(),
          SizedBox(height: 16.0),
          FeedOnlyWidget(),
          SizedBox(height: 16.0),
        ],
      ),
    );
  }
}
