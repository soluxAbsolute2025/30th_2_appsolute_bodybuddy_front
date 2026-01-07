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
                  child: Image(
                    image: AssetImage('assets/mypage/myprofile.png'),
                  ),
                ),
                Positioned(
                  bottom: 6,
                  right: -8,
                  child: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      foregroundColor: Color(0xFF669688),
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Container(
                      width: 27,
                      height: 27,
                      decoration: ShapeDecoration(
                        color: const Color(0xFF1AEDB0),
                        shape: OvalBorder(
                          side: BorderSide(width: 3, color: Colors.white),
                        ),
                      ),
                      child: SvgPicture.asset(
                        'assets/mypage/pencil.svg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Text('닉네임'),
            TextFormField(
              decoration: InputDecoration(
                hintText: '2~10자로 입력해주세요.',
                contentPadding: EdgeInsets.only(top: 10, bottom: 9, left: 10),
                hintStyle: TextStyle(
                  color: Color(0xFF747474),
                  fontSize: 16,
                  // weight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
