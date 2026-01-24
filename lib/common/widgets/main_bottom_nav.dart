// lib/widgets/main_bottom_nav.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const MainBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,

      // 커스텀
      selectedFontSize: 10.0,
      unselectedFontSize: 10.0,
      selectedItemColor: Color(0xFF1AEDB1),
      unselectedItemColor: Color(0xFF7D7C7C),

      items: _bottomNavItems.map((item) {
        return BottomNavigationBarItem(
          icon: Image(
            image: AssetImage(
              currentIndex == item.index ? item.actIcon : item.inactIcon,
            ),
          ),
          label: item.label,
        );
      }).toList(),
    );
  }
}

class BottomNavItem {
  final int index;
  final String actIcon;
  final String inactIcon;
  final String label;

  const BottomNavItem({
    required this.index,
    required this.actIcon,
    required this.inactIcon,
    required this.label,
  });
}

const _bottomNavItems = [
  BottomNavItem(
    index: 0,
    actIcon: 'assets/images/home_true.png',
    inactIcon: 'assets/images/home_false.png',
    label: '홈',
  ),
  BottomNavItem(
    index: 1,
    actIcon: 'assets/images/bodylog_true.png',
    inactIcon: 'assets/images/bodylog_false.png',
    label: '바디로그',
  ),
  BottomNavItem(
    index: 2,
    actIcon: 'assets/images/challenge_true.png',
    inactIcon: 'assets/images/challenge_false.png',
    label: '챌린지',
  ),
  BottomNavItem(
    index: 3,
    actIcon: 'assets/images/buddyzone_true.png',
    inactIcon: 'assets/images/buddyzone_false.png',
    label: '버디존',
  ),
  BottomNavItem(
    index: 4,
    actIcon: 'assets/images/mypage_true.png',
    inactIcon: 'assets/images/mypage_false.png',
    label: '마이',
  ),
];
