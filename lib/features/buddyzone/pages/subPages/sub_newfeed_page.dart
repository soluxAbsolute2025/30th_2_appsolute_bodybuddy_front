import 'package:bodybuddy_frontend/common/widgets/sub_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'dart:io';

class SubNewFeedPages extends StatefulWidget {
  const SubNewFeedPages({super.key});

  @override
  State<SubNewFeedPages> createState() => _SubNewFeedPagesState();
}

class _SubNewFeedPagesState extends State<SubNewFeedPages> {
  late final HashtagEditingController postController;
  final TextEditingController locationController = TextEditingController();
  String visible = "PUBLIC";

  bool get _isFormValid =>
      postController.text.isNotEmpty && locationController.text.isNotEmpty;

  // 이미지 저장 변수
  File? _selectedImage;

  // 추출된 해시태그를 저장할 리스트
  List<String> _tags = [];

  @override
  void initState() {
    super.initState();
    postController = HashtagEditingController();
  }

  void dispose() {
    // 컨트롤러는 꼭 해제해줘야 메모리 누수가 없습니다.
    postController.dispose();
    locationController.dispose();
    super.dispose();
  }

  void switchVisible() {
    if (visible == "PUBLIC") {
      visible = "FRIEND";
    } else {
      visible = "PUBLIC";
    }
  }

  void _extractHashTags(String text) {
    final RegExp regExp = RegExp(r'#[^\s#]+');
    final matches = regExp.allMatches(text);

    setState(() {
      _tags = matches.map((m) => m.group(0)!.substring(1)).toList();
    });
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
      quality: 80, // 압축 품질 (0~100)
    );

    // 4. 화면 갱신
    if (result != null) {
      setState(() {
        _selectedImage = File(result.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SubAppbar(
        imageUrl: 'assets/buddyzone/xFeed.svg',
        isButton: true,
        isFormValid: _isFormValid,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _profileWidget(),
                  SizedBox(height: 3.0),
                  Container(
                    margin: EdgeInsets.only(left: 49.0, right: 16.0),
                    child: _textField(
                      controller: postController,
                      hintText: '오늘도 운동하셨나요? 친구들과 공유해보세요!',
                      onChanged: (value) => _extractHashTags(value),
                    ),
                  ),
                  if (_selectedImage != null) ...[
                    Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 49.0, right: 16.0),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          clipBehavior: Clip.hardEdge,
                          child: AspectRatio(
                            aspectRatio: 1 / 1,
                            child: Image.file(
                              _selectedImage!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        Positioned(
                          top: 10,
                          right: 26,
                          child: GestureDetector(
                            onTap: () {
                              // [삭제 로직] 변수를 비우고 화면을 갱신합니다.
                              setState(() {
                                _selectedImage = null;
                              });
                              print("이미지 삭제됨");
                            },
                            child: Image(
                              width: 20,
                              height: 20,
                              image: AssetImage(
                                'assets/buddyzone/del_image.png',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  Container(
                    width: double.infinity,
                    height: 12.0,
                    decoration: BoxDecoration(color: Color(0xFFF8F8F8)),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 49.0, right: 16.0),
                    child: _textField(
                      controller: locationController,
                      hintText: '친구들에게 내 위치를 공유해보세요!',
                      isImage: true,
                      minLines: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Color(0xFFE8E8E8), width: 1.0),
              ),
            ),
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 10.0),
                  width: 40.0,
                  height: 40.0,
                  child: TextButton(
                    onPressed: () {
                      print("사진 버튼 클릭");
                      _pickAndProcessImage();
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Color(0x1188D3BD),
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      // 터치 영역을 내용물에 맞춤
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/buddyzone/pictureFeed.svg',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _textField({
    required String hintText,
    required TextEditingController controller,
    String? content,
    int minLines = 5,
    bool isImage = false,
    Function(String)? onChanged,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isImage)
          Padding(
            padding: const EdgeInsets.only(
              top: 21,
              left: 16.0,
            ), // 아이콘과 텍스트 사이 간격
            child: SvgPicture.asset(
              controller.text.isEmpty
                  ? 'assets/buddyzone/big_gps_false.svg'
                  : 'assets/buddyzone/big_gps_true.svg',
            ),
          ),

        Expanded(
          child: TextField(
            controller: controller,
            onChanged: (value) {
              setState(() {});
              if (onChanged != null) {
                onChanged(value);
              }
            },
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w400,
              height: 1.50,
            ),
            maxLines: null,
            minLines: minLines,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                color: const Color(0xFFA6A6A6),
                fontSize: 16,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w500,
                height: 1.50,
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderSide: BorderSide.none),
              enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
            ),
          ),
        ),
      ],
    );
  }

  Widget _profileWidget() {
    return Container(
      padding: EdgeInsets.only(left: 16.0, right: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(
                width: 37.0,
                height: 37.0,
                child: ClipOval(
                  child: Image(
                    image: AssetImage('assets/images/common/profile1.jpg'),
                  ),
                ),
              ),
              SizedBox(width: 10.0),
              Text(
                '김헬스',
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'Pretendard',
                ),
              ),
              SizedBox(width: 10.0),
              Container(
                padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 10.0),
                decoration: BoxDecoration(
                  color: Color(0xFFE9FFF9),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Text(
                  'Lv.15',
                  style: TextStyle(
                    color: Color(0xFF1AEDB1),
                    fontSize: 11.0,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Pretendard',
                  ),
                ),
              ),
              SizedBox(width: 20.0),
            ],
          ),
          _visibleButton(),
        ],
      ),
    );
  }

  Widget _visibleButton() {
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: Color(0xFF87D2BD),
        backgroundColor: Color(0xFFFFFFFF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
          side: BorderSide(color: Color(0xFF1AEDB0), width: 1.0),
        ),
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
      ),
      onPressed: () {
        setState(() {
          switchVisible();
        });
        print(visible);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 7.0, horizontal: 13.0),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0)),
        child: Row(
          children: [
            if (visible == "PUBLIC") ...[
              SvgPicture.asset('assets/buddyzone/public.svg'),
              SizedBox(width: 6.0),
            ],
            if (visible == "FRIEND") ...[
              Image(image: AssetImage('assets/buddyzone/link.png')),
              SizedBox(width: 4.0),
              SvgPicture.asset('assets/buddyzone/friend.svg'),
              SizedBox(width: 6.0),
            ],
            Text(
              visible == "PUBLIC" ? '전체 공개' : '친구 공개',
              style: TextStyle(
                color: const Color(0xFF1AEDB0),
                fontSize: 14,
                fontFamily: 'Pretendard Variable',
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(width: 8.0),
            SvgPicture.asset('assets/buddyzone/bottom_arrow.svg'),
          ],
        ),
      ),
    );
  }
}

class HashtagEditingController extends TextEditingController {
  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final String content = text;
    final RegExp regExp = RegExp(r'#[^\s#]+|[^#]+');
    final matches = regExp.allMatches(content);

    List<TextSpan> spans = [];

    for (final match in matches) {
      final String word = match.group(0)!;

      if (word.startsWith('#')) {
        spans.add(
          TextSpan(
            text: word,
            style: style?.copyWith(
              color: const Color(0xFF18D9A2), // 민트색 (원하는 색으로 변경 가능)
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      } else {
        spans.add(TextSpan(text: word, style: style));
      }
    }
    return TextSpan(style: style, children: spans);
  }
}
