import 'package:flutter/material.dart';

Future<void> showChallengeVerifyCompleteModal({
  required BuildContext context,
  required int point,
  VoidCallback? onClosed, // ✅ 추가
}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      bool isHover = false;

      void close() {
        Navigator.of(dialogContext, rootNavigator: true).pop(); // ✅ dialogContext 사용
        onClosed?.call(); // ✅ 다음 모달 트리거
      }

      return Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.17),
                  blurRadius: 8.9,
                  spreadRadius: -1,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Spacer(),
                    StatefulBuilder(
                      builder: (context, setState) {
                        return MouseRegion(
                          onEnter: (_) => setState(() => isHover = true),
                          onExit: (_) => setState(() => isHover = false),
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: close, // ✅ 여기만 변경
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: isHover
                                    ? Border.all(
                                        color: Colors.black.withOpacity(0.15),
                                        width: 1,
                                      )
                                    : null,
                              ),
                              child: Image.asset(
                                'assets/challenge/close.png',
                                width: 12,
                                height: 12,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF1AEDB1),
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 25),
                ),
                const SizedBox(height: 16),
                const Text(
                  '챌린지 인증이 완료되었습니다!',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF000000),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  '$point 포인트를 획득하였습니다',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF7D7C7C),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      );
    },
  );
}
