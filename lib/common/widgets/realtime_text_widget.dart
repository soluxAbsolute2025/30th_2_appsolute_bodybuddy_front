import 'dart:async';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:bodybuddy_frontend/features/carebuddy/providers/custom_ko_messages.dart';

class RealTimeText extends StatefulWidget {
  final DateTime dateTime;
  const RealTimeText({super.key, required this.dateTime});

  @override
  State<RealTimeText> createState() => _RealTimeTextState();
}

class _RealTimeTextState extends State<RealTimeText> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    timeago.setLocaleMessages('ko_custom', MyCustomKomassages());
    // 1분마다 화면을 다시 그리도록 타이머 설정
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      timeago.format(widget.dateTime, locale: 'ko_custom'),
      style: const TextStyle(
        color: const Color(0xFFA6A6A6),
        fontSize: 12,
        fontFamily: 'Pretendard Variable',
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
