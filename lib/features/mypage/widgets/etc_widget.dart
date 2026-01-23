import 'package:bodybuddy_frontend/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bodybuddy_frontend/api/auth_api.dart';

class EtcWidget extends StatelessWidget {
  const EtcWidget({super.key});

  Future<void> postLogoutUser() async {
    await AuthApi().logoutUser();
    // await Common().logout();
  }

  Future<void> deleteUser(BuildContext context) async {
    try {
      // 1. API 호출
      await AuthApi().deleteUser();

      // 2. 로그아웃 처리 (토큰 삭제 등)
      // await Common().logout(); // 기존에 주석 처리 하신 부분

      // 3. 성공 시 로그인 화면으로 이동 등 후속 처리
      if (context.mounted) {
        // 예: Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
        print("회원 탈퇴 성공");
      }
    } catch (e) {
      // 4. 에러 발생 시 사용자에게 알림
      print("회원 탈퇴 실패: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('회원 탈퇴 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      width: double.infinity,
      // constraints: BoxConstraints(maxHeight: 100.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextButton(
            onPressed: () {
              _showLogoutdialog(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: Color(0x1188D3BD),
              padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap, // 터치 영역을 내용물에 맞춤
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            child: Text(
              '로그아웃',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(height: 16.0),
          TextButton(
            onPressed: () {
              _showWithdrawdialog(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: Color(0x1188D3BD),
              padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            child: Text(
              '회원 탈퇴',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> _showLogoutdialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: const Color(0x963A3A3A),
      builder: (BuildContext context) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 20.0),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(13.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1. 텍스트 영역 (피그마 수치에 맞춘 여백 조절 가능)
              Container(
                padding: const EdgeInsets.only(top: 35.0, bottom: 35.0),
                alignment: Alignment.center,
                child: const Text(
                  '로그아웃 하시겠습니까?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Pretendard Variable',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),

              Row(
                children: [
                  // 취소 버튼
                  Expanded(
                    child: SizedBox(
                      height: 40.0,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0x1188D3BD),
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 16.0,
                          ),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          minimumSize: Size.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            side: const BorderSide(
                              color: Color(0xFFEFEFEF),
                              width: 1.0,
                            ),
                          ),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text(
                          '취소',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: 'Pretendard Variable',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  // 로그아웃 버튼
                  Expanded(
                    child: SizedBox(
                      height: 40.0,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: const Color(0xFF1AEDB0),
                          foregroundColor: const Color(0xFF669588),
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 16.0,
                          ),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          minimumSize: Size.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          // 여기에 로그아웃 로직 추가
                          postLogoutUser();
                        },
                        child: const Text(
                          '로그아웃',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: 'Pretendard Variable',
                            fontWeight: FontWeight.w700,
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
  }

  Future<dynamic> _showWithdrawdialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: const Color(0x963A3A3A),
      builder: (BuildContext context) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 20.0),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(13.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.only(top: 7.0, bottom: 20.0),
                alignment: Alignment.center,
                child: const Text(
                  '회원 탈퇴 ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Pretendard Variable',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                '지금 탈퇴하시면 현재까지 저장된 모든 건강\n데이터가 삭제됩니다.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF4F4F4F),
                  fontSize: 14,
                  fontFamily: 'Pretendard Variable',
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                '정말로 탈퇴하시겠어요?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF4F4F4F),
                  fontSize: 14,
                  fontFamily: 'Pretendard Variable',
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 30.0),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 40.0,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          // foregroundColor: const Color(0xFFE3E3E3),
                          foregroundColor: const Color(0xFFF65A33),
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 16.0,
                          ),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          minimumSize: Size.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            side: const BorderSide(
                              color: Color(0xFFEFEFEF),
                              width: 1.0,
                            ),
                          ),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text(
                          '아니요',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: 'Pretendard Variable',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: SizedBox(
                      height: 40.0,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: const Color(0xFFF65A33),
                          foregroundColor: const Color(0xFFC1330F),
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 16.0,
                          ),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          minimumSize: Size.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          deleteUser(context);
                        },
                        child: const Text(
                          '회원탈퇴',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: 'Pretendard Variable',
                            fontWeight: FontWeight.w700,
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
  }
}
