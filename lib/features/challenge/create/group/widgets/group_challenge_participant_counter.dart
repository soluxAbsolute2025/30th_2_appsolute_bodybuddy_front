import 'package:flutter/material.dart';

class GroupChallengeParticipantCounter extends StatelessWidget {
  final int value;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  const GroupChallengeParticipantCounter({
    super.key,
    required this.value,
    required this.onDecrease,
    required this.onIncrease,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _IconButton(
          assetPath: 'assets/challenge/minus.png',
          onTap: onDecrease,
        ),
        const SizedBox(width: 8),
        Text(
          '$value',
          style: const TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        const SizedBox(width: 8),
        _IconButton(
          assetPath: 'assets/challenge/plus.png',
          onTap: onIncrease,
        ),
      ],
    );
  }
}

class _IconButton extends StatelessWidget {
  final String assetPath;
  final VoidCallback onTap;

  const _IconButton({
    required this.assetPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: SizedBox(
        width: 40,
        height: 40,
        child: Center(
          child: Image.asset(
            assetPath,
            width: 34,
            height: 234,
          ),
        ),
      ),
    );
  }
}
