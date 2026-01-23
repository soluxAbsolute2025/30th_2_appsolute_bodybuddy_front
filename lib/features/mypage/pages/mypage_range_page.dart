import 'package:bodybuddy_frontend/common/widgets/sub_appbar.dart';
import 'package:bodybuddy_frontend/features/mypage/api/mypage_api.dart';
import 'package:bodybuddy_frontend/features/mypage/models/mypage_privacy_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MypageRangePage extends StatefulWidget {
  const MypageRangePage({super.key}); // const 추가 권장

  @override
  State<MypageRangePage> createState() => _MypageRangePageState();
}

class _MypageRangePageState extends State<MypageRangePage> {
  PrivacyResponse? myPagePrivacy;
  bool isLoading = true; // 화면 로딩 상태

  // 초기값은 true지만, 로딩 화면 덕분에 사용자는 이 값을 보지 못함
  bool _water = true;
  bool _fit = true;
  bool _food = true;
  bool _sleep = true;

  @override
  void initState() {
    super.initState();
    getMypageInfoPrivacy();
  }

  Future<void> getMypageInfoPrivacy() async {
    try {
      // [핵심] API 호출과 500ms(0.5초) 대기를 동시에 실행하고, 둘 다 끝날 때까지 기다림
      // Future.wait는 리스트 안의 모든 비동기 작업이 끝날 때까지 대기합니다.
      final results = await Future.wait([
        MyPageAPI().getMyPagePrivacy(), // [0] API 데이터 가져오기
        Future.delayed(const Duration(milliseconds: 500)), // [1] 최소 대기 시간
      ]);

      // results[0]에 API 결과가 들어있습니다.
      final result = results[0] as PrivacyResponse;

      if (mounted) {
        setState(() {
          myPagePrivacy = result;
          _water = result.waterPublic;
          _fit = result.workoutPublic;
          _food = result.dietPublic;
          _sleep = result.sleepPublic;

          isLoading = false; // 데이터 세팅 후 로딩 해제
        });
      }
    } catch (e) {
      print('마이페이지 프라이버시 로드 실패: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> patchMypageInfoPrivacy() async {
    // 1. 저장할 데이터를 담은 새로운 객체 생성 (안전한 방식)
    final updatedData = PrivacyResponse(
      waterPublic: _water,
      workoutPublic: _fit,
      dietPublic: _food,
      sleepPublic: _sleep,
    );

    try {
      // 2. API 전송
      await MyPageAPI().patchMyPagePrivacy(updatedData);

      // 3. 성공 피드백 (선택사항)
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('설정이 저장되었습니다.')));
      }
    } catch (e) {
      print('저장 실패: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SubAppbar(titleText: '공개 범위 설정'),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '친구들에게 공개할 정보를 선택해주세요',
                          style: TextStyle(
                            color: Color(0xFF7C7C7C),
                            fontSize: 12.0,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 25.0),

                        // 위젯들을 리팩토링 없이 그대로 둔다면 아래처럼 사용
                        _rangeBlockWidget(
                          titleText: '수분 섭취량',
                          valueType: 'Water',
                          rageValue: _water,
                          imageUrl: 'assets/mypage/water.svg',
                          onChanged: (value) => setState(() => _water = value),
                        ),
                        const Divider(color: Color(0xFFF5F5F5)),

                        _rangeBlockWidget(
                          titleText: '운동 기록',
                          valueType: 'Fit',
                          rageValue: _fit,
                          imageUrl: 'assets/mypage/fit.svg',
                          onChanged: (value) => setState(() => _fit = value),
                        ),
                        const Divider(color: Color(0xFFF5F5F5)),

                        _rangeBlockWidget(
                          titleText: '식단 기록',
                          valueType: 'Food',
                          rageValue: _food,
                          imageUrl: 'assets/mypage/food.svg',
                          onChanged: (value) => setState(() => _food = value),
                        ),
                        const Divider(color: Color(0xFFF5F5F5)),

                        _rangeBlockWidget(
                          titleText: '수면 기록',
                          valueType: 'Sleep',
                          rageValue: _sleep,
                          imageUrl: 'assets/mypage/sleep.svg',
                          onChanged: (value) => setState(() => _sleep = value),
                        ),
                        const Divider(color: Color(0xFFF5F5F5)),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 30.0,
                  ),
                  alignment: Alignment.center,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    color: Color(0xFF1AEDB0),
                  ),
                  child: TextButton(
                    onPressed: patchMypageInfoPrivacy,
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF669588),
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      child: const Center(
                        child: Text(
                          '저장',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'Pretendard Variable',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _rangeBlockWidget({
    required String titleText,
    required String valueType,
    required bool rageValue,
    required String imageUrl,
    required Function(bool) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 64.0,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 4.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 14.0,
                height: 14.0,
                alignment: Alignment.center,
                child: SvgPicture.asset(imageUrl, width: 14.0),
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: Text(
                  titleText,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              _CustomSwitch(rageValue, onChanged: onChanged),
            ],
          ),
        ),
      ],
    );
  }

  Widget _CustomSwitch(bool isEnable, {required Function(bool) onChanged}) {
    return GestureDetector(
      onTap: () => onChanged(!isEnable),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: 42.0,
        height: 22.0,
        padding: const EdgeInsets.all(1.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(60.0),
          color: isEnable ? const Color(0xFF1AEDB1) : const Color(0xFFD8D8D8),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 100),
          alignment: isEnable ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 20.0,
            height: 20.0,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
