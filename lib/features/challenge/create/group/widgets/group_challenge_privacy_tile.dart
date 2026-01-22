import 'package:flutter/material.dart';

class GroupChallengePrivacyTile extends StatelessWidget {
  final String value;
  final String title;
  final String subtitle;
  final String groupValue;
  final ValueChanged<String> onChanged;

  const GroupChallengePrivacyTile({
    super.key,
    required this.value,
    required this.title,
    required this.subtitle,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final selected = value == groupValue;

    return InkWell(
      onTap: () => onChanged(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? const Color(0xFFD8D8D8) : const Color(0xFFD8D8D8),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                const SizedBox(height: 6),
                Text(subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF7D7C7C))),
              ]),
            ),
            Radio<String>(
              value: value,
              groupValue: groupValue,
              onChanged: (v) => onChanged(v!),
              fillColor: WidgetStateProperty.resolveWith<Color>((states) {
                if (states.contains(WidgetState.selected)) {
                  return const Color(0xFF1AEDB1); 
                }
                return const Color(0xFFEFEFEF);
              }),
            ),
          ],
        ),
      ),
    );
  }
}
