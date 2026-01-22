import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '/features/mypage/pages/mypage_profile_page.dart';

class MypageProfileWidget extends StatelessWidget {
  const MypageProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      constraints: BoxConstraints(maxHeight: 90.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 62.0,
            height: 62.0,
            child: ClipOval(
              child: Image(image: AssetImage('assets/mypage/myprofile.png')),
            ),
          ),
          SizedBox(width: 14.0),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    Text(
                      '김헬스',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Pretendard',
                      ),
                    ),
                    SizedBox(width: 8.0),
                    Container(
                      // height: 17.0,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 1.0,
                          horizontal: 10.0,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFFE9FFF9),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Text(
                          'Lv.15',
                          style: TextStyle(
                            color: Color(0xFF18D9A2),
                            fontSize: 11.0,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Pretendard',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.0),
                Row(
                  children: [
                    Container(
                      child: Text(
                        textAlign: TextAlign.left,
                        '건강한 라이프 스타일 실천 중',
                        style: TextStyle(
                          color: Color(0xFF747474),
                          fontSize: 14.0,
                          fontFamily: 'Pretendard',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(
                  builder: (context) => const MypageProfilePage(),
                ),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: Color(0x1188D3BD),
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap, // 터치 영역을 내용물에 맞춤
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            child: SvgPicture.asset(
              'assets/mypage/arrow.svg',
              width: 6.0,
              height: 10.0,
            ),
          ),
        ],
      ),
    );
  }
}
