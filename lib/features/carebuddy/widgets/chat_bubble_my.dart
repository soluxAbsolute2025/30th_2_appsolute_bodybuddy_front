import 'package:bodybuddy_frontend/common/widgets/realtime_text_widget.dart';
import 'package:bodybuddy_frontend/features/carebuddy/models/carebuddy_chat_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyChatBubble extends StatelessWidget {
  final ChatMessage message;

  const MyChatBubble({required this.message, super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(height: 25.0),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 19.0, vertical: 15.0),
            constraints: BoxConstraints(maxWidth: 300.0),
            decoration: BoxDecoration(
              color: Color(0xFF1AEDB0),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(0.0),
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
            ),
            child: Text(
              message.text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontFamily: 'Pretendard Variable',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 10.0),
          RealTimeText(dateTime: message.createdAt),
          SizedBox(height: 9.0),
        ],
      ),
    );
  }
}
