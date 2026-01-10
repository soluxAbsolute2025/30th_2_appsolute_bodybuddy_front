import 'package:flutter/material.dart';

class BodyProgressBar extends StatelessWidget {
  final double progress; // 0.0 ~ 1.0
  final Color color;

  const BodyProgressBar({
    super.key,
    required this.progress,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final barWidth = constraints.maxWidth;
        final clampedProgress = progress.clamp(0.0, 1.0);
        final filledWidth = barWidth * clampedProgress;

        const thumbSize = 16.0;
        final maxLeft = barWidth - thumbSize;

        const thumbOffset = 2.0;
        final thumbLeft =
            (filledWidth - thumbSize / 2 - thumbOffset).clamp(0.0, maxLeft);

        final isComplete = clampedProgress >= 1.0;

        return SizedBox(
          height: 16,
          child: Stack(
            children: [
              /// 배경 바
              Container(
                height: 16,
                decoration: BoxDecoration(
                  color: const Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              /// 채워진 바
              Container(
                height: 16,
                width: filledWidth,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              /// 끝 동그라미
              Positioned(
                left: thumbLeft,
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: thumbSize,
                    height: thumbSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isComplete
                          ? const Color(0xFF00D0A6)
                          : Colors.white,
                      border: Border.all(color: color, width: 2),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
