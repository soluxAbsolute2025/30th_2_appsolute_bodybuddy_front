import 'package:flutter/material.dart';

class ChallengeScopeToggle extends StatelessWidget {
  /// true = 개인, false = 그룹
  final bool isPersonalSelected;
  final ValueChanged<bool> onChanged;

  const ChallengeScopeToggle({
    super.key,
    required this.isPersonalSelected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 49,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: Color(0xFFF8F8F8),
      ),
      child: Row(
        children: [
          const Text(
            '챌린지 규모',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              height: 1.0,
              letterSpacing: 0,
              color: Colors.black,
            ),
          ),

          const Spacer(),

          Row(
            children: [
              _ScopeButton(
                label: '개인',
                isSelected: isPersonalSelected,
                onTap: () => onChanged(true),
              ),
              const SizedBox(width: 4),
              _ScopeButton(
                label: '그룹',
                isSelected: !isPersonalSelected,
                onTap: () => onChanged(false),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ScopeButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ScopeButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 64,
          height: 25,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: isSelected
                ? null
                : Border.all(
                    width: 0.7,
                    color: const Color(0xFFDBDBDB),
                  ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              height: 1.0,
              color:
                  isSelected ? Colors.white : const Color(0xFFDBDBDB),
            ),
          ),
        ),
      ),
    );
  }
}
