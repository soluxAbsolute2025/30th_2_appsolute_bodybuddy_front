import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MypageLevelWidget extends StatelessWidget {
  const MypageLevelWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.orange,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '다음 레벨까지',
                style: TextStyle(
                  color: Color(0xFF7D7C7C),
                  fontSize: 14,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(width: 6.0),
              Text(
                '550XP',
                style: TextStyle(
                  color: Color(0xFF17D8A1),
                  fontSize: 16,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(width: 3.0),
              Text(
                '남음',
                style: TextStyle(
                  color: Color(0xFF7D7C7C),
                  fontSize: 14,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.0),
          Container(
            width: double.infinity,
            height: 10.0,
            decoration: BoxDecoration(
              color: Color(0xFF17D8A1),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '2,450XP',
                style: TextStyle(
                  color: Color(0xFF7D7C7C),
                  fontSize: 12,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                '3,000XP',
                style: TextStyle(
                  color: Color(0xFF7D7C7C),
                  fontSize: 12,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
