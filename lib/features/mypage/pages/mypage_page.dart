import 'package:bodybuddy_frontend/features/mypage/api/mypage_api.dart';
import 'package:bodybuddy_frontend/features/mypage/models/mypage_info_model.dart';
import 'package:bodybuddy_frontend/features/mypage/models/mypage_privacy_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// 새로고침을 위함
import '../../../main.dart';

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

class _MypagePageState extends State<MypagePage> with RouteAware {
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
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 현재 페이지의 라우트 정보를 가져와 Observer에 등록
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void didPopNext() {
    print("마이페이지로 돌아왔습니다. 데이터를 갱신합니다.");
    // 이때는 로딩 화면을 보여주지 않고 조용히 데이터만 갱신하거나,
    // 필요하다면 isLoading을 true로 바꿔 로딩을 보여줄 수도 있습니다.
    getMypageInfoAll();
  }

  Future<void> getMypageInfoAll() async {
    try {
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
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFF1AEDB0), // 서비스 메인 컬러에 맞춰보세요!
          ),
        ),
      );
    }

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
