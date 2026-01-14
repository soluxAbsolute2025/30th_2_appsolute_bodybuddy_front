import 'package:flutter/material.dart';

class LabeledDropdown<T> extends StatelessWidget {
  final String label;
  final String hint;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  const LabeledDropdown({
    super.key,
    required this.label,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    const borderColor = Color(0xFFD8D8D8);

    final safeValue = items.any((e) => e.value == value) ? value : null;

    final baseBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: borderColor, width: 1),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF000000),
          ),
        ),
        const SizedBox(height: 8),

        SizedBox(
          height: 55,
          child: Theme(
            data: Theme.of(context).copyWith(
              inputDecorationTheme: const InputDecorationTheme(
                filled: true,
                fillColor: Colors.white,
              ),
              canvasColor: Colors.white,
            ),
            child: DropdownButtonFormField<T>(
              value: safeValue,
              isExpanded: true,
              icon: Image.asset(
                'assets/challenge/dropdown.png',
                width: 15,
                height: 15,
              ),
              hint: Text(
                hint,
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFA6A6A6),
                ),
              ),
              style: const TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF111111),
              ),
              items: items,
              onChanged: onChanged,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
                enabledBorder: baseBorder,
                border: baseBorder,
                focusedBorder: baseBorder,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
