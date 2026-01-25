import 'package:bodybuddy_frontend/features/mypage/models/mypage_info_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BadgeCollectionWidget extends StatefulWidget {
  MyPageResponse? myPageInfo;
  Function() onBack;
  BadgeCollectionWidget({
    super.key,
    required this.myPageInfo,
    required this.onBack,
  });

  @override
  State<BadgeCollectionWidget> createState() => _BadgeCollectionWidgetState();
}

class _BadgeCollectionWidgetState extends State<BadgeCollectionWidget> {
  @override
  Widget build(BuildContext context) {
    final badgeList = widget.myPageInfo?.recentBadges ?? [];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Row(
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
                  onPressed: () async {
                    // await Navigator.of(context, rootNavigator: true).push(
                    //   MaterialPageRoute(
                    //     builder: (context) =>
                    //         MypageProfilePage(myPageInfo: widget.myPageInfo),
                    //   ),
                    // );
                    //
                    // if (context.mounted) {
                    //   widget.onBack();
                    // }
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Color(0x1188D3BD),
                    padding: EdgeInsets.symmetric(
                      horizontal: 4.0,
                      vertical: 2.0,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize:
                        MaterialTapTargetSize.shrinkWrap, // 터치 영역을 내용물에 맞춤
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  child: Center(
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
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 24.0, bottom: 30.0),
            child: Row(
              children: badgeList.isEmpty
                  ? [Expanded(child: _nullCommentText())]
                  : List.generate(3, (index) {
                      if (index < badgeList.length) {
                        return _bedgeWidget(
                          badgeList[index].badgeImageUrl,
                          badgeList[index].badgeName,
                        );
                      } else {
                        return const Expanded(child: SizedBox(height: 127.0));
                      }
                    }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bedgeWidget(String imageUrl, String title) {
    return Expanded(
      child: Column(
        children: [
          SizedBox(
            width: 90.0,
            height: 90.0,
            child: ClipOval(
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(color: Colors.grey[200]);
                },
              ),
            ),
          ),
          SizedBox(height: 16.0),
          Text(
            title,
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontFamily: 'Pretendard Variable',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _nullCommentText() {
    return Container(
      padding: EdgeInsets.only(bottom: 16.0),
      height: 127.0,
      alignment: Alignment.center,
      child: Text(
        '아직 뱃지가 없어요\n'
        '경험치를 얻어 뱃지를 획득해보세요',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: const Color(0xFFA6A6A6),
          fontSize: 14,
          fontFamily: 'Pretendard Variable',
          fontWeight: FontWeight.w400,
          height: 1.50,
        ),
      ),
    );
  }
}
