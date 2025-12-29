import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MypageMoemWidget extends StatelessWidget {
  const MypageMoemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.0),
      decoration: BoxDecoration(
        color: Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(10.0),
      ),
      height: 75.0,
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '12',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: 'Pretendard Variable',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 5.0),
                Text(
                  '완료한 챌린지',
                  style: TextStyle(
                    color: Color(0xFF7D7C7C),
                    fontSize: 12,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '49',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: 'Pretendard Variable',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 5.0),
                Text(
                  '연속 출석',
                  style: TextStyle(
                    color: Color(0xFF7D7C7C),
                    fontSize: 12,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w400,
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
