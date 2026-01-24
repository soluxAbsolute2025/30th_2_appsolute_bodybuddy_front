import 'package:bodybuddy_frontend/features/buddyzone/api/buddyzone_friends_api.dart';
import 'package:bodybuddy_frontend/features/buddyzone/models/friends/buddy_detail_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:timeago/timeago.dart' as timeago;

class BuddyProfileDialog extends StatefulWidget {
  final int buddyId; // final로 변경 권장
  final bool isPocked;
  final Future<void> Function({required int userId}) onPocked;

  BuddyProfileDialog({
    super.key,
    required this.buddyId,
    required this.isPocked,
    required this.onPocked,
  });

  @override
  State<BuddyProfileDialog> createState() => _BuddyProfileDialogState();
}

class _BuddyProfileDialogState extends State<BuddyProfileDialog> {
  BuddyDetail? _buddyDetail;
  bool _isLoading = true; // 로딩 상태 추가
  bool _isPocked = false;

  @override
  void initState() {
    super.initState();
    _getBuddyDetail(userId: widget.buddyId);
    _isPocked = widget.isPocked;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _getBuddyDetail({required int userId}) async {
    try {
      final response = await BuddysApi().getBuddyDetail(userId: userId);
      if (mounted) {
        setState(() {
          _buddyDetail = response;
          _isLoading = false; // 로딩 완료
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // 1. 데이터 로딩 중이거나 _buddyDetail이 null이면 로딩 바 표시
    if (_isLoading || _buddyDetail == null) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF1AEDB0)),
      );
    }

    // 이제부터는 _buddyDetail이 null이 아님이 보장됩니다.
    final detail = _buddyDetail!;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20.0),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(22.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 5.0, bottom: 17.0),
              child: _friendProfile(detail), // 데이터를 넘겨줌
            ),
            const Divider(color: Color(0xFFF5F5F5)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 17.0),
                  child: const Text(
                    '오늘의 목표 달성률',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                // 2. 각 섹션에 안전하게 데이터 전달 (null이면 기본값 0 또는 1 제공)
                _dialogButtonWidget(
                  text: '수분',
                  current: detail.homeData?.water?.current ?? 0,
                  goal: detail.homeData?.water?.goal ?? 2000, // 기본 목표치
                  imageUrl: 'assets/buddyzone/friend_profile/water.svg',
                  offset: 'ml',
                ),
                const SizedBox(height: 12.0),
                _dialogButtonWidget(
                  text: '식사',
                  current: detail.homeData?.meal?.current ?? 0,
                  goal: detail.homeData?.meal?.goal ?? 3,
                  imageUrl: 'assets/buddyzone/friend_profile/diet.svg',
                  offset: '회',
                ),
                const SizedBox(height: 12.0),
                _dialogButtonWidget(
                  text: '수면',
                  current: detail.homeData?.sleep?.current ?? 0,
                  goal: detail.homeData?.sleep?.goal ?? 8,
                  imageUrl: 'assets/buddyzone/friend_profile/medi.svg',
                  offset: '시간',
                ),
              ],
            ),
            const SizedBox(height: 40.0),
            _pokeButton(detail.userId),
          ],
        ),
      ),
    );
  }

  // 3. 헬퍼 위젯: 파라미터 타입을 명확히 하고 계산식 수정
  Widget _dialogButtonWidget({
    required String text,
    required int current,
    required int goal,
    required String imageUrl,
    required String offset,
  }) {
    // 0으로 나누기 방지 및 비율 계산
    double ratio = (goal > 0) ? (current / goal) : 0.0;
    if (ratio > 1.0) ratio = 1.0; // 100% 초과 방지

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(imageUrl),
            const SizedBox(width: 6.0),
            Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
            Text(
              '$current / $goal$offset',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
            ),
          ],
        ),
        const SizedBox(height: 10.0),
        Container(
          width: double.infinity,
          height: 10.0,
          decoration: BoxDecoration(
            color: const Color(0xFFEBEBEB),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: ratio,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1AEDB0),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _friendProfile(BuddyDetail detail) {
    return Row(
      children: [
        const SizedBox(
          width: 51.0,
          height: 51.0,
          child: ClipOval(
            child: Image(image: AssetImage('assets/buddyzone/myprofile.png')),
          ),
        ),
        const SizedBox(width: 16.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    detail.nickname,
                    style: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 1.0,
                      horizontal: 10.0,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE9FFF9),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Text(
                      'Lv. ${detail.level}',
                      style: const TextStyle(
                        color: Color(0xFF1AEDB1),
                        fontSize: 11.0,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6.0),
              Text(
                '${detail.status}',
                style: TextStyle(color: Colors.grey[600], fontSize: 14.0),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: () => {Navigator.of(context).pop()},
          style: TextButton.styleFrom(
            foregroundColor: Color(0x1188D3BD),
            padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),

          child: Center(
            child: SvgPicture.asset(
              'assets/buddyzone/friend_profile/x_button.svg',
            ),
          ),
        ),
      ],
    );
  }

  Widget _pokeButton(int userId) {
    return Row(
      children: [
        // 취소 버튼
        Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(
              // horizontal: 16.0,
              // vertical: 5.0,
            ),
            alignment: Alignment.center,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              color: _isPocked ? Color(0xFFE4E4E4) : Color(0xFF1AEDB0),
            ),
            child: TextButton(
              onPressed: _isPocked
                  ? null
                  : () async {
                      print("손 흔들기 클릭!");
                      await widget.onPocked(userId: widget.buddyId);
                      if (mounted) {
                        setState(() {
                          _isPocked = true;
                        });
                      }
                    },
              style: TextButton.styleFrom(
                foregroundColor: Color(0xFF669588),
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Container(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (!_isPocked) ...[
                        SvgPicture.asset(
                          'assets/buddyzone/friend_profile/hand_white.svg',
                        ),
                      ],
                      SizedBox(width: 12.0),
                      Text(
                        _isPocked ? '콕 찌르기 완료' : '콕 찌르기',
                        style: TextStyle(
                          color: _isPocked ? Color(0xFFA7A7A7) : Colors.white,
                          fontSize: 14,
                          fontFamily: 'Pretendard Variable',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
