import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PointsCard extends StatelessWidget {
  final int points;

  const PointsCard({
    super.key,
    required this.points,
  });

  @override
  Widget build(BuildContext context) {
    final formatted =
        NumberFormat.decimalPattern('ko_KR').format(points);

    return Container(
      height: 61,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFFFDFAD4),
            Color(0xFFE9FFF9),
          ],
        ),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              '사용 가능한 포인트',
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Text(
            '${formatted}P',
            style: const TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}
