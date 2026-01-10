import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'feed_only_widget.dart';

class FeedFrameWidget extends StatelessWidget {
  const FeedFrameWidget({super.key});

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
      child: FeedOnlyWidget(),
    );
  }
}
