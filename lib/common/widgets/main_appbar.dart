import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../features/bodylog/pages/alarm_setting_screen.dart';

class MainAppbar extends StatelessWidget implements PreferredSizeWidget {
  final int navIndex;
  final String titleText;
  final String? imageUrl;
  final String? buttonText;
  final VoidCallback? onButtonPressed;

  const MainAppbar({
    super.key,
    required this.navIndex,
    required this.titleText,
    this.imageUrl,
    this.buttonText,
    this.onButtonPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: const Color(0xFFFFFFFF),
      surfaceTintColor: Colors.transparent,
      titleSpacing: 0,
      title: SizedBox(
        height: 60.0,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 19.0, 16.0, 17.0),
          child: Text(
            titleText,
            style: const TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              height: 1.0,
              color: Colors.black,
            ),
          ),
        ),
      ),
      actions: [
        // ---------------------------------------------------------
        // CASE 1: 바디로그 탭 (navIndex == 1) -> 알람 설정 아이콘 표시
        // ---------------------------------------------------------
        if (navIndex == 1)
          Container(
            margin: const EdgeInsets.only(right: 16.0),
            width: 35.0,
            height: 35.0,
            child: IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(), // 아이콘 버튼의 불필요한 여백 제거
              // 디자인 시안(바디로그)에 있는 시계 아이콘 사용
              icon: const Icon(Icons.access_time, color: Colors.black, size: 24),
              onPressed: () {
                // 알람 설정 화면으로 이동
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AlarmSettingScreen(),
                  ),
                );
              },
            ),
          ),

        // ---------------------------------------------------------
        // CASE 2: 홈 탭 (navIndex == 0) -> 알림 벨 아이콘 (기존 이미지 사용 시)
        // ---------------------------------------------------------
        if (navIndex == 0)
          Container(
            margin: const EdgeInsets.only(right: 16.0),
            width: 35.0,
            height: 35.0,
            child: TextButton(
              onPressed: onButtonPressed ?? () {}, // 홈 탭의 버튼 동작
              style: TextButton.styleFrom(
                foregroundColor: Color(0xFF88D3BD),
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              child: Center(
                // imageUrl이 있으면 이미지 표시, 없으면 기본 아이콘(벨) 표시 (에러 방지)
                child: imageUrl != null
                    ? SvgPicture.asset(imageUrl!, height: 20)
                    : const Icon(Icons.notifications_none, color: Colors.black),
              ),
            ),
          ),
      ],
    );
  }
}
