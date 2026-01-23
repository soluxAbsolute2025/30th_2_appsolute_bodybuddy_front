import 'package:flutter/material.dart';

class HashtagEditingController extends TextEditingController {
  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final String content = text;
    final RegExp regExp = RegExp(r'#[^\s#]+|[^#]+');
    final matches = regExp.allMatches(content);

    List<TextSpan> spans = [];

    for (final match in matches) {
      final String word = match.group(0)!;

      if (word.startsWith('#')) {
        spans.add(
          TextSpan(
            text: word,
            style: style?.copyWith(
              color: const Color(0xFF18D9A2), // 민트색
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      } else {
        spans.add(TextSpan(text: word, style: style));
      }
    }
    return TextSpan(style: style, children: spans);
  }
}
