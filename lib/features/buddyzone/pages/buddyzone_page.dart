// features/home/pages/home_page.dart
import 'package:bodybuddy_frontend/features/buddyzone/pages/subPages/sub_newfeed_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../common/widgets/main_appbar.dart';
import 'subPages/sub_feed_page.dart';

import 'buddy_friends_page.dart';
import 'buddy_feed_page.dart';

class BuddyZonePage extends StatefulWidget {
  const BuddyZonePage({super.key});

  @override
  State<BuddyZonePage> createState() => _BuddyZoneState();
}

class _BuddyZoneState extends State<BuddyZonePage> {
  int _isBuddySelectIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F8F8),
      appBar: MainAppbar(
        navIndex: 3,
        titleText: '버디존',
        imageUrl: 'assets/images/common/shop.svg',
        buttonText: '친구 추가',
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 49.0,
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isBuddySelectIndex = 0;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          bottom: BorderSide(
                            width: 2.0,
                            color: _isBuddySelectIndex == 0
                                ? Color(0xFF1AEDB1)
                                : Colors.transparent,
                          ),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '피드',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isBuddySelectIndex = 1;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          bottom: BorderSide(
                            width: 2.0,
                            color: _isBuddySelectIndex == 1
                                ? Color(0xFF1AEDB1)
                                : Colors.transparent,
                          ),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '친구',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_isBuddySelectIndex == 0) ...[
            Expanded(child: BuddyFeedPage()),
          ] else if (_isBuddySelectIndex == 1) ...[
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: BuddyFriendPage(),
              ),
            ),
          ],
          // Container(padding: EdgeInsets.all(16.0), child: FeedOnlyWidget()),
        ],
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 40.0),
        width: 40.0,
        height: 40.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 7.5,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Color(0xFF1AEDB1),
            foregroundColor: Color(0xFF669688),
            elevation: 0.0,
          ),
          onPressed: () {
            Navigator.of(
              context,
              rootNavigator: true,
            ).push(MaterialPageRoute(builder: (context) => SubNewFeedPages()));
          },
          child: SvgPicture.asset('assets/buddyzone/newFeed.svg'),
        ),
      ),
    );
  }
}
