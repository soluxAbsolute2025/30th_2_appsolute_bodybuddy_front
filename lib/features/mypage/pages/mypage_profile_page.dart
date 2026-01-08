import 'package:bodybuddy_frontend/common/widgets/sub_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MypageProfilePage extends StatefulWidget {
  const MypageProfilePage({super.key});

  @override
  State<MypageProfilePage> createState() => _MypageProfilePageState();
}

class _MypageProfilePageState extends State<MypageProfilePage> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // 입력값이 변경될 때마다 상태 확인
  }

  String? _selectedDomain;
  final List<String> _domains = ['naver.com', 'gmail.com', 'daum.net', '직접 입력'];
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
                        type: 'email',
                        hintText: '이메일을 입력해주세요',
                        initText: 'buddy@gmail.com',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
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
    String? type,
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
        type == 'email'
            ? _emailTextFromFieldWidget(
                titleText: titleText,
                hintText: hintText,
                initText: initText,
              )
            : _baseTextFromFieldWidget(
                titleText: titleText,
                hintText: hintText,
                initText: initText,
              ),
        SizedBox(height: 30.0),
      ],
    );
  }

  Widget _baseTextFromFieldWidget({
    required String titleText,
    required String hintText,
    String? initText,
  }) {
    final TextEditingController controller = TextEditingController(
      text: initText,
    );
    return TextFormField(
      controller: controller,
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
    );
  }

  Widget _emailTextFromFieldWidget({
    required String titleText,
    required String hintText,
    String? initText,
  }) {
    return Row(
      children: [
        Expanded(
          child: _baseTextFromFieldWidget(
            titleText: titleText,
            hintText: hintText,
            initText: initText,
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Text('@', style: TextStyle(fontSize: 16, color: Colors.grey)),
        ),
        Container(
          width: 158.0,
          // height: 55.0,
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              hint: const Text(
                '선택',
                style: TextStyle(
                  color: const Color(0xFFA6A6A6),
                  fontSize: 16,
                  fontFamily: 'Pretendard Variable',
                  fontWeight: FontWeight.w500,
                  height: 1.50,
                ),
              ),
              value: _selectedDomain,
              isDense: true,
              iconSize: 24,
              icon: SvgPicture.asset('assets/mypage/down_arrow.svg'),
              items: _domains.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'Pretendard Variable',
                      fontWeight: FontWeight.w500,
                      height: 1.50,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedDomain = newValue;
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
