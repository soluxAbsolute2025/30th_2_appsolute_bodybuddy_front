import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomToast {
  static void show(BuildContext context, String message, {String? subMessage}) {
    // 1. OverlayState 가져오기 (화면 위에 그릴 수 있는 도화지)
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    // 2. 팝업 디자인 및 애니메이션 정의
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 10, // 상태바 아래 10px 띄움
        left: 16,
        right: 16,
        child: Material(
          color: Colors.transparent,
          child: _ToastWidget(
            message: message,
            subMessage: subMessage,
            onDismiss: () {
              if (overlayEntry.mounted) {
                overlayEntry.remove();
              }
            },
          ),
        ),
      ),
    );

    // 3. 화면에 삽입
    overlay.insert(overlayEntry);

    // 4. 3초 뒤에 자동으로 사라지게 하기
    // (애니메이션 시간을 고려해서 3초 + a 뒤에 remove 해도 되지만,
    //  여기서는 위젯 내부에서 애니메이션이 끝나면 사라지는 로직을 추가하지 않고
    //  단순하게 Timer로 제어합니다. 더 고도화하려면 AnimationController 필요)
    Timer(const Duration(seconds: 3), () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }
}

// 내부에서 사용할 실제 디자인 위젯 (애니메이션 포함)
class _ToastWidget extends StatefulWidget {
  final String message;
  final String? subMessage;
  final VoidCallback onDismiss;

  const _ToastWidget({
    required this.message,
    this.subMessage,
    required this.onDismiss,
  });

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500), // 나타날 때 0.5초
      reverseDuration: const Duration(milliseconds: 600), // 사라질 때 0.5초
      vsync: this,
    );

    // 위에서 아래로 내려오는 슬라이드 효과
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, -2.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    // 투명도 효과
    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

    // 시작하자마자 애니메이션 실행
    _controller.forward();

    // 2.5초 뒤에 사라지는 애니메이션 시작 (총 3초 유지)
    Timer(const Duration(milliseconds: 3000), () {
      if (mounted) {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 23),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            borderRadius: BorderRadius.circular(10), // 둥근 모서리
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // 초록색 체크 아이콘
              SvgPicture.asset('assets/images/check.svg'),
              const SizedBox(width: 12),

              // 메인 텍스트
              Expanded(
                child: Text(
                  widget.message,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: 'Pretendard Variable',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),

              if (widget.subMessage != null)
                Text(
                  widget.subMessage!,
                  style: TextStyle(
                    color: const Color(0xFF7C7C7C),
                    fontSize: 12,
                    fontFamily: 'Pretendard Variable',
                    fontWeight: FontWeight.w400,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
