import 'package:flutter/material.dart';

class RankBadge extends StatelessWidget {
  final int rank;

  const RankBadge({
    super.key,
    required this.rank,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 39,
      height: 26,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        gradient: _gradient,
        color: _gradient == null ? _solidColor : null,
        border: Border.all(
          color: _borderColor,
          width: 1,
        ),
      ),
      child: Text(
        '${rank}위',
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          height: 1.0,
        ),
      ),
    );
  }

  /// ===== 스타일 분기 =====

  Gradient? get _gradient {
    switch (rank) {
      case 1:
        return const LinearGradient(
          colors: [
            Color(0xFFFFEE00),
            Color(0xFFFFB200),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 2:
        return const LinearGradient(
          colors: [
            Color(0xFFB9B9B9),
            Color(0xFF838383),
            Color(0xFF535353),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 3:
        return const LinearGradient(
          colors: [
            Color(0xFFFFE28B),
            Color(0xFFC8853D),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      default:
        return null;
    }
  }

  Color get _solidColor {
    // 4위 이상
    return const Color(0xFFB9B9B9);
  }

  Color get _borderColor {
    switch (rank) {
      case 1:
        return const Color(0xFFFFBF00);
      case 3:
        return const Color(0xFFDEA969);
      default:
        return Colors.transparent;
    }
  }
}
