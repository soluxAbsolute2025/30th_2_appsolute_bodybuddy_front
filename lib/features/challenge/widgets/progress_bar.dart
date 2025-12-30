import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final double value;

  const ProgressBar({
    super.key,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final progress = value.clamp(0.0, 1.0);

    return Container(
      height: 8,
      decoration: BoxDecoration(
        color: const Color(0xFF1AEDD1), 
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Align(
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: progress,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFFF43D), 
                borderRadius: BorderRadius.horizontal(
                  left: const Radius.circular(8),
                  right: Radius.circular(progress > 0.95 ? 8 : 8),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
