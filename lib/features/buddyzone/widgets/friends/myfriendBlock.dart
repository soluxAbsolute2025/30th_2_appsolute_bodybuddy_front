// features/home/widgets/home_content.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyfriendBlock extends StatelessWidget {
  const MyfriendBlock({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      // margin: EdgeInsets.symmetric(horizontal: 16.0),
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 6.0),
      child: Row(
        children: [
          SizedBox(
            width: 50.0,
            height: 50.0,
            child: ClipOval(
              child: Image(
                image: AssetImage('assets/images/common/profile1.jpg'),
              ),
            ),
          ),
          SizedBox(width: 16.0),
          Expanded(
            child: Column(
              children: <Widget>[
                Row(
                  children: [
                    Text(
                      '김헬스',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 10.0),
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
                            color: Color(0xFF1AEDB1),
                            fontSize: 11.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.0),
                Row(
                  children: [
                    Container(
                      child: Text(
                        textAlign: TextAlign.left,
                        '30분 전 활동',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 5.0),

            child: TextButton(
              onPressed: () {
                print("손 흔들기 클릭!");
              },
              style: TextButton.styleFrom(
                foregroundColor: Color(0x1188D3BD),
                padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
                minimumSize: Size.zero,
                tapTargetSize:
                    MaterialTapTargetSize.shrinkWrap, // 터치 영역을 내용물에 맞춤
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),

              child: Center(
                child: SvgPicture.asset(
                  'assets/images/common/hand.svg',
                  width: 16.0,
                  height: 21.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
