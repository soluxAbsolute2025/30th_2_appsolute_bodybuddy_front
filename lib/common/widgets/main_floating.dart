import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import '../features/carebuddy/pages/carebuddy_page.dart';
import '../../features/buddyzone/pages/subPages/sub_feed_pages.dart';

class MainFloating extends StatelessWidget {
  const MainFloating({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35.0,
      child: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context, rootNavigator: true).push(
            // MaterialPageRoute(builder: (context) => const CareBuddyPage()),
            MaterialPageRoute(builder: (context) => const SubFeedPages()),
          );
        },
        backgroundColor: Colors.transparent,
        elevation: 0,
        focusElevation: 0,
        hoverElevation: 0,
        highlightElevation: 0,
        extendedPadding: EdgeInsets.zero,
        label: Container(
          height: 35.0,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFDFAD4), Color(0xFFB8FFED)],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 7.5,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/common/main_logo.png',
                height: 20.0,
                width: 15.0,
              ),
              const SizedBox(width: 8.0),
              const Text(
                'AI 케어',
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
