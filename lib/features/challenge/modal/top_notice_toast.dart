import 'package:flutter/material.dart';

/// 상단 토스트(모달) 표시
/// 사용 예)
/// await TopNoticeToast.show(context, message: '개인 챌린지를 만들었어요!');
class TopNoticeToast {
  static Future<void> show(
    BuildContext context, {
    required String message,
    String? rightLabel,
    Duration duration = const Duration(milliseconds: 1300),
  }) async {
    final overlay = Overlay.of(context);
    if (overlay == null) return;

    late final OverlayEntry entry;

    entry = OverlayEntry(
      builder: (_) => _TopNoticeToastView(
        message: message,
        rightLabel: rightLabel,
      ),
    );

    overlay.insert(entry);

    await Future.delayed(duration);
    entry.remove();
  }
}

class _TopNoticeToastView extends StatefulWidget {
  final String message;
  final String? rightLabel;

  const _TopNoticeToastView({
    required this.message,
    this.rightLabel,
  });

  @override
  State<_TopNoticeToastView> createState() => _TopNoticeToastViewState();
}

class _TopNoticeToastViewState extends State<_TopNoticeToastView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 220),
    reverseDuration: const Duration(milliseconds: 180),
  );

  late final Animation<double> _opacity =
      CurvedAnimation(parent: _c, curve: Curves.easeOut);

  late final Animation<Offset> _slide = Tween<Offset>(
    begin: const Offset(0, -0.12),
    end: Offset.zero,
  ).animate(CurvedAnimation(parent: _c, curve: Curves.easeOut));

  @override
  void initState() {
    super.initState();
    _c.forward();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: true,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Align(
            alignment: Alignment.topCenter,
            child: SlideTransition(
              position: _slide,
              child: FadeTransition(
                opacity: _opacity,
                child: Container(
                  width: MediaQuery.of(context).size.width - 32,
                  height: 62,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 1),
                        blurRadius: 2.4,
                        spreadRadius: 1,
                        color: Colors.black.withOpacity(0.13),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: const BoxDecoration(
                          color: Color(0xFF18D9A2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 12),

                      // ✅ 메인 문구
                      Expanded(
                        child: Text(
                          widget.message,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                      ),

                      if (widget.rightLabel != null) ...[
                        const SizedBox(width: 12),
                        Text(
                          widget.rightLabel!,
                          style: const TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF7D7C7C),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
