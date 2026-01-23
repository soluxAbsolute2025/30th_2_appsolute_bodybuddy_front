import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CarebuddyTopContent extends StatelessWidget {
  const CarebuddyTopContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 41.0,
          height: 41.0,
          decoration: ShapeDecoration(
            color: const Color(0xFFF5F5F5),
            shape: CircleBorder(),
          ),
          child: Center(
            child: Container(
              width: 21,
              height: 28,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/common/main_logo.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 14.0),
        Text(
          '안녕하세요, 케어버디입니다!\n무엇을 도와드릴까요?',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w500,
            height: 1.50,
          ),
        ),
        SizedBox(height: 14.0),
      ],
    );
  }
}
