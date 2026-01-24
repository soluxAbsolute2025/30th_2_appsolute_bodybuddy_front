import 'package:flutter/material.dart';
import 'bordered_dropdown_menu.dart';

class LabeledDropdown<T> extends StatefulWidget {
  final String label;
  final String hint;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final VoidCallback? onOpen;

  const LabeledDropdown({
    super.key,
    required this.label,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
    this.onOpen,
  });

  @override
  State<LabeledDropdown<T>> createState() => _LabeledDropdownState<T>();
}

class _LabeledDropdownState<T> extends State<LabeledDropdown<T>> {
  bool _open = false;
  final _fieldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    const borderColor = Color(0xFFD8D8D8);

    final safeValue =
        widget.items.any((e) => e.value == widget.value) ? widget.value : null;

    String? selectedText;
    if (safeValue != null) {
      final match = widget.items.firstWhere((e) => e.value == safeValue);
      if (match.child is Text) selectedText = (match.child as Text).data;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF000000),
          ),
        ),
        const SizedBox(height: 8),

        SizedBox(
          key: _fieldKey,
          height: 55,
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () async {
              setState(() => _open = !_open);

              if (_open) {
                widget.onOpen?.call();

                await Future.delayed(const Duration(milliseconds: 0));
                final ctx = _fieldKey.currentContext;
                if (ctx != null) {
                  Scrollable.ensureVisible(
                    ctx,
                    duration: const Duration(milliseconds: 0),
                    curve: Curves.easeOut,
                    alignment: 0.0,
                  );
                }
              }
            },
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            child: InputDecorator(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: borderColor, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: borderColor, width: 1),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      selectedText ?? widget.hint,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: selectedText == null
                            ? const Color(0xFFA6A6A6)
                            : const Color(0xFF111111),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  AnimatedRotation(
                    duration: const Duration(milliseconds: 0),
                    turns: _open ? 0.0 : 0.0,
                    child: Image.asset(
                      'assets/challenge/dropdown.png',
                      width: 15,
                      height: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        AnimatedSize(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          alignment: Alignment.topLeft,
          child: _open
              ? Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: BorderedDropdownMenu<T>(
                    items: widget.items,
                    borderColor: borderColor,
                    onSelected: (v) {
                      widget.onChanged(v);
                      setState(() => _open = false);
                    },
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
