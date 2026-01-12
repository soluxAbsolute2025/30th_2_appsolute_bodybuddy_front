import 'package:flutter/material.dart';

Future<void> showJoinGroupCodeDialog({
  required BuildContext context,
  required void Function(String code) onJoin,
}) async {
  final controller = TextEditingController();

  await showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '그룹 챌린지 참여',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 14),

              TextField(
                controller: controller,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: '그룹 코드 입력',
                  hintStyle: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 14,
                    color: Color(0xFF9C9C9C),
                  ),
                  isDense: true, 
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 10,  
                    horizontal: 4,
                  ),
                  border: InputBorder.none,
                ),
              ),

              const SizedBox(height: 14),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      '취소',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF9C9C9C),
                      ),
                    ),
                  ),
                  const SizedBox(width: 3),
                  TextButton(
                    onPressed: () {
                      final code = controller.text.trim();
                      if (code.isEmpty) return;

                      Navigator.pop(context);
                      onJoin(code);
                    },
                    child: const Text(
                      '참여',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF18D9A2),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );

  controller.dispose();
}
