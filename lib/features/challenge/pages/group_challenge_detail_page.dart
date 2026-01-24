import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/group_challenge_detail_model.dart';
import '../widgets/group_challenge_info_section.dart';
import '../widgets/group_challenge_description_section.dart';
import '../widgets/group_challenge_rank_section.dart';
import '../widgets/group_challenge_bottom_buttons.dart';

import '../modal/challenge_verify_confirm_modal.dart';
import '../modal/challenge_verify_complete_modal.dart';

import '../../shop/pages/shop_page.dart';
import '../api/group_challenge_api.dart';
import '../api/group_challenge_checkin_api.dart';
import '../models/group_checkin_response.dart';

class GroupChallengeDetailPage extends StatefulWidget {
  final int challengeId;

  const GroupChallengeDetailPage({
    super.key,
    required this.challengeId,
  });

  @override
  State<GroupChallengeDetailPage> createState() =>
      _GroupChallengeDetailPageState();
}

class _GroupChallengeDetailPageState extends State<GroupChallengeDetailPage> {
  final _api = GroupChallengeApi();
  final _checkinApi = GroupChallengeCheckInApi();

  GroupChallengeDetail? _challenge;
  bool _isFetching = true;
  String? _errorMessage;

  bool isVerified = false;
  bool isLoading = false;

  // ---------- checkInTime local 저장/복원 ----------
  static String _checkInKey(int challengeId) => 'group_checkin_time_$challengeId';

  DateTime _toKst(DateTime dt) => dt.toUtc().add(const Duration(hours: 9));

  bool _isSameKstDay(DateTime a, DateTime b) {
    final ka = _toKst(a);
    final kb = _toKst(b);
    return ka.year == kb.year && ka.month == kb.month && ka.day == kb.day;
  }

  Future<void> _loadVerifyStateFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_checkInKey(widget.challengeId));
    if (raw == null || raw.isEmpty) return;

    final saved = DateTime.tryParse(raw);
    if (saved == null) return;

    final now = DateTime.now();
    if (!mounted) return;
    setState(() {
      isVerified = _isSameKstDay(saved, now); // ✅ 오늘이면 인증완료
    });
  }

  Future<void> _saveCheckInTime(DateTime checkInTime) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_checkInKey(widget.challengeId), checkInTime.toIso8601String());
  }

  @override
  void initState() {
    super.initState();
    _fetchDetail();
    _loadVerifyStateFromLocal(); // ✅ 재진입 시 버튼 상태 복원
  }

  Future<void> _fetchDetail() async {
    setState(() {
      _isFetching = true;
      _errorMessage = null;
    });

    try {
      final detail = await _api.getOngoingGroupChallengeDetail(widget.challengeId);

      if (!mounted) return;
      setState(() {
        _challenge = detail;
        _isFetching = false;
      });

      // ✅ 상세 로드 후에도 한번 더 복원(타이밍 안전)
      await _loadVerifyStateFromLocal();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString();
        _isFetching = false;
      });
    }
  }

  Future<void> _onPressVerify() async {
    if (isLoading || isVerified) return;

    final title = _challenge?.challengeInfo.title ?? '';

    GroupCheckInResponse? result;

    final ok = await showChallengeVerifyConfirmModal(
      context: context,
      challengeTitle: title,
      onConfirm: () async {
        if (!mounted) return;
        setState(() => isLoading = true);

        try {
          result = await _checkinApi.checkIn(challengeId: widget.challengeId);
          await _saveCheckInTime(result!.data.checkInTime);
        } finally {
          if (mounted) setState(() => isLoading = false);
        }
      },
    );

    if (ok != true || result == null) return;

    // ✅ confirm이 완전히 닫힌 뒤에 complete 띄우기
    await showChallengeVerifyCompleteModal(
      context: context,
      point: result!.data.earnedPoints,
    );

    if (!mounted) return;
    setState(() => isVerified = true);
  }

  @override
  Widget build(BuildContext context) {
    if (_isFetching) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(context),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(context),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '상세 정보를 불러오지 못했어요.',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                Text(
                  _errorMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12, color: Color(0xFF747474)),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _fetchDetail,
                  child: const Text('다시 시도'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final challenge = _challenge!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GroupChallengeInfoSection(challenge: challenge),
            Container(width: double.infinity, height: 10, color: const Color(0xFFF8F8F8)),
            GroupChallengeDescriptionSection(challenge: challenge),
            Container(width: double.infinity, height: 20, color: const Color(0xFFF8F8F8)),
            GroupChallengeRankSection(challenge: challenge),
          ],
        ),
      ),
      bottomNavigationBar: GroupChallengeBottomButtons(
        onPressedVerify: _onPressVerify,
        isLoading: isLoading,
        isVerified: isVerified,
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: const Color(0xFFFFFFFF),
      surfaceTintColor: Colors.transparent,
      titleSpacing: 0,
      leadingWidth: 48,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Image.asset(
          'assets/challenge/back_vector.png',
          width: 24,
          height: 24,
        ),
      ),
      title: SizedBox(
        height: 60.0,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 19.0, 16.0, 17.0),
          child: Text(
            '그룹 챌린지',
            style: const TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              height: 1.0,
              color: Colors.black,
            ),
          ),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16.0),
          width: 35.0,
          height: 35.0,
          child: TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ShopPage()),
              );
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
            ),
            child: Center(
              child: SvgPicture.asset('assets/challenge/shop.svg', height: 20),
            ),
          ),
        ),
      ],
    );
  }
}
