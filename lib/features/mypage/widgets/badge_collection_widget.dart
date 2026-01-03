import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BadgeCollectionWidget extends StatelessWidget {
  const BadgeCollectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.all(16.0),
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
                  '뱃지 컬렉션',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Pretendard',
                  ),
                ),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.all(4.0),
                  minimumSize: Size(0, 0),
                ),
                child: Text(
                  '더보기',
                  style: TextStyle(
                    color: const Color(0xFFA7A7A7),
                    fontSize: 12,
                    fontFamily: 'Pretendard Variable',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 24.0, bottom: 30.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      SizedBox(
                        width: 90.0,
                        height: 90.0,
                        child: ClipOval(
                          child: Image(
                            image: AssetImage(
                              'assets/images/common/profile1.jpg',
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        '30일 챌린지',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: 'Pretendard Variable',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      SizedBox(
                        width: 90.0,
                        height: 90.0,
                        child: ClipOval(
                          child: Image(
                            image: AssetImage(
                              'assets/images/common/profile1.jpg',
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        '30일 챌린지',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: 'Pretendard Variable',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      SizedBox(
                        width: 90.0,
                        height: 90.0,
                        child: ClipOval(
                          child: Image(
                            image: AssetImage(
                              'assets/images/common/profile1.jpg',
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        '30일 챌린지',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: 'Pretendard Variable',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
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
