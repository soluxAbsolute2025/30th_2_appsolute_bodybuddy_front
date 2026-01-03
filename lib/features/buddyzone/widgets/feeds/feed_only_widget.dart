import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FeedOnlyWidget extends StatelessWidget {
  const FeedOnlyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Color(0xFFD9D9D9), width: 1.0),
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: [
              SizedBox(
                width: 33.0,
                height: 33.0,
                child: ClipOval(
                  child: Image(
                    image: AssetImage('assets/images/common/profile1.jpg'),
                  ),
                ),
              ),
              SizedBox(width: 10.0),
              Expanded(
                child: Row(
                  children: [
                    Text(
                      '김헬스',
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'Pretendard',
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
                            fontFamily: 'Pretendard',
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 20.0),
                    SvgPicture.asset('assets/buddyzone/time.svg'),
                    SizedBox(width: 5.0),
                    Text(
                      '30분 전',
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF7D7C7C),
                        fontFamily: 'Pretendard',
                      ),
                    ),
                    SizedBox(width: 10.0),
                    SvgPicture.asset('assets/buddyzone/gps.svg'),
                    SizedBox(width: 5.0),
                    Text(
                      '헬스장',
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF7D7C7C),
                        fontFamily: 'Pretendard',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.0),
          Container(
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '오늘 스쿼트 100개 달성! 한 달 전만 해도 50개도 힘들었는데 꾸준히 하니까 늘었네요. 다들 화이팅!',
                    softWrap: true,
                    style: TextStyle(
                      fontSize: 12.0,
                      height: 1.5,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Pretendard',
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8.0),
          Row(
            children: [
              Text(
                '#텍스트',
                style: TextStyle(
                  fontSize: 12.0,
                  height: 1.5,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Pretendard',
                  color: Color(0xFF18D9A2),
                ),
              ),
              SizedBox(width: 8.0),
              Text(
                '#텍스트',
                style: TextStyle(
                  fontSize: 12.0,
                  height: 1.5,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF18D9A2),
                  fontFamily: 'Pretendard',
                ),
              ),
              SizedBox(width: 8.0),
            ],
          ),
          SizedBox(height: 16.0),
          Container(
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image(
                fit: BoxFit.fitWidth,
                image: AssetImage('assets/images/common/profile1.jpg'),
              ),
            ),
          ),
          SizedBox(height: 16.0),
          Row(
            children: [
              SvgPicture.asset(
                width: 24,
                height: 21,
                'assets/buddyzone/heart.svg',
              ),
              SizedBox(width: 8.0),
              Text('6'),
              SizedBox(width: 10.0),
              SvgPicture.asset(
                width: 20,
                height: 20,
                'assets/buddyzone/talk.svg',
              ),
              SizedBox(width: 8.0),
              Text('8'),
            ],
          ),
        ],
      ),
    );
  }
}
