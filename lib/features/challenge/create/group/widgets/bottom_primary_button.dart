import 'package:flutter/material.dart';

class BottomPrimaryButton extends StatelessWidget {
  final String text;
  final bool isEnabled;
  final VoidCallback onPressed;

  const BottomPrimaryButton({
    super.key,
    required this.text,
    required this.isEnabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton(
          onPressed: isEnabled ? onPressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                isEnabled ? const Color(0xFF1AEDB1) : const Color(0xFFD9D9D9),
            disabledBackgroundColor: const Color(0xFFD9D9D9),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
