import 'package:flutter/material.dart';

class RewardActionBar extends StatelessWidget {
  final int xp;
  final bool enabled;
  final VoidCallback onPressed;

  const RewardActionBar({
    super.key,
    required this.xp,
    required this.enabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// 왼쪽 텍스트
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '챌린지 난이도와 기간에 따라 자동 계산됩니다',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF7D7C7C),
                    ),
                  ),
                  const SizedBox(height: 4),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF111111),
                      ),
                      children: [
                        const TextSpan(text: '예상 보상 경험치   '),
                        TextSpan(
                          text: '${xp}XP',
                          style: const TextStyle(
                            color: Color(0xFF1AEDB1),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            /// 오른쪽 버튼
            SizedBox(
              width: 110,
              height: 44,
              child: ElevatedButton(
                onPressed: enabled ? onPressed : null,
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: const Color(0xFF1AEDB1),
                  disabledBackgroundColor: const Color(0xFFE6E6E6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  '다음',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: enabled ? Colors.white : const Color(0xFFBDBDBD),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
