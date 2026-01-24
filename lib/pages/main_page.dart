// lib/pages/main_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../common/widgets/main_bottom_nav.dart';
import '../common/widgets/main_floating.dart';

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
  bool _hideBottomNav = false;

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: _pages[_currentIndex],
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildNavigator(0, const HomePage()),
          _buildNavigator(1, const BodyLogPage()),
          _buildNavigator(2, const ChallengePage()),
          _buildNavigator(3, const BuddyZonePage()),
          _buildNavigator(4, const MypagePage()),
        ],
      ),

      floatingActionButton: _shouldShowFloating()
          ? MainFloating(navigatorKey: _navigatorKeys[_currentIndex])
          : null,
      bottomNavigationBar: _hideBottomNav
          ? null
          : MainBottomNav(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                  _hideBottomNav =
                      _navigatorKeys[_currentIndex].currentState?.canPop() ?? false;
                });
              },
            ),
    );
  }

  Widget _buildNavigator(int index, Widget page) {
    return Navigator(
      key: _navigatorKeys[index],
      observers: [
        _TabNavObserver(
          onChanged: () {
            final nav = _navigatorKeys[_currentIndex].currentState;
            final shouldHide = nav?.canPop() ?? false;

            if (mounted && _hideBottomNav != shouldHide) {
              setState(() => _hideBottomNav = shouldHide);
            }
          },
        ),
      ],
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(builder: (context) => page);
      },
    );
  }

  // 조건에 따라 플로팅 버튼 표시 여부 결정
  bool _shouldShowFloating() {
    return true;
  }
}

class _TabNavObserver extends NavigatorObserver {
  final VoidCallback onChanged;
  _TabNavObserver({required this.onChanged});

  @override
  void didPush(Route route, Route? previousRoute) => onChanged();

  @override
  void didPop(Route route, Route? previousRoute) => onChanged();

  @override
  void didRemove(Route route, Route? previousRoute) => onChanged();

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) => onChanged();
}
