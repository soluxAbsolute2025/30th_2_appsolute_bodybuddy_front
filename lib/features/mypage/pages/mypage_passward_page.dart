import 'package:bodybuddy_frontend/common/widgets/sub_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MypagePasswardPage extends StatefulWidget {
  const MypagePasswardPage({super.key});

  @override
  State<MypagePasswardPage> createState() => _MypagePasswardPageState();
}

class _MypagePasswardPageState extends State<MypagePasswardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SubAppbar(titleText: '비밀번호 설정'),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _passwardTextFromFieldWidget(hintText: '현재 비밀번호'),
                  SizedBox(height: 24.0),
                  _passwardTextFromFieldWidget(hintText: '새 비밀번호'),
                  _passwardTextFromFieldWidget(hintText: '새 비밀번호 확인'),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 30.0),
            alignment: Alignment.center,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              color: Color(0xFF1AEDB0),
            ),
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                foregroundColor: Color(0xFF669588),
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Container(
                padding: EdgeInsets.all(16.0),
                child: Center(
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

  Widget _passwardTextFromFieldWidget({required String hintText}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
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

            filled: true,
            fillColor: Color(0xFFFFFFFF),

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
      ],
    );
  }
}
