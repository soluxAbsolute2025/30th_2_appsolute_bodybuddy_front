// features/home/widgets/home_content.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FriendrequestBlock extends StatefulWidget {
  const FriendrequestBlock({super.key});

  @override
  State<FriendrequestBlock> createState() => _FriendrequestState();
}

class _FriendrequestState extends State<FriendrequestBlock> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(10.0),
      ),
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
            padding: EdgeInsets.only(right: 10.0),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    print("수락 클릭!");
                  },
                  borderRadius: BorderRadius.circular(5.0),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 6.0,
                      horizontal: 14.0,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: Color(0xFF1AEDB1),
                    ),
                    child: Center(
                      child: Text(
                        '수락',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 5.0),
                InkWell(
                  onTap: () {
                    print("x 클릭!");
                  },
                  borderRadius: BorderRadius.circular(5.0),
                  splashColor: Colors.black12,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 8.0,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: Color(0xDBFFFFFF),
                    ),
                    child: Center(
                      child: SvgPicture.asset('assets/images/common/x.svg'),
                    ),
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
