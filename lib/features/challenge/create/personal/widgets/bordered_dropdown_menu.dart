import 'package:flutter/material.dart';

class BorderedDropdownMenu<T> extends StatelessWidget {
  final List<DropdownMenuItem<T>> items;
  final Color borderColor;
  final ValueChanged<T> onSelected;
  final double maxHeight;

  const BorderedDropdownMenu({
    super.key,
    required this.items,
    required this.borderColor,
    required this.onSelected,
    this.maxHeight = 1000,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Material(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: borderColor, width: 1),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxHeight),
          child: ListView.separated(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: items.length,
            separatorBuilder: (_, __) => Divider(
              height: 1,
              thickness: 1,
              color: borderColor,
            ),
            itemBuilder: (context, i) {
              final item = items[i];
              final child = item.child;
              final text = (child is Text) ? (child.data ?? '') : '';

              return InkWell(
                onTap: () {
                  final v = item.value;
                  if (v != null) onSelected(v);
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  child: Text(
                    text,
                    style: const TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF111111),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
