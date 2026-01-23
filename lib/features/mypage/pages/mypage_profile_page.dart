import 'package:bodybuddy_frontend/common/widgets/sub_appbar.dart';
import 'package:bodybuddy_frontend/features/mypage/models/mypage_info_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

class MypageProfilePage extends StatefulWidget {
  final MyPageResponse? myPageInfo;
  const MypageProfilePage({super.key, required this.myPageInfo});

  @override
  State<MypageProfilePage> createState() => _MypageProfilePageState();
}

class _MypageProfilePageState extends State<MypageProfilePage> {
  /// Controllers
  final _nicknameController = TextEditingController();
  final _introductionController = TextEditingController();
  final _emailController = TextEditingController();

  /// Email domain
  String? _selectedDomain;
  final List<String> _domains = ['naver.com', 'gmail.com', 'daum.net'];

  /// Origin values (변경 여부 판단용)
  late XFile _originImage;
  late String _originNickname;
  late String _originIntroduction;
  late String _originEmail;
  String? _originDomain;

  bool _isSaveEnabled = false;

  @override
  void initState() {
    super.initState();

    _originNickname = widget.myPageInfo?.userProfile.nickname ?? '';
    _originIntroduction = widget.myPageInfo?.userProfile.introduction ?? '';
    _originEmail = 'buddy' ?? '';
    _originDomain = 'daum.net' ?? '';
    // _originEmail = widget.myPageInfo?.userProfile.email ?? '';
    // _originDomain = widget.myPageInfo?.userProfile.emailDomain ?? '';

    _nicknameController.text = _originNickname;
    _introductionController.text = _originIntroduction;
    _emailController.text = _originEmail;
    _selectedDomain = _originDomain;

    _nicknameController.addListener(_checkSaveEnabled);
    _introductionController.addListener(_checkSaveEnabled);
    _emailController.addListener(_checkSaveEnabled);
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _introductionController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  /// 🔥 저장 버튼 활성화 조건
  void _checkSaveEnabled() {
    final nickname = _nicknameController.text.trim();
    final email = _emailController.text.trim();

    // 필수값 검증
    if (nickname.isEmpty || email.isEmpty || _selectedDomain == null) {
      setState(() => _isSaveEnabled = false);
      return;
    }

    // 변경 여부
    final isChanged =
        nickname != _originNickname ||
        _introductionController.text != _originIntroduction ||
        email != _originEmail ||
        _selectedDomain != _originDomain;

    setState(() {
      _isSaveEnabled = isChanged;
    });
  }

  void _onSave() {
    final fullEmail = '${_emailController.text}@$_selectedDomain';

    /// TODO: API 호출
    debugPrint('닉네임: ${_nicknameController.text}');
    debugPrint('소개: ${_introductionController.text}');
    debugPrint('이메일: $fullEmail');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SubAppbar(titleText: '프로필 설정'),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(height: 50),

                  /// 프로필 이미지
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 90,
                        height: 90,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFF8F8F8),
                        ),
                        child: Image.asset('assets/mypage/myprofile.png'),
                      ),
                      Positioned(
                        bottom: 6,
                        right: -8,
                        child: TextButton(
                          onPressed: () {
                            // TODO: 프로필 이미지 변경
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: const Color(0xFF1AEDB0),
                            minimumSize: Size.zero,
                            padding: EdgeInsets.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Container(
                            width: 27,
                            height: 27,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.fromBorderSide(
                                BorderSide(color: Colors.white, width: 2),
                              ),
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                'assets/mypage/pencil.svg',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 50),

                  /// 닉네임
                  _inputSection(
                    title: '닉네임',
                    child: _textField(
                      controller: _nicknameController,
                      hintText: '2~10자로 입력해 주세요.',
                    ),
                  ),

                  /// 소개
                  _inputSection(
                    title: '소개',
                    child: _textField(
                      controller: _introductionController,
                      hintText: '건강한 라이프 스타일 실천 중',
                    ),
                  ),

                  /// 이메일
                  _inputSection(title: '이메일', child: _emailField()),
                ],
              ),
            ),
          ),

          /// 저장 버튼
          Container(
            margin: const EdgeInsets.all(16),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: _isSaveEnabled
                  ? const Color(0xFF1AEDB0)
                  : const Color(0xFFE0E0E0),
            ),
            child: TextButton(
              onPressed: _isSaveEnabled ? _onSave : null,
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  '저장',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 16),
        child,
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String hintText,
  }) {
    return TextFormField(
      controller: controller,
      decoration: _inputDecoration(hintText),
    );
  }

  Widget _emailField() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _emailController,
            decoration: _inputDecoration('이메일 입력'),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text('@'),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                hint: const Text('선택'),
                value: _selectedDomain,
                icon: SvgPicture.asset('assets/mypage/down_arrow.svg'),
                items: _domains
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) {
                  setState(() => _selectedDomain = value);
                  _checkSaveEnabled();
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: const Color(0xFFF7F7F7),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF1AEDB0)),
      ),
    );
  }
}
