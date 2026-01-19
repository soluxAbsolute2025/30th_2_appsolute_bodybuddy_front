import 'package:flutter/material.dart';

class PricePill extends StatelessWidget {
  final String text;
  final bool enabled;

  const PricePill({
    super.key,
    required this.text,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 84,
      height: 26,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: enabled ? const Color(0xFF1AEDB1) : const Color(0xFFE4E4E4),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: enabled ? Colors.white : const Color(0xFFA8A8A8),
        ),
      ),
    );
  }
}
