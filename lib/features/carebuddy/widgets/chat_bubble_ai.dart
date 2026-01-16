import 'package:bodybuddy_frontend/features/carebuddy/models/carebuddy_chat_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AiChatBubble extends StatelessWidget {
  final ChatMessage message;

  const AiChatBubble({required this.message, super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36.0,
            height: 36.0,
            decoration: ShapeDecoration(
              color: const Color(0xFFF5F5F5),
              shape: CircleBorder(),
            ),
            child: Center(
              child: Container(
                width: 18.62,
                height: 24.35,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/common/main_logo.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 10.0),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            constraints: BoxConstraints(maxWidth: 300.0),
            decoration: BoxDecoration(
              color: Color(0xFFF5F5F5),

              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(0.0),
                topRight: Radius.circular(20.0),
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
            ),
            child: Text(
              "좋은 질문이에요! 제가 도움을 드리겠습니다. 건강 관련 정보를 제공하기 위해 최선을 다하고 있어요.",
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontFamily: 'Pretendard Variable',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            message.createdAt.toString(),
            style: TextStyle(
              color: const Color(0xFFA6A6A6),
              fontSize: 12,
              fontFamily: 'Pretendard Variable',
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
