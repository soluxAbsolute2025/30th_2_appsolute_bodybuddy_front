import 'package:bodybuddy_frontend/common/widgets/sub_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../widgets/feeds/feed_only_widget.dart';
import '../../widgets/feeds/feed_comment_widget.dart';
import '../../../../common/widgets/sub_appbar.dart';

class SubNewFeedPages extends StatefulWidget {
  const SubNewFeedPages({super.key});

  @override
  State<SubNewFeedPages> createState() => _SubNewFeedPagesState();
}

class _SubNewFeedPagesState extends State<SubNewFeedPages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SubAppbar(imageUrl: 'assets/buddyzone/xFeed.svg', isButton: true),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 16.0, right: 16.0),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 37.0,
                          height: 37.0,
                          child: ClipOval(
                            child: Image(
                              image: AssetImage(
                                'assets/images/common/profile1.jpg',
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10.0),
                        Row(
                          children: [
                            Text(
                              '김헬스',
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontFamily: 'Pretendard',
                              ),
                            ),
                            SizedBox(width: 10.0),
                            Container(
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
                            SizedBox(width: 20.0),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 3.0),
                  Container(
                    margin: EdgeInsets.only(left: 49.0, right: 16.0),
                    child: TextField(
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w400,
                        height: 1.50,
                      ),
                      maxLines: null,
                      minLines: 10,
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
                        hintText: '오늘은 어떤 운동을 했나요? 친구들과 공유해 보세요!',
                        hintStyle: TextStyle(
                          color: const Color(0xFFA6A6A6),
                          fontSize: 16,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w500,
                          height: 1.50,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(borderSide: BorderSide.none),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Color(0xFFE8E8E8), width: 1.0),
              ),
            ),
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 10.0),
                  width: 40.0,
                  height: 40.0,
                  child: TextButton(
                    onPressed: () {
                      print("사진 버튼 클릭");
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Color(0x1188D3BD),
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize:
                          MaterialTapTargetSize.shrinkWrap, // 터치 영역을 내용물에 맞춤
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/buddyzone/pictureFeed.svg',
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 10.0),
                  width: 40.0,
                  height: 40.0,
                  child: TextButton(
                    onPressed: () {
                      print("장소 입력 버튼 클릭");
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Color(0x1188D3BD),
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize:
                          MaterialTapTargetSize.shrinkWrap, // 터치 영역을 내용물에 맞춤
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    child: Center(
                      child: SvgPicture.asset('assets/buddyzone/gpsFeed.svg'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _nullCommentText() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 70.0),
      child: Text(
        '아직 댓글이 없어요\n'
        '가장 먼저 댓글을 남겨보세요',
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
