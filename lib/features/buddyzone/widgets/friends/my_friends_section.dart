// features/home/widgets/home_content.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../friends/myfriendBlock.dart';

class MyFriendsSection extends StatelessWidget {
  const MyFriendsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
        bottom: 25.0,
        right: 16.0,
        left: 16.0,
        top: 20.0,
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Row(
                    children: [
                      Text(
                        '나의 친구',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 5.0),
                      Text(
                        '3',
                        style: TextStyle(
                          color: Color(0xFFA8A8A8),
                          fontSize: 17.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: Colors.white,
                  ),
                  child: TextButton(
                    onPressed: () {
                      print("친구 추가 클릭!");
                      _showdialog(context);
                      // _showWithdrawdialog(context);
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Color(0x1188D3BD),
                      padding: EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 8.0,
                      ),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      minimumSize: Size.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/images/common/friend_add.svg',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          MyfriendBlock(),
          SizedBox(height: 8.0),
          MyfriendBlock(),
          SizedBox(height: 8.0),
          MyfriendBlock(),
        ],
      ),
    );
  }

  Future<dynamic> _showdialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16.0),
        contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
        buttonPadding: EdgeInsets.zero,
        title: Column(
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  'assets/images/common/friend_add.svg',
                  width: 22.3,
                  height: 15.0,
                ),
                SizedBox(width: 10.0),
                Text(
                  '버디 추가',
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
        content: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: _TextFromFieldWidget(hintText: '친구 아이디 입력'),
        ),
        actions: [
          _dialogButtonWidget(text: '취소', context: context),
          _dialogButtonWidget(text: '추가', context: context),
        ],
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      barrierDismissible: true,
      barrierColor: Color(0x963A3A3A),
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
                          foregroundColor: const Color(0xFFE3E3E3),
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
                  // 로그아웃 버튼
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
                          // 여기에 회원 탈퇴 로직 추가
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

  Widget _dialogButtonWidget({
    required String text,
    required BuildContext context,
    Function()? onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: Colors.white,
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: Color(0x1188D3BD),
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          minimumSize: Size.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text(
          text,
          style: TextStyle(
            color: const Color(0xFF17D8A1),
            fontSize: 14,
            fontFamily: 'Pretendard Variable',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _TextFromFieldWidget({required String hintText}) {
    return Expanded(
      child: TextFormField(
        style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          hintText: hintText,
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
          // 둥근 모서리를 주고 싶을 때 사용
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Color(0xFFD8D8D8)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Color(0xFF1AEDB0), width: 1),
          ),
        ),
      ),
    );
  }
}
