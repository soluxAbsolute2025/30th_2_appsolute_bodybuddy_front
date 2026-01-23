import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SubAppbar extends StatefulWidget implements PreferredSizeWidget {
  final String titleText;
  final String? imageUrl;
  final bool? isButton;
  final VoidCallback? onButtonPressed;
  final bool? isFormValid;
  final VoidCallback? onFormSubmit;

  const SubAppbar({
    super.key,
    this.titleText = '',
    this.onButtonPressed,
    this.imageUrl,
    this.isButton = false,
    this.isFormValid,
    this.onFormSubmit,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60.0);

  @override
  State<SubAppbar> createState() => _SubAppbarState();
}

// 2. State 클래스 구현
class _SubAppbarState extends State<SubAppbar> {
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
          padding: EdgeInsets.fromLTRB(0.0, 19.0, 40.0, 17.0),
          child: Text(
            widget.titleText,
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
      leading: TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap, // 터치 영역을 내용물에 맞춤
          foregroundColor: Color(0xFF87D2BD),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        child: Center(
          child: SvgPicture.asset(
            widget.imageUrl ?? 'assets/images/common/back.svg',
          ),
        ),
      ),
      actions: [
        if (widget.isButton == true)
          Container(
            margin: EdgeInsets.only(right: 16.0),
            child: TextButton(
              onPressed: widget.isFormValid! ? widget.onFormSubmit! : null,
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                backgroundColor: widget.isFormValid!
                    ? Color(0xFF1AEDB0)
                    : Color(0xFFE3E3E3),
                foregroundColor: Color(0xFF669588),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                elevation: 0,
              ),
              child: Text(
                '게시하기',
                style: TextStyle(
                  color: widget.isFormValid! ? Colors.white : Color(0xFFA8A8A8),
                  fontSize: 14,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
