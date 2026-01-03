import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EtcWidget extends StatelessWidget {
  const EtcWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      // constraints: BoxConstraints(maxHeight: 100.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  'Lv. 15',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Pretendard',
                  ),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: SvgPicture.asset(
                  'assets/mypage/arrow.svg',
                  width: 6.0,
                  height: 10.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
