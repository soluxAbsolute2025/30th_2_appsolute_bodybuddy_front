import 'package:bodybuddy_frontend/features/mypage/api/mypage_api.dart';
import 'package:bodybuddy_frontend/features/mypage/models/mypage_info_model.dart';
import 'package:bodybuddy_frontend/features/mypage/models/mypage_privacy_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../common/widgets/main_appbar.dart';
import '../widgets/badge_collection_widget.dart';
import '../widgets/etc_widget.dart';
import '../widgets/statistics_settings_widget.dart';
import '../widgets/mypage_level_badge_widget.dart';
import '../widgets/mypage_moem_widget.dart';
import '../widgets/mypage_profile_widget.dart';

class MypagePage extends StatefulWidget {
  const MypagePage({super.key});

  @override
  State<MypagePage> createState() => _MypagePageState();
}

class _MypagePageState extends State<MypagePage> {
  MyPageResponse? myPageInfo;
  PrivacyResponse? myPagePrivacy;
  bool isLoading = true; // 로딩 상태 관리 변수 추가

  @override
  void initState() {
    super.initState();
    getMypageInfoAll();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getMypageInfoAll() async {
    try {
      // API 호출
      final result = await MyPageAPI().getMyPageAllInfo();

      if (mounted) {
        setState(() {
          myPageInfo = result;
          isLoading = false;
        });
      }
    } catch (e) {
      print('마이페이지 데이터 로드 실패: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F8F8),
      appBar: MainAppbar(
        navIndex: 4,
        titleText: '마이페이지',
        imageUrl: 'assets/images/common/my.svg',
        buttonText: '친구 추가',
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  MypageProfileWidget(myPageInfo: myPageInfo),
                  MypageLevelBadgeWidget(myPageInfo: myPageInfo),
                  SizedBox(height: 30.0),
                  MypageMoemWidget(myPageInfo: myPageInfo),
                  SizedBox(height: 16.0),
                ],
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: BadgeCollectionWidget(myPageInfo: myPageInfo),
            ),
            SizedBox(height: 10.0),
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: StatisticsSettingsWidget(),
            ),
            SizedBox(height: 10.0),
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: EtcWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
