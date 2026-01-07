import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
      backgroundColor: Color(0xFFFFFFFF),
      surfaceTintColor: Colors.transparent,
      titleSpacing: 0,
      title: SizedBox(
        height: 60.0,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.0, 19.0, 16.0, 17.0),
          child: Text(
            titleText,
            style: TextStyle(
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
        if (navIndex == 0 || navIndex == 1 || navIndex == 2)
          Container(
            margin: const EdgeInsets.only(right: 16.0),
            width: 35.0,
            height: 35.0,
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize:
                    MaterialTapTargetSize.shrinkWrap, // 터치 영역을 내용물에 맞춤
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              child: Center(child: SvgPicture.asset(imageUrl!, height: 20)),
            ),
          ),
      ],
    );
  }
}
