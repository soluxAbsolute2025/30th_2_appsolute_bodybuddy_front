import 'package:flutter/material.dart';

class FeedHottagWidget extends StatefulWidget {
  final List<String> hashList;
  final Function({required String tag}) onTagFeed;
  const FeedHottagWidget({
    super.key,
    required this.hashList,
    required this.onTagFeed,
  });

  @override
  State<FeedHottagWidget> createState() => _FeedHottagState();
}

class _FeedHottagState extends State<FeedHottagWidget> {
  int selectedIndex = -1;
  final List<String> _tags = ['다이어트', '홈트레이닝', '러닝', '요가', '필라테스'];

  @override
  void initState() {
    super.initState();
    // _tags.clear();
    _tags.addAll(widget.hashList);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '실시간 인기 태그',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.0),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: List.generate(_tags.length, (index) {
                bool isSelected = index == selectedIndex;
                return Container(
                  margin: EdgeInsets.only(right: 8.0),
                  decoration: BoxDecoration(
                    color: isSelected ? Color(0xFFE9FFF9) : Colors.transparent,
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(
                      color: isSelected ? Color(0xFF18D9A2) : Color(0xFFA7A7A7),
                      width: 1,
                    ),
                  ),
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        selectedIndex = index;
                      });
                      print("선택된 태그 : " + _tags[index]);
                      widget.onTagFeed(tag: _tags[index]);
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Color(0x1188D3BD),
                      padding: EdgeInsets.symmetric(
                        vertical: 6.0,
                        horizontal: 12.0,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    child: Text(
                      _tags[index],
                      style: TextStyle(
                        color: isSelected
                            ? Color(0xFF18D9A2)
                            : Color(0xFFA7A7A7),
                        fontSize: 12,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
