import 'package:flutter/material.dart';

class BottomPrimaryButton extends StatelessWidget {
  final String label;
  final bool enabled;
  final VoidCallback onPressed;

  const BottomPrimaryButton({
    super.key,
    required this.label,
    required this.enabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: SizedBox(
        width: double.infinity,
        height: 44,
        child: ElevatedButton(
          onPressed: enabled ? onPressed : null,
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: const Color(0xFF1AEDB1),
            disabledBackgroundColor: const Color(0xFFE4E4E4),
            splashFactory: NoSplash.splashFactory,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: enabled
                  ? Colors.white
                  : const Color(0xFFA8A8A8),
            ),
          ),
        ),
      ),
    );
  }
}
