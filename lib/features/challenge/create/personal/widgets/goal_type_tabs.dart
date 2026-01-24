import 'package:flutter/material.dart';
import '../models/personal_challenge_create_model.dart'; 

class GoalTypeTabs extends StatelessWidget {
  final String value; // 'PERIOD' | 'COUNT'
  final ValueChanged<String> onChanged;

  const GoalTypeTabs({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    const active = Color(0xFF18D9A2);
    const inactive = Color(0xFF7D7C7C);
    const divider = Color(0xFFF5F5F5);

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _TabItem(
                text: '기간형',
                isActive: value == 'PERIOD',
                activeColor: active,
                inactiveColor: inactive,
                onTap: () => onChanged('PERIOD'),
              ),
            ),
            Expanded(
              child: _TabItem(
                text: '횟수형',
                isActive: value == 'COUNT',
                activeColor: active,
                inactiveColor: inactive,
                onTap: () => onChanged('COUNT'),
              ),
            ),
          ],
        ),

        LayoutBuilder(
          builder: (context, constraints) {
            final half = constraints.maxWidth / 2;

            return Stack(
              children: [
                Container(height: 1, color: divider),
                AnimatedAlign(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOut,
                  alignment:
                      value == 'PERIOD'
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                  child: Container(
                    width: half,
                    height: 3,
                    color: active,
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _TabItem extends StatelessWidget {
  final String text;
  final bool isActive;
  final Color activeColor;
  final Color inactiveColor;
  final VoidCallback onTap;

  const _TabItem({
    required this.text,
    required this.isActive,
    required this.activeColor,
    required this.inactiveColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: SizedBox(
        height: 52,
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isActive ? activeColor : inactiveColor,
            ),
          ),
        ),
      ),
    );
  }
}
