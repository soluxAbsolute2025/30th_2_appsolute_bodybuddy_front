import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FeedSearchWidget extends StatefulWidget {
  final Function({required String keyword}) onSearchFeed;

  const FeedSearchWidget({super.key, required this.onSearchFeed});

  @override
  State<FeedSearchWidget> createState() => _FeedSearchState();
}

class _FeedSearchState extends State<FeedSearchWidget> {
  TextEditingController textController = TextEditingController();

  void _onSearchText() async {
    String text = textController.text.trim();
    if (text.isEmpty || text.length < 2) return;

    await widget.onSearchFeed(keyword: text);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SearchBar(
        leading: Container(
          margin: EdgeInsets.only(left: 5.0, right: 5.0),
          child: SvgPicture.asset(
            'assets/buddyzone/search2222.svg',
            width: 15,
            height: 15,
          ),
        ),
        controller: textController,

        constraints: BoxConstraints(maxHeight: 40, minHeight: 40),
        backgroundColor: MaterialStatePropertyAll(Color(0xFFEFEFEF)),
        elevation: MaterialStatePropertyAll(0),
        hintText: '운동, 식단, 건강 관련 검색하기',
        hintStyle: MaterialStatePropertyAll(
          TextStyle(
            color: Color(0xFF949494),
            fontFamily: 'Pretendard',
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        textStyle: MaterialStatePropertyAll(
          TextStyle(
            color: Colors.black87,
            fontFamily: 'Pretendard',
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        onSubmitted: (value) {
          _onSearchText();
          textController.clear();
        },
      ),
    );
  }
}
