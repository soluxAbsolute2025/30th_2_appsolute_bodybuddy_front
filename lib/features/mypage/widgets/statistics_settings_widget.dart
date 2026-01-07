import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StatisticsSettingsWidget extends StatelessWidget {
  const StatisticsSettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 16.0),
      // constraints: BoxConstraints(maxHeight: 100.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Text(
              '나의 기록',
              style: TextStyle(
                color: const Color(0xFF000000),
                fontSize: 16,
                fontFamily: 'Pretendard Variable',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  '주간 통계',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Pretendard',
                  ),
                ),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  foregroundColor: Color(0x1188D3BD),
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
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
          SizedBox(height: 13.0),
          Row(
            children: [
              Expanded(
                child: Text(
                  '월간 통계',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Pretendard',
                  ),
                ),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  foregroundColor: Color(0x1188D3BD),
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
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
          SizedBox(height: 16.0),
          Row(
            children: [
              Expanded(
                child: Text(
                  '연간 통계',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Pretendard',
                  ),
                ),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  foregroundColor: Color(0x1188D3BD),
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
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
          SizedBox(height: 16.0),
          Divider(color: Color(0xFFF3F3F3)),

          // 목표 설정
          Padding(
            padding: const EdgeInsets.only(top: 18.0, bottom: 20.0),
            child: Text(
              '목표 관리',
              style: TextStyle(
                color: const Color(0xFF000000),
                fontSize: 16,
                fontFamily: 'Pretendard Variable',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  '일일 목표 설정',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Pretendard',
                  ),
                ),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  foregroundColor: Color(0x1188D3BD),
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
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
          SizedBox(height: 13.0),
          Row(
            children: [
              Expanded(
                child: Text(
                  '주간 목표 설정',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Pretendard',
                  ),
                ),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  foregroundColor: Color(0x1188D3BD),
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
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
          SizedBox(height: 16.0),
          Row(
            children: [
              Expanded(
                child: Text(
                  '월간 목표 설정',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Pretendard',
                  ),
                ),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  foregroundColor: Color(0x1188D3BD),
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
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
          SizedBox(height: 16.0),
          Divider(color: Color(0xFFF3F3F3)),
          // 나의 글 모아보기
          Padding(
            padding: const EdgeInsets.only(top: 18.0, bottom: 20.0),
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
        ],
      ),
    );
  }
}
