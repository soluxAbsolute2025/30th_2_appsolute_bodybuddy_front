import 'package:bodybuddy_frontend/common/widgets/realtime_text_widget.dart';
import 'package:bodybuddy_frontend/features/carebuddy/models/carebuddy_chat_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AiChatBubble extends StatelessWidget {
  final ChatMessage message;

  const AiChatBubble({required this.message, super.key});

  List<TextSpan> _buildTextSpans(String text) {
    final parts = text.split('**');

    return List.generate(parts.length, (index) {
      final isBold = index.isOdd;

      return TextSpan(
        text: parts[index],
        style: TextStyle(
          fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
          color: Colors.black,
          fontSize: 14,
          fontFamily: 'Pretendard Variable',
        ),
      );
    });
  }

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
            child: RichText(
              text: TextSpan(
                children: _buildTextSpans(
                  message?.text ??
                      "**좋은 질문**이에요! 제가 도움을 드리겠습니다. 건강 관련 정보를 제공하기 위해 최선을 다하고 있어요.",
                ),
              ),
            ),
          ),
          SizedBox(height: 10.0),
          RealTimeText(dateTime: message.createdAt),
        ],
      ),
    );
  }
}
