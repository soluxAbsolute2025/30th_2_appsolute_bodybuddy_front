import 'dart:io';

import 'package:bodybuddy_frontend/common/widgets/sub_appbar.dart';
import 'package:bodybuddy_frontend/common/widgets/toast_widget.dart';
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
  late String _originNickname;
  late String _originIntroduction;
  late String _originFullEmail;
  late String _originEmail;
  String? _originDomain;

  /// 새로 선택된 이미지 파일
  File? _selectedImage;

  bool _isSaveEnabled = false;

  @override
  void initState() {
    super.initState();

    final userProfile = widget.myPageInfo?.userProfile;

    _originNickname = userProfile?.nickname ?? '';
    _originIntroduction = userProfile?.introduction ?? '';
    _originFullEmail = userProfile?.email ?? '';

    // 🔥 [수정 1] 이메일 파싱 안전하게 처리 (Crash 방지)
    if (_originFullEmail.contains('@')) {
      List<String> parts = _originFullEmail.split('@');
      _originEmail = parts[0];
      _originDomain = parts.length > 1 ? parts[1] : null;
    } else {
      _originEmail = _originFullEmail;
      _originDomain = null;
    }

    // 도메인이 목록에 없으면 null 처리하거나 기타 로직 필요
    if (_domains.contains(_originDomain)) {
      _selectedDomain = _originDomain;
    } else {
      _selectedDomain = null; // 혹은 목록에 없는 경우 처리
    }

    _nicknameController.text = _originNickname;
    _introductionController.text = _originIntroduction;
    _emailController.text = _originEmail;

    // 리스너 등록
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

  /// 🔥 [수정 2] 저장 버튼 활성화 조건 로직 정밀화
  void _checkSaveEnabled() {
    final nickname = _nicknameController.text.trim();
    final introduction = _introductionController.text.trim();
    final email = _emailController.text.trim();

    // 도메인이 선택되지 않았으면 fullEmail 생성을 보류하거나 빈값 처리
    final fullEmail = (_selectedDomain != null)
        ? '$email@$_selectedDomain'
        : email;

    // 1. 필수값 검증 (닉네임, 이메일, 도메인 필수라고 가정)
    if (nickname.isEmpty || email.isEmpty || _selectedDomain == null) {
      if (_isSaveEnabled) setState(() => _isSaveEnabled = false);
      return;
    }

    // 2. 변경 여부 판단
    bool isNicknameChanged = nickname != _originNickname;
    bool isIntroductionChanged = introduction != _originIntroduction;

    // 이메일 변경 여부: 원래 이메일과 현재 조합된 이메일 비교
    bool isEmailChanged = fullEmail != _originFullEmail;

    // 이미지 변경 여부: _selectedImage가 null이 아니면 변경된 것
    bool isImageChanged = _selectedImage != null;

    final shouldEnable =
        isNicknameChanged ||
        isIntroductionChanged ||
        isEmailChanged ||
        isImageChanged;

    if (_isSaveEnabled != shouldEnable) {
      setState(() {
        _isSaveEnabled = shouldEnable;
      });
    }
  }

  void _onSave() async {
    final nickname = _nicknameController.text.trim();
    final introduction = _introductionController.text.trim();
    final email = _emailController.text.trim();
    final fullEmail = '$email@$_selectedDomain';

    // 변경된 값만 보낼 것인지, 전체를 보낼 것인지 API 스펙에 맞게 조정
    final profileModel = MyProfileModel(
      nickname: (nickname != _originNickname) ? nickname : null,
      introduction: (introduction != _originIntroduction) ? introduction : null,
      email: (fullEmail != _originFullEmail) ? fullEmail : null,
    );

    debugPrint('전송 데이터: ${profileModel.toJsonString()}');

    await ProfileApi().updateProfile(
      request: profileModel,
      imageFile: _selectedImage, // 이미지가 있으면 파일 전송
    );

    CustomToast.show(context, '나의 프로필을 수정했습니다!');
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

    // 압축
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
        _selectedImage = File(result.path); // 선택된 이미지 업데이트
      });
      // 🔥 [중요] 이미지가 선택되었으니 버튼 상태 다시 체크
      _checkSaveEnabled();
    }
  }

  /// 🔥 [수정 3] 이미지 위젯을 상황에 맞게 반환하는 헬퍼 메서드
  ImageProvider _getProfileImageProvider() {
    // 1순위: 방금 갤러리에서 선택한 이미지
    if (_selectedImage != null) {
      return FileImage(_selectedImage!);
    }
    // 2순위: 서버에서 받아온 기존 프로필 이미지
    final serverImageUrl = widget.myPageInfo?.userProfile.profileImageUrl;
    if (serverImageUrl != null && serverImageUrl.isNotEmpty) {
      return NetworkImage(serverImageUrl);
    }
    // 3순위: 기본 이미지
    return const AssetImage('assets/mypage/myprofile.png');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SubAppbar(titleText: '프로필 설정'),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              // 키보드 올라올 때 오버플로우 방지
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    const SizedBox(height: 50),

                    /// 프로필 이미지 영역
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFFF8F8F8),
                            // 🔥 [수정 3 적용] 이미지 표시 로직 개선
                            image: DecorationImage(
                              image: _getProfileImageProvider(),
                              fit: BoxFit.cover,
                            ),
                            border: Border.all(
                              color: Colors.grey.shade200,
                            ), // 테두리 옵션
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: -5,
                          child: GestureDetector(
                            onTap: _pickAndProcessImage,
                            child: Container(
                              width: 32, // 터치 영역 확보를 위해 약간 키움
                              height: 32,
                              decoration: const BoxDecoration(
                                color: Color(0xFF1AEDB0),
                                shape: BoxShape.circle,
                                border: Border.fromBorderSide(
                                  BorderSide(color: Colors.white, width: 2),
                                ),
                              ),
                              child: Center(
                                child: SvgPicture.asset(
                                  'assets/mypage/pencil.svg',
                                  width: 16,
                                  height: 16,
                                  colorFilter: const ColorFilter.mode(
                                    Colors.white,
                                    BlendMode.srcIn,
                                  ),
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
          ),

          /// 저장 버튼
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 20.0,
            ),
            alignment: Alignment.center,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              color: _isSaveEnabled
                  ? const Color(0xFF1AEDB0)
                  : const Color(0xFFE0E0E0),
            ),
            child: TextButton(
              onPressed: _isSaveEnabled ? _onSave : null,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.all(16.0),
                minimumSize: const Size.fromHeight(50),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                '저장',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18, // 폰트 사이즈 살짝 조정
                  fontFamily: 'Pretendard Variable',
                  fontWeight: FontWeight.w700,
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
        const SizedBox(height: 10),
        child,
        const SizedBox(height: 24),
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
      onChanged: (value) => _checkSaveEnabled(), // 🔥 텍스트 변경 시 즉시 체크
    );
  }

  Widget _emailField() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _emailController,
            decoration: _inputDecoration('이메일 입력'),
            onChanged: (value) => _checkSaveEnabled(),
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
              color: const Color(0xFFF7F7F7), // 색상 통일
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                hint: const Text('선택'),
                value: _selectedDomain,
                isExpanded: true, // 드롭다운 너비 꽉 차게
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
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
