import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';

class FeedSearchWidget extends StatefulWidget {
  final Function({required String keyword}) onSearchFeed;
  final TextEditingController controller;

  const FeedSearchWidget({
    super.key,
    required this.onSearchFeed,
    required this.controller,
  });

  @override
  State<FeedSearchWidget> createState() => _FeedSearchState();
}

class _FeedSearchState extends State<FeedSearchWidget> {
  late FocusNode _focusNode;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose(); // 메모리 누수 방지
    super.dispose();
  }

  void _onSearchText() async {
    final value = widget.controller.text.trim();
    if (value.isEmpty || value.length < 2 || _isProcessing) return;

    setState(() => _isProcessing = true);

    await widget.onSearchFeed(keyword: value);

    setState(() => _isProcessing = false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: KeyboardListener(
        focusNode: _focusNode,
        onKeyEvent: (KeyEvent event) {
          if (event is KeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.enter) {
            _onSearchText();
          }
        },
        child: SearchBar(
          leading: Container(
            margin: EdgeInsets.only(left: 5.0, right: 5.0),
            child: SvgPicture.asset(
              'assets/buddyzone/search2222.svg',
              width: 15,
              height: 15,
            ),
          ),
          controller: widget.controller,
          onSubmitted: (_) {
            _onSearchText();
          },
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
        ),
      ),
    );
  }
}
