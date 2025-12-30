import 'package:flutter/material.dart';

class ChallengeFloatingButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ChallengeFloatingButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 0, bottom: 50),
      child: SizedBox(
        width: 96,
        height: 35,
        child: FloatingActionButton.extended(
          onPressed: onPressed,
          backgroundColor: const Color(0xFF1AEDB1),

          // hover / 효과 제거
          elevation: 1,
          hoverElevation: 0,
          highlightElevation: 0,
          focusElevation: 0,
          splashColor: Colors.transparent,
          enableFeedback: false,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(69),
          ),
          icon: const Icon(
            Icons.add,
            size: 15,
            color: Colors.white,
          ),
          label: const Text(
            '새 챌린지',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          extendedPadding: const EdgeInsets.symmetric(horizontal: 0),
        ),
      ),
    );
  }
}
