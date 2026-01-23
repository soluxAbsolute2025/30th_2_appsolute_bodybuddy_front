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
        final w = constraints.maxWidth;
        final p = progress.clamp(0.0, 1.0);
        final filledW = w * p;

        const endPadding = 2.0;
        const barH = 16.0;
        const thumb = 12.0;

        final isComplete = p >= 1.0;

        return SizedBox(
          height: barH,
          child: Stack(
            children: [
              /// 배경 바
              Container(
                height: barH,
                decoration: BoxDecoration(
                  color: const Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              /// 채워진 
              Container(
                height: barH,
                width: filledW,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              // 끝에 고정된 동그라미
              Positioned(
                left: w - thumb - endPadding,
                top: (barH - thumb) / 2,
                child: Container(
                  width: thumb,
                  height: thumb,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isComplete
                        ? const Color(0xFF00D0A6) 
                        : Colors.white,  
                    border: Border.all(
                      color: isComplete
                        ? const Color(0xFF00D0A6) 
                        : Colors.white,  
                      width: 2,
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
