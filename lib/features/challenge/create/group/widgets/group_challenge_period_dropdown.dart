import 'package:flutter/material.dart';

class GroupChallengePeriodDropdown extends StatelessWidget {
  final int? value;
  final List<int> items;
  final ValueChanged<int?> onChanged;

  const GroupChallengePeriodDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      value: value,
      hint: const Text('최소 7일 이상으로 설정해 주세요'),
      items: items.map((d) => DropdownMenuItem(value: d, child: Text('$d일'))).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      ),
    );
  }
}
