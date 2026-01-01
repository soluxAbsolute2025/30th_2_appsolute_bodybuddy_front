import 'package:flutter/material.dart';

class AttendanceHeader extends StatelessWidget {
  const AttendanceHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          '출석체크',
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            height: 1.0,
          ),
        ),
        SizedBox(height: 8),
        Text(
          '건강 퀴즈 풀고 출석 체크하기',
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: Color(0xFF696969),
          ),
        ),
      ],
    );
  }
}
