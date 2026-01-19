import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class CarebuddyBottomButtons extends StatelessWidget {
  const CarebuddyBottomButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _subtag(
          '운동',
          'assets/carebuddy/tag1.svg',
          0xFFDFFEFF,
          0xFF86DBDD,
          0xFF00AEFF,
          url: 'https://www.youtube.com/?app=desktop&hl=ko&gl=KR',
        ),
        _subtag(
          '영양',
          'assets/carebuddy/tag2.svg',
          0xFFDDFFE3,
          0xFF87E597,
          0xFF00D346,
          url: 'https://www.youtube.com/?app=desktop&hl=ko&gl=KR',
        ),
        _subtag(
          '질병',
          'assets/carebuddy/tag3.svg',
          0xFFFFDFDB,
          0xFFD78E83,
          0xFFEA441A,
          url: 'https://www.youtube.com/?app=desktop&hl=ko&gl=KR',
        ),
        _subtag(
          '정신 건강',
          'assets/carebuddy/tag4.svg',
          0xFFF8DFFF,
          0xFFB67DC4,
          0xFF9000FF,
          url: 'https://www.youtube.com/?app=desktop&hl=ko&gl=KR',
        ),
      ],
    );
  }

  Widget _subtag(
    String text,
    String imageUrl,
    int backgroundcolor,
    int foregroundcolor,
    int textColor, {
    String url = '',
    bool isSelected = false,
  }) {
    return Row(
      children: [
        TextButton(
          onPressed: () {
            _launchInBrowser(Uri.parse(url));
          },
          style: TextButton.styleFrom(
            foregroundColor: Color(foregroundcolor),
            backgroundColor: Color(backgroundcolor),
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),

            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          child: Row(
            children: [
              SvgPicture.asset(imageUrl),
              SizedBox(width: 10.0),
              Text(
                text,
                style: TextStyle(
                  color: Color(textColor),
                  fontSize: 14,
                  fontFamily: 'Pretendard Variable',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 10.0),
      ],
    );
  }

  // 외부 웹 링크 연결하기
  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.inAppBrowserView)) {
      throw Exception('Could not launch $url');
    }
  }
}
