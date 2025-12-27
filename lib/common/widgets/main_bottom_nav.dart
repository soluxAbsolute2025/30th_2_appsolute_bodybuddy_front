// lib/common/widgets/main_bottom_nav.dart
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
          icon: SvgPicture.asset(
            currentIndex == item.index ? item.actIcon : item.inactIcon,
            width: 18,
            height: 18,
          ),
          label: item.label,
        );
      }).toList(),
      // [
      //   BottomNavigationBarItem(
      //     icon: SvgPicture.asset(
      //       'assets/images/common/home.svg',
      //       width: 18,
      //       height: 18,
      //     ),
      //     label: '홈',
      //   ),
      //   BottomNavigationBarItem(
      //     icon: SvgPicture.asset(
      //       'assets/images/common/bodylog.svg',
      //       width: 18,
      //       height: 18,
      //     ),
      //     label: '바디로그',
      //   ),
      //   BottomNavigationBarItem(
      //     icon: SvgPicture.asset(
      //       'assets/images/common/challenge.svg',
      //       width: 16,
      //       height: 16,
      //     ),
      //     label: '챌린지',
      //   ),
      //   BottomNavigationBarItem(
      //     icon: SvgPicture.asset(
      //       'assets/images/common/buddyzone.svg',
      //       width: 16,
      //       height: 16,
      //     ),
      //     label: '버디존',
      //   ),
      //   BottomNavigationBarItem(
      //     icon: SvgPicture.asset(
      //       'assets/images/common/my.svg',
      //       width: 18,
      //       height: 18,
      //     ),
      //     label: '마이',
      //   ),
      // ],
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
    actIcon: 'assets/images/common/act_home.svg',
    inactIcon: 'assets/images/common/home.svg',
    label: '홈',
  ),
  BottomNavItem(
    index: 1,
    actIcon: 'assets/images/common/bodylog.svg',
    inactIcon: 'assets/images/common/home.svg',
    label: '바디로그',
  ),
  BottomNavItem(
    index: 2,
    actIcon: 'assets/images/common/challenge.svg',
    inactIcon: 'assets/images/common/home.svg',
    label: '챌린지',
  ),
  BottomNavItem(
    index: 3,
    actIcon: 'assets/images/common/buddyzone.svg',
    inactIcon: 'assets/images/common/home.svg',
    label: '버디존',
  ),
  BottomNavItem(
    index: 4,
    actIcon: 'assets/images/common/act_my.svg',
    inactIcon: 'assets/images/common/my.svg',
    label: '마이',
  ),
];
