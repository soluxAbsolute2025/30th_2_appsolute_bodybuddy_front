import 'package:bodybuddy_frontend/features/mypage/models/mypage_privacy_model.dart';
import 'package:bodybuddy_frontend/features/mypage/pages/mypage_myfeed_page.dart';
import 'package:bodybuddy_frontend/features/mypage/pages/mypage_passward_page.dart';
import 'package:bodybuddy_frontend/features/mypage/pages/mypage_profile_page.dart';
import 'package:bodybuddy_frontend/features/mypage/pages/mypage_range_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StatisticsSettingsWidget extends StatefulWidget {
  final Function() onBack;
  StatisticsSettingsWidget({super.key, required this.onBack});

  @override
  State<StatisticsSettingsWidget> createState() =>
      _StatisticsSettingsWidgetState();
}

class _StatisticsSettingsWidgetState extends State<StatisticsSettingsWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. 공개 범위 설정
          Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: _buildMenuRow(
              context,
              title: '공개 범위 설정',
              nextPage: MypageRangePage(),
            ),
          ),

          _buildDivider(), // 공통 구분선 함수 사용
          // 2. 내가 쓴 글
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: _buildMenuRow(
              context,
              title: '내가 쓴 글',
              nextPage: MypageMyfeedPage(),
            ),
          ),

          _buildDivider(), // 공통 구분선 함수 사용
          // 3. 비밀번호 설정 (마지막 아이템은 하단 패딩 추가)
          Padding(
            padding: const EdgeInsets.only(top: 16.0, bottom: 24.0),
            child: _buildMenuRow(
              context,
              title: '비밀번호 설정',
              nextPage: const MypagePasswardPage(),
            ),
          ),
        ],
      ),
    );
  }

  // ♻️ [재사용 위젯 1] 메뉴 한 줄 (텍스트 + 화살표)
  Widget _buildMenuRow(
    BuildContext context, {
    required String title,
    required Widget nextPage,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              fontFamily: 'Pretendard',
            ),
          ),
        ),
        TextButton(
          onPressed: () async {
            await Navigator.of(
              context,
              rootNavigator: true,
            ).push(MaterialPageRoute(builder: (context) => nextPage));

            if (context.mounted) {
              widget.onBack();
            }
          },
          style: TextButton.styleFrom(
            foregroundColor: const Color(0x1188D3BD),
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
          child: SvgPicture.asset(
            'assets/mypage/arrow.svg',
            width: 6.0,
            height: 10.0,
          ),
        ),
      ],
    );
  }

  // ♻️ [재사용 위젯 2] 구분선 세트 (간격 + 선)
  Widget _buildDivider() {
    return Column(
      children: const [
        SizedBox(height: 16.0),
        Divider(color: Color(0xFFF3F3F3)),
      ],
    );
  }
}
