import 'package:bodybuddy_frontend/common/widgets/sub_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MypageProfilePage extends StatefulWidget {
  const MypageProfilePage({super.key});

  @override
  State<MypageProfilePage> createState() => _MypageProfilePageState();
}

class _MypageProfilePageState extends State<MypageProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SubAppbar(titleText: '프로필 설정'),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 50.0),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 90,
                          height: 90,
                          decoration: ShapeDecoration(
                            shape: CircleBorder(),
                            color: Color(0xFFF8F8F8),
                          ),
                          child: Image(
                            image: AssetImage('assets/mypage/myprofile.png'),
                          ),
                        ),
                        Positioned(
                          bottom: 6,
                          right: -8,
                          child: TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              foregroundColor: Color(0xFF669688),
                              backgroundColor: const Color(0xFF1AEDB0),
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Container(
                              width: 27,
                              height: 27,
                              decoration: ShapeDecoration(
                                shape: OvalBorder(
                                  side: BorderSide(
                                    width: 2,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              child: Center(
                                child: SvgPicture.asset(
                                  'assets/mypage/pencil.svg',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      _textFromFieldWidget(
                        titleText: '닉네임',
                        hintText: '2~10자로 입력해 주세요.',
                      ),
                      _textFromFieldWidget(
                        titleText: '소개',
                        hintText: '건강한 라이프 스타일 실천 중',
                        initText: '건강한 라이프 스타일 실천 중',
                      ),
                      _textFromFieldWidget(
                        titleText: '이메일',
                        hintText: '이메일을 입력해주세요',
                        initText: 'buddy@gamil.com',
                      ),
                    ],
                  ),
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

  Widget _textFromFieldWidget({
    required String titleText,
    required String hintText,
    String? initText, // null 허용 (값이 없을 수도 있음)
  }) {
    // 초기값이 있을 경우를 대비해 컨트롤러 생성
    final TextEditingController controller = TextEditingController(
      text: initText,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titleText, // '닉네임' 대신 전달받은 titleText 사용
          style: const TextStyle(
            fontSize: 16.0,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16.0),
        TextFormField(
          controller: controller, // initialValue 대신 controller 사용
          style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              color: Color(0xFFA6A6A6),
              fontSize: 16.0,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w500,
            ),
            filled: true,
            fillColor: const Color(0xFFF7F7F7),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 16,
            ),
            // 둥근 모서리를 주고 싶을 때 사용
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(color: Color(0xFF1AEDB0), width: 1),
            ),
          ),
        ),
        SizedBox(height: 30.0),
      ],
    );
  }
}
