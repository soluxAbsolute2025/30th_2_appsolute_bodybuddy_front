import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/group_challenge_detail_model.dart';
import '../widgets/group_challenge_info_section.dart';
import '../widgets/group_challenge_description_section.dart';
import '../widgets/group_challenge_rank_section.dart';
import '../widgets/group_challenge_bottom_buttons.dart';

import '../data/dummy_challenge_verify.dart';
import '../modal/challenge_verify_confirm_modal.dart';
import '../modal/challenge_verify_complete_modal.dart';

import '../../shop/pages/shop_page.dart';
import '../api/group_challenge_api.dart'; // ✅ 추가

class GroupChallengeDetailPage extends StatefulWidget {
  final int challengeId; // ✅ id만 받기

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

  GroupChallengeDetail? _challenge;
  bool _isFetching = true;
  String? _errorMessage;

  bool isVerified = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchDetail();
  }

  Future<void> _fetchDetail() async {
    setState(() {
      _isFetching = true;
      _errorMessage = null;
    });

    try {
      final detail =
          await _api.getOngoingGroupChallengeDetail(widget.challengeId);

      if (!mounted) return;
      setState(() {
        _challenge = detail;
        _isFetching = false;
      });
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

    await showChallengeVerifyConfirmModal(
      context: context,
      challengeTitle: DummyChallengeVerify.dailyTitle,
      onConfirm: () async {
        setState(() => isLoading = true);

        // TODO: 백엔드 인증 API 자리
        // await api.verify();

        await showChallengeVerifyCompleteModal(
          context: context,
          point: DummyChallengeVerify.rewardPoint,
        );

        if (!mounted) return;
        setState(() {
          isLoading = false;
          isVerified = true;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // ✅ 로딩 화면
    if (_isFetching) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(context),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // ✅ 에러 화면
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
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  _errorMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF747474),
                  ),
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
    // (옵션) 상태에 따라 인증 버튼 노출 제어하고 싶으면 여기서 분기 가능
    // final status = challenge.challengeInfo.status;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GroupChallengeInfoSection(challenge: challenge),
            Container(
              width: double.infinity,
              height: 10,
              color: const Color(0xFFF8F8F8),
            ),
            GroupChallengeDescriptionSection(challenge: challenge),
            Container(
              width: double.infinity,
              height: 20,
              color: const Color(0xFFF8F8F8),
            ),
            GroupChallengeRankSection(challenge: challenge),
            const SizedBox(height: 0),
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            child: Center(
              child: SvgPicture.asset(
                'assets/challenge/shop.svg',
                height: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
