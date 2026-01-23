import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FeedTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final int minLines;
  final bool isImage;
  final Function(String)? onChanged;

  const FeedTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.minLines = 3,
    this.isImage = false,
    this.onChanged,
  });

  @override
  State<FeedTextField> createState() => _FeedTextFieldState();
}

class _FeedTextFieldState extends State<FeedTextField> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.isImage)
          Padding(
            padding: const EdgeInsets.only(top: 21, left: 16.0),
            child: SvgPicture.asset(
              widget.controller.text.isEmpty
                  ? 'assets/buddyzone/big_gps_false.svg'
                  : 'assets/buddyzone/big_gps_true.svg',
            ),
          ),
        Expanded(
          child: TextField(
            controller: widget.controller,
            onChanged: (value) {
              setState(() {}); // 내부 상태 갱신 (아이콘 변경 등)
              if (widget.onChanged != null) {
                widget.onChanged!(value);
              }
            },
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w400,
              height: 1.50,
            ),
            maxLines: null,
            minLines: widget.minLines,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: const TextStyle(
                color: Color(0xFFA6A6A6),
                fontSize: 16,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w500,
                height: 1.50,
              ),
              filled: true,
              fillColor: Colors.white,
              border: const OutlineInputBorder(borderSide: BorderSide.none),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
