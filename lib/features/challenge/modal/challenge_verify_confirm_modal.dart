import 'package:flutter/material.dart';

Future<bool?> showChallengeVerifyConfirmModal({
  required BuildContext context,
  required String challengeTitle,

  /// ✅ 여기서는 "API만" 호출하는 게 깔끔함 (완료모달은 밖에서)
  required Future<void> Function() onConfirm,
}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
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
                const Text(
                  '챌린지 인증',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                const Divider(height: 1, thickness: 1, color: Color(0xFFF5F5F5)),
                const SizedBox(height: 30),
                const Text(
                  '오늘의 챌린지 활동을 인증할까요?',
                  style: TextStyle(fontSize: 16, color: Color(0xFF000000)),
                ),
                const SizedBox(height: 8),
                Text(
                  challengeTitle,
                  style: const TextStyle(fontSize: 12, color: Color(0xFF7D7C7C)),
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child: OutlinedButton(
                          // ✅ 취소 = false 리턴
                          onPressed: () => Navigator.of(dialogContext, rootNavigator: true).pop(false),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFEFEFEF)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          child: const Text(
                            '취소',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF000000),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 44,
                        child: ElevatedButton(
                          onPressed: () async {
                            try {
                              // ✅ API 호출
                              await onConfirm();

                              // ✅ 성공 = true 리턴
                              if (dialogContext.mounted) {
                                Navigator.of(dialogContext, rootNavigator: true).pop(true);
                              }
                            } catch (e) {
                              if (dialogContext.mounted) {
                                ScaffoldMessenger.of(dialogContext).showSnackBar(
                                  SnackBar(content: Text('인증에 실패했어요: $e')),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1AEDB1),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          child: const Text(
                            '인증하기',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
