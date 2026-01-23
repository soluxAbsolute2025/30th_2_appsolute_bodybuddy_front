import 'package:bodybuddy_frontend/common/widgets/sub_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MypageRangePage extends StatefulWidget {
  const MypageRangePage({super.key});

  @override
  State<MypageRangePage> createState() => _MypageRangePageState();
}

class _MypageRangePageState extends State<MypageRangePage> {
  bool _water = true;
  bool _fit = true;
  bool _food = true;
  bool _sleep = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SubAppbar(titleText: '공개 범위 설정'),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '친구들에게 공개할 정보를 선택해주세요',
                    style: TextStyle(
                      color: Color(0xFF7C7C7C),
                      fontSize: 12.0,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 25.0),
                  _rangeBlockWidget(
                    titleText: '수분 섭취량',
                    valueType: 'Water',
                    rageValue: _water,
                    imageUrl: 'assets/mypage/water.svg',
                    onChanged: (value) {
                      setState(() {
                        _water = value;
                      });
                    },
                  ),
                  Divider(color: Color(0xFFF5F5F5)),
                  _rangeBlockWidget(
                    titleText: '운동 기록',
                    valueType: 'Fit',
                    rageValue: _fit,
                    imageUrl: 'assets/mypage/fit.svg',
                    onChanged: (value) {
                      setState(() {
                        _fit = value;
                      });
                    },
                  ),
                  Divider(color: Color(0xFFF5F5F5)),
                  _rangeBlockWidget(
                    titleText: '식단 기록',
                    valueType: 'Food',
                    rageValue: _food,
                    imageUrl: 'assets/mypage/food.svg',
                    onChanged: (value) {
                      setState(() {
                        _food = value;
                      });
                    },
                  ),
                  Divider(color: Color(0xFFF5F5F5)),
                  _rangeBlockWidget(
                    titleText: '수면 기록',
                    valueType: 'Sleep',
                    rageValue: _sleep,
                    imageUrl: 'assets/mypage/sleep.svg',
                    onChanged: (value) {
                      setState(() {
                        _sleep = value;
                      });
                    },
                  ),
                  Divider(color: Color(0xFFF5F5F5)),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 30.0),
            alignment: Alignment.center,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              color: Color(0xFF1AEDB0),
            ),
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                foregroundColor: Color(0xFF669588),
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Container(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    '저장',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'Pretendard Variable',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _rangeBlockWidget({
    required String titleText,
    required String valueType,
    required bool rageValue,
    required String imageUrl,
    required Function(bool) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 64.0,
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 4.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 14.0,
                height: 14.0,
                alignment: Alignment.center,
                child: SvgPicture.asset(imageUrl, width: 14.0),
              ),
              SizedBox(width: 10.0),
              Expanded(
                child: Text(
                  titleText,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              _CustomSwitch(rageValue, onChanged: onChanged),
            ],
          ),
        ),
      ],
    );
  }

  Widget _CustomSwitch(bool _isEnable, {required Function(bool) onChanged}) {
    return GestureDetector(
      onTap: () => onChanged(!_isEnable),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 100),
        width: 42.0,
        height: 22.0,
        padding: const EdgeInsets.all(1.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(60.0),
          color: _isEnable ? Color(0xFF1AEDB1) : Color(0xFFD8D8D8),
        ),
        child: AnimatedAlign(
          duration: Duration(milliseconds: 100),
          alignment: _isEnable ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 20.0,
            height: 20.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
