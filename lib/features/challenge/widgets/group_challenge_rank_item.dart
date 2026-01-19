import 'package:flutter/material.dart';
import '../models/group_challenge_detail_model.dart';

class GroupChallengeRankItem extends StatelessWidget {
  final ChallengeRank rank;
  final int progress;

  const GroupChallengeRankItem({
    super.key,
    required this.rank,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final bool isMe = rank.isMe;
    final bool isFirst = rank.rank == 1;

    final Color backgroundColor = isMe
        ? const Color(0xFFE8FFF9)
        : isFirst
            ? const Color(0xFFFFFBB2)
            : Colors.white;

    final Color rankNumberColor =
        isFirst ? const Color(0xFF000000) : const Color(0xFF747474);

    final Color percentColor =
        (rank.rank <= 3) ? const Color(0xFF18D9A2) : const Color(0xFFA8A8A8);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(5),
        border: isFirst
            ? null
            : Border.all(
                color: isMe ? const Color(0xFF1AEDB1) : const Color(0xFFEBEBEB),
                width: 1,
              ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// 순위
          SizedBox(
            width: 18,
            child: Text(
              '${rank.rank}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: rankNumberColor,
              ),
            ),
          ),
          const SizedBox(width: 6),

          /// 프로필
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFD8D8D8),
              image: rank.profileImageUrl != null
                  ? DecorationImage(
                      image: NetworkImage(rank.profileImageUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
          ),
          const SizedBox(width: 8),

          /// 이름 + 프로그래스바
          Expanded(
            child: SizedBox(
              height: 34,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          rank.name,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: rank.isMe ? const Color(0xFF18D9A2) : Colors.black,
                          ),
                        ),
                      ),
                      Text(
                        '$progress%',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: (rank.rank <= 3)
                              ? const Color(0xFF18D9A2)
                              : const Color(0xFFA8A8A8),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  _RoundedLinearProgressBar(
                    value: progress / 100,
                    height: 6,
                    backgroundColor: const Color(0xFFDBDBDB),
                    foregroundColor: const Color(0xFF1AEDB1),
                    radius: 10,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 커스텀 바 위젯
class _RoundedLinearProgressBar extends StatelessWidget {
  final double value;
  final double height;
  final double radius;
  final Color backgroundColor;
  final Color foregroundColor;

  const _RoundedLinearProgressBar({
    required this.value,
    required this.height,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    final v = value.clamp(0.0, 1.0);

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final fullW = constraints.maxWidth;
          final fillW = fullW * v;

          return Stack(
            children: [
              Container(
                height: height,
                width: fullW,
                color: backgroundColor,
              ),
              Container(
                height: height,
                width: fillW,
                decoration: BoxDecoration(
                  color: foregroundColor,
                  borderRadius: BorderRadius.circular(radius),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
