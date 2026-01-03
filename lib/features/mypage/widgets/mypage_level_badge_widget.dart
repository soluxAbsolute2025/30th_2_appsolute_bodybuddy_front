import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../widgets/mypage_level_widget.dart';

class MypageLevelBadgeWidget extends StatelessWidget {
  const MypageLevelBadgeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      // constraints: BoxConstraints(maxHeight: 100.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
        boxShadow: [
          BoxShadow(
            color: Color(0x1C000000),
            blurRadius: 4,
            offset: Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 37.0,
                width: 37.0,
                child: Image(
                  image: AssetImage('assets/images/common/profile1.jpg'),
                ),
              ),
              SizedBox(width: 13.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Lv. 15',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Pretendard',
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Text(
                    '챌린지 버디',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Pretendard',
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16.0),
          MypageLevelWidget(),
        ],
      ),
    );
  }
}
