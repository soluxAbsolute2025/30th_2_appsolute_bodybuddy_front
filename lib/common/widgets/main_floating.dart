import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import '../../features/carebuddy/pages/carebuddy_page.dart';
// import '../../features/buddyzone/pages/subPages/sub_feed_page.dart';

class MainFloating extends StatelessWidget {
  final GlobalKey<NavigatorState>? navigatorKey;

  const MainFloating({super.key, this.navigatorKey});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 7.5,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.none,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            Navigator.of(
              context,
              rootNavigator: true,
            ).push(MaterialPageRoute(builder: (_) => const CareBuddyPage()));
          },
          splashColor: Colors.black.withOpacity(0.015),
          highlightColor: Colors.black.withOpacity(0.015),
          child: Ink(
            height: 35,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFDFAD4), Color(0xFFB8FFED)],
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/common/main_logo.png',
                  height: 20,
                  width: 15,
                ),
                const SizedBox(width: 8),
                const Text(
                  'AI 케어',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
