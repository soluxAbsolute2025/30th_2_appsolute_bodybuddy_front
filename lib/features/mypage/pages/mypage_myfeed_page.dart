import 'package:bodybuddy_frontend/common/widgets/sub_appbar.dart';
import 'package:bodybuddy_frontend/features/mypage/widgets/mypage_myfeed_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MypageMyfeedPage extends StatefulWidget {
  const MypageMyfeedPage({super.key});

  @override
  State<MypageMyfeedPage> createState() => _MypageMyfeedPageState();
}

class _MypageMyfeedPageState extends State<MypageMyfeedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SubAppbar(titleText: '내가 쓴 글'),
      body: SingleChildScrollView(
        child: Column(children: [MypageMyFeedWidget()]),
      ),
    );
  }
}
