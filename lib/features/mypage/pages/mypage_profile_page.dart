import 'dart:io';

import 'package:bodybuddy_frontend/common/widgets/sub_appbar.dart';
import 'package:bodybuddy_frontend/features/mypage/api/mypage_api.dart';
import 'package:bodybuddy_frontend/features/mypage/models/mypage_info_model.dart';
import 'package:bodybuddy_frontend/features/mypage/models/mypage_profile_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_cropper/image_cropper.dart';
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
  final List<String> _domains = [
    'naver.com',
    'daum.net',
    'gmail.com',
    'sookmyung.ac.kr',
  ];

  /// Origin values (변경 여부 판단용)
  late File _originImage;
  late String _originNickname;
  late String _originIntroduction;
  late String _originEmail;
  String? _originDomain;

  File? _selectedImage;

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
    final introduction = _introductionController.text.trim();
    final email = _emailController.text.trim();
    final fullEmail = '$email@$_selectedDomain';

    // 1. 필수값 검증
    if (nickname.isEmpty || email.isEmpty || _selectedDomain == null) {
      setState(() => _isSaveEnabled = false);
      return;
    }

    // 2. 변경 여부 판단
    bool isNicknameChanged = nickname != _originNickname;
    bool isIntroductionChanged = introduction != _originIntroduction;
    bool isEmailChanged = fullEmail != '$_originEmail@$_originDomain';

    // 이미지가 새로 선택되었는가? (선택되었다면 무조건 변경으로 간주)
    bool isImageChanged = _selectedImage != null;

    setState(() {
      _isSaveEnabled =
          isNicknameChanged ||
          isIntroductionChanged ||
          isEmailChanged ||
          isImageChanged;
    });
  }

  void _onSave() async {
    final nickname = _nicknameController.text.trim();
    final introduction = _introductionController.text.trim();
    final email = _emailController.text.trim();
    final fullEmail = '$email@$_selectedDomain';

    final profileModel = MyProfileModel(
      nickname: (nickname != _originNickname) ? nickname : null,
      introduction: (introduction != _originIntroduction) ? introduction : null,
      email: (fullEmail != '$_originEmail@$_originDomain') ? fullEmail : null,
      isImageDeleted: false,
    );

    debugPrint('전송 데이터: ${profileModel.toJsonString()}');

    await ProfileApi().updateProfile(
      request: profileModel,
      imageFile: _selectedImage,
    );
  }

  Future<void> _pickAndProcessImage() async {
    final XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile == null) return;

    final CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedFile.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: '사진 자르기',
          toolbarColor: Colors.black,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(title: '사진 자르기'),
      ],
    );
    if (croppedFile == null) return;

    final String targetPath = croppedFile.path.replaceFirst(
      RegExp(r'\.jpg$|\.png$'),
      '_out.jpg',
    );

    var result = await FlutterImageCompress.compressAndGetFile(
      croppedFile.path,
      targetPath,
      quality: 80,
    );

    if (result != null) {
      setState(() {
        _originImage = File(result.path);
        _selectedImage = File(result.path);
      });
    }
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
                        child: _selectedImage != null
                            ? ClipOval(
                                child: Image.file(
                                  _originImage,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Image.asset('assets/mypage/myprofile.png'),
                      ),
                      Positioned(
                        bottom: 6,
                        right: -8,
                        child: TextButton(
                          onPressed: () {
                            // TODO: 프로필 이미지 변경
                            _pickAndProcessImage();
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
            margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 30.0),
            alignment: Alignment.center,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              color: _isSaveEnabled
                  ? const Color(0xFF1AEDB0)
                  : const Color(0xFFE0E0E0),
            ),
            child: TextButton(
              onPressed: _isSaveEnabled ? _onSave : null,
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
