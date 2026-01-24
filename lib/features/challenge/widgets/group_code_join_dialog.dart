import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dio/dio.dart';
import '../api/group_join_api.dart';

Future<int?> showJoinGroupCodeDialog({required BuildContext context}) {
  return showDialog<int?>(
    context: context,
    useRootNavigator: true,
    barrierDismissible: true,
    barrierColor: const Color(0x963A3A3A),
    builder: (_) => const _JoinGroupCodeDialog(),
  );
}

class _JoinGroupCodeDialog extends StatefulWidget {
  const _JoinGroupCodeDialog();

  @override
  State<_JoinGroupCodeDialog> createState() => _JoinGroupCodeDialogState();
}

class _JoinGroupCodeDialogState extends State<_JoinGroupCodeDialog> {
  final _controller = TextEditingController();
  final _api = GroupJoinApi();
  bool _isLoading = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _join() async {
    if (_isLoading) return;

    final code = _controller.text.trim();
    if (code.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      final res = await _api.joinGroup(code);
      final challengeId = res.data?.challengeId;

      if (!mounted) return;

      if (challengeId == null) {
        setState(() => _isLoading = false);
        return;
      }

      Navigator.of(context, rootNavigator: true).pop(challengeId);
    } on DioException {
      if (!mounted) return;
      setState(() => _isLoading = false);
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16.0),
      contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
      buttonPadding: EdgeInsets.zero,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),

      // ✅ title UI: 아이콘 + 텍스트 (버디 추가랑 동일한 느낌)
      title: Column(
        children: [
          Row(
            children: [
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

      // ✅ content UI: 입력창 상자 스타일 (버디 추가의 TextFormField 스타일 복붙)
      content: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        child: TextFormField(
          controller: _controller,
          enabled: !_isLoading,
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
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => _isLoading ? null : _join(),
        ),
      ),

      // ✅ actions UI: 버튼 스타일도 동일하게
      actions: [
        _dialogButtonWidget(
          text: '취소',
          onPressed: _isLoading
              ? null
              : () => Navigator.of(context, rootNavigator: true).pop(null),
        ),
        const SizedBox(width: 8.0),
        _dialogButtonWidget(
          text: _isLoading ? '참여 중...' : '참여',
          onPressed: _isLoading ? null : _join,
        ),
      ],
    );
  }

  // ✅ 버디 추가 코드의 버튼 스타일 그대로
  Widget _dialogButtonWidget({required String text, VoidCallback? onPressed}) {
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
}
