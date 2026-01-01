import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'body_progress_bar.dart';

class MetricRow extends StatelessWidget {
  final String iconPath;
  final String label;
  final String unitText;
  final double progress;

  const MetricRow({
    super.key,
    required this.iconPath,
    required this.label,
    required this.unitText,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    const activeColor = Color(0xFF1AEDB1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  iconPath,
                  width: 13,
                  height: 13,
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            /// 오른쪽 (수치)
            Text(
              unitText,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Color(0xFF7D7C7C),
              ),
            ),
          ],
        ),

        const SizedBox(height: 6),

        /// 프로그래스 바
        BodyProgressBar(
          progress: progress,
          color: activeColor,
        ),
      ],
    );
  }
}

/// 우측 상단 상태 점 3개
class StatusDots extends StatelessWidget {
  final int completedCount; // 0~3

  const StatusDots({
    super.key,
    required this.completedCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(3, (index) {
        final active = index < completedCount;

        return Padding(
          padding: const EdgeInsets.only(left: 6),
          child: Container(
            width: 15,
            height: 15,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: active
                  ? const Color(0xFF1AEDB1)
                  : const Color(0xFFF5F5F5),
            ),
            child: active
                ? const Icon(Icons.check, size: 12, color: Colors.white)
                : null,
          ),
        );
      }),
    );
  }
}
