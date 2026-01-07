import 'package:bodybuddy_frontend/features/mypage/pages/mypage_passward_page.dart';
import 'package:bodybuddy_frontend/features/mypage/pages/mypage_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StatisticsSettingsWidget extends StatelessWidget {
  const StatisticsSettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.only(bottom: 16.0),
      // constraints: BoxConstraints(maxHeight: 100.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '공개 범위 설정',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Pretendard',
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    foregroundColor: Color(0x1188D3BD),
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 5.0,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize:
                        MaterialTapTargetSize.shrinkWrap, // 터치 영역을 내용물에 맞춤
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
          ),
          SizedBox(height: 16.0),
          Divider(color: Color(0xFFF3F3F3)),

          // 내가 쓴 글
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '내가 쓴 글',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Pretendard',
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    foregroundColor: Color(0x1188D3BD),
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 5.0,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize:
                        MaterialTapTargetSize.shrinkWrap, // 터치 영역을 내용물에 맞춤
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
          ),
          SizedBox(height: 16.0),
          Divider(color: Color(0xFFF3F3F3)),
          // 비밀번호 변경
          Padding(
            padding: const EdgeInsets.only(top: 16.0, bottom: 24.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '비밀번호 설정',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Pretendard',
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                        builder: (context) => const MypagePasswardPage(),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Color(0x1188D3BD),
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 5.0,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize:
                        MaterialTapTargetSize.shrinkWrap, // 터치 영역을 내용물에 맞춤
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
          ),
        ],
      ),
    );
  }
}
