import 'package:bodybuddy_frontend/features/mypage/models/mypage_info_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MypageLevelWidget extends StatefulWidget {
  final int? userVal;
  final int? maxVal;
  LevelInfo? levelInfo;

  MypageLevelWidget({
    super.key,
    this.userVal = 1,
    this.maxVal = 3,
    required this.levelInfo,
  });

  @override
  State<MypageLevelWidget> createState() => _MypageLevelWidgetState();
}

class _MypageLevelWidgetState extends State<MypageLevelWidget> {
  @override
  Widget build(BuildContext context) {
    int level = widget.levelInfo!.currentExp.toInt() - widget.userVal!.toInt();

    double ratio =
        widget.levelInfo!.currentExp / widget.levelInfo!.nextLevelExp;

    return Column(
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
              '${widget.levelInfo!.remainingExp} XP',
              style: TextStyle(
                color: Color(0xFF1AEDB0),
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
          alignment: Alignment.centerLeft,
          height: 10.0,
          decoration: BoxDecoration(
            color: Color(0xFFEBEBEB),
            borderRadius: BorderRadius.circular(10.0),
          ),
          // 경험치 비율에 맞게 조정
          child: FractionallySizedBox(
            widthFactor: ratio,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFF1AEDB0),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
        ),
        SizedBox(height: 8.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${widget.levelInfo!.currentExp}XP',
              style: TextStyle(
                color: Color(0xFF7D7C7C),
                fontSize: 12,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              '${widget.levelInfo!.nextLevelExp}XP',
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
    );
  }
}
