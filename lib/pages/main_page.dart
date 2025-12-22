// lib/pages/main_page.dart

import 'package:flutter/material.dart';
import '../common/widgets/main_bottom_nav.dart';

import '../features/home/pages/home_page.dart';
import '../features/bodylog/pages/bodylog_page.dart';
import '../features/challenge/pages/challenge_page.dart';
import '../features/buddyzone/pages/buddyzone_page.dart';
import '../features/mypage/pages/mypage_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    BodyLogPage(),
    ChallengePage(),
    BuddyZonePage(),
    MypagePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: MainBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
