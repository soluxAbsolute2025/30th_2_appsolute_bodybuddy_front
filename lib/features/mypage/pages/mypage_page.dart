//예시 페이지 구조

// features/home/pages/home_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../common/widgets/main_appbar.dart';
import '../widgets/mypage_level_widget.dart';
import '../widgets/mypage_moem_widget.dart';
import '../widgets/mypage_profile_widget.dart';

class MypagePage extends StatelessWidget {
  const MypagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: MainAppbar(
        navIndex: 4,
        titleText: '마이페이지',
        imageUrl: 'assets/images/common/my.svg',
        buttonText: '친구 추가',
      ),
      body: Container(
        color: Colors.white,
        margin: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            MypageProfileWidget(),
            SizedBox(height: 5.0),
            MypageLevelWidget(),
            SizedBox(height: 30.0),
            MypageMoemWidget(),
            SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}
