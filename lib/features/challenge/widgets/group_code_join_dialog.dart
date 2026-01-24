import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../api/group_join_api.dart';

Future<void> showJoinGroupCodeDialog({
  required BuildContext context,
  required void Function(int challengeId) onMoveToChallenge, // 이동 콜백
}) async {
  final controller = TextEditingController();
  final api = GroupJoinApi();

  Future<void> _showError(String msg) async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  await showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: const Color(0x963A3A3A),
    builder: (dialogContext) {
      return AlertDialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16.0),
        contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
        buttonPadding: EdgeInsets.zero,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        title: Column(
          children: const [
            Row(
              children: [
                Text(
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
            SizedBox(height: 10.0),
          ],
        ),
        content: Container(
          width: MediaQuery.of(dialogContext).size.width,
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          child: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: '그룹 코드 입력',
              hintStyle: TextStyle(
                fontFamily: 'Pretendard Variable',
                fontSize: 14,
                color: Color(0xFF9C9C9C),
                fontWeight: FontWeight.w400,
              ),
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 4),
              border: InputBorder.none,
            ),
          ),
        ),
        actions: [
          _dialogButtonWidget(
            text: '취소',
            context: dialogContext,
            onPressed: () => Navigator.of(dialogContext).pop(),
          ),
          const SizedBox(width: 8.0),
          _dialogButtonWidget(
            text: '참여',
            context: dialogContext,
            onPressed: () async {
              final code = controller.text.trim();
              if (code.isEmpty) return;

              try {
                // 먼저 다이얼로그 닫고 처리(원하면 로딩으로 바꿔도 됨)
                Navigator.of(dialogContext).pop();

                final result = await api.joinGroup(code);

                // 성공 처리
                final challengeId = result.data?.challengeId;
                if (challengeId == null) {
                  await _showError("응답 데이터가 올바르지 않습니다.");
                  return;
                }

                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(result.message)));

                onMoveToChallenge(challengeId);
              } on DioException catch (e) {
                final status = e.response?.statusCode;

                if (status == 400) {
                  await _showError("이미 가입했거나 인원이 가득 찼어요.");
                } else if (status == 404) {
                  await _showError("존재하지 않는 그룹 코드예요.");
                } else {
                  await _showError("참여 중 오류가 발생했어요. (${status ?? "네트워크"})");
                }
              } catch (_) {
                await _showError("알 수 없는 오류가 발생했어요.");
              }
            },
          ),
        ],
      );
    },
  );

  controller.dispose();
}

Widget _dialogButtonWidget({
  required String text,
  required BuildContext context,
  VoidCallback? onPressed,
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
      onPressed: onPressed ?? () => Navigator.of(context).pop(),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF17D8A1),
          fontSize: 14,
          fontFamily: 'Pretendard Variable',
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}
