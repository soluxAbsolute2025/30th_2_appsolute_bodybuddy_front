import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Future<void> showJoinGroupCodeDialog({
  required BuildContext context,
  required void Function(String code) onJoin,
}) async {
  await showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: const Color(0x963A3A3A),
    builder: (dialogContext) {
      final controller = TextEditingController();

      return AlertDialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16.0),
        contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
        buttonPadding: EdgeInsets.zero,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        title: Column(
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  'assets/challenge/group_join.png',
                  width: 22.3,
                  height: 15.0,
                ),
                const SizedBox(width: 10.0),
                const Text(
                  '그룹 챌린지 참여',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Pretendard Variable',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
          ],
        ),
        content: Container(
          width: MediaQuery.of(dialogContext).size.width,
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          child: TextFormField(
            controller: controller,
            autofocus: true,
            style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
            decoration: InputDecoration(
              hintText: '그룹 코드 입력',
              hintStyle: const TextStyle(
                color: Color(0xFFA6A6A6),
                fontSize: 16.0,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w500,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 16,
              ),
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: Color(0xFFD8D8D8)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: Color(0xFF1AEDB0), width: 1),
              ),
            ),
            onFieldSubmitted: (_) => _submit(dialogContext, controller, onJoin),
          ),
        ),
        actions: [
          _dialogButton(
            text: '취소',
            onPressed: () => Navigator.of(dialogContext).pop(),
          ),
          const SizedBox(width: 8.0),
          _dialogButton(
            text: '참여',
            onPressed: () => _submit(dialogContext, controller, onJoin),
            isPrimary: true,
          ),
        ],
      );
    },
  );
}

void _submit(
  BuildContext dialogContext,
  TextEditingController controller,
  void Function(String code) onJoin,
) {
  final code = controller.text.trim();
  if (code.isEmpty) return;

  Navigator.of(dialogContext).pop();
  onJoin(code);
}

Widget _dialogButton({
  required String text,
  required VoidCallback onPressed,
  bool isPrimary = false,
}) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5.0),
      color: Colors.white,
    ),
    child: TextButton(
      style: TextButton.styleFrom(
        foregroundColor: const Color(0x1188D3BD),
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: Size.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          color: isPrimary ? const Color(0xFF17D8A1) : const Color(0xFF9C9C9C),
          fontSize: 14,
          fontFamily: 'Pretendard Variable',
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}
