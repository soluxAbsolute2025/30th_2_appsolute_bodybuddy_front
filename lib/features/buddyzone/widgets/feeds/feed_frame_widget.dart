import 'package:bodybuddy_frontend/features/buddyzone/models/feeds/feed_content_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'feed_only_widget.dart';

class FeedFrameWidget extends StatefulWidget {
  final FeedPost feed;
  final VoidCallback? onLikeToggle;
  const FeedFrameWidget({super.key, required this.feed, this.onLikeToggle});

  @override
  State<FeedFrameWidget> createState() => _FeedFrameWidgetState();
}

class _FeedFrameWidgetState extends State<FeedFrameWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Color(0xFFD9D9D9), width: 1.0),
      ),
      child: Column(
        children: [
          FeedOnlyWidget(feed: widget.feed, onLikeToggle: widget.onLikeToggle),
        ],
      ),
    );
  }
}
