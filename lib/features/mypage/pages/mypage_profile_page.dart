import 'package:bodybuddy_frontend/common/widgets/sub_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MypageProfilePage extends StatefulWidget {
  const MypageProfilePage({super.key});

  @override
  State<MypageProfilePage> createState() => _MypageProfilePageState();
}

class _MypageProfilePageState extends State<MypageProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SubAppbar(titleText: '프로필 설정'),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 90,
                  height: 90,
                  decoration: ShapeDecoration(
                    shape: CircleBorder(),
                    color: Color(0xFFF8F8F8),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
