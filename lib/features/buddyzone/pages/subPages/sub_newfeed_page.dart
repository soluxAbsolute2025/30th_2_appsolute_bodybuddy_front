import 'package:bodybuddy_frontend/common/widgets/sub_appbar.dart';
import 'package:bodybuddy_frontend/features/buddyzone/api/buddyzone_hottag_api.dart';
import 'package:bodybuddy_frontend/features/buddyzone/models/feeds/feed_post_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'dart:io';

// [새로 만든 파일들 import 필수]
import '../../widgets/feeds/feed_hashtag_editting.dart';
import '../../widgets/feeds/feed_image_preview.dart';
import '../../widgets/feeds/feed_text_field.dart';

class SubNewFeedPages extends StatefulWidget {
  const SubNewFeedPages({super.key});

  @override
  State<SubNewFeedPages> createState() => _SubNewFeedPagesState();
}

class _SubNewFeedPagesState extends State<SubNewFeedPages> {
  // 분리한 컨트롤러 사용
  late final HashtagEditingController postController;
  final TextEditingController locationController = TextEditingController();

  String visible = "PUBLIC";
  bool get _isFormValid => postController.text.isNotEmpty;

  File? _selectedImage;
  List<String> _tags = [];

  @override
  void initState() {
    super.initState();
    postController = HashtagEditingController();
  }

  @override
  void dispose() {
    postController.dispose();
    locationController.dispose();
    super.dispose();
  }

  Future<void> _postFeed() async {
    print("피드 작성 완료");
    PostFeedModel postFeedModel = PostFeedModel(
      content: postController.text,
      place: locationController.text,
      visibility: visible,
      hashtags: _tags,
    );
    print(postFeedModel.toJsonString());

    await FeedPostRequst().uplodePost(
      request: postFeedModel,
      imageFile: _selectedImage,
    );
  }

  void switchVisible() {
    setState(() {
      visible = (visible == "PUBLIC") ? "SECRET" : "PUBLIC";
    });
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
      quality: 80,
    );

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
        onFormSubmit: _postFeed,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _profileWidget(), // 이건 그냥 여기에 두는게 편합니다.
                  const SizedBox(height: 3.0),

                  Container(
                    margin: const EdgeInsets.only(left: 49.0, right: 16.0),
                    child: FeedTextField(
                      controller: postController,
                      hintText: '오늘도 운동하셨나요? 친구들과 공유해보세요!',
                      onChanged: (value) => _extractHashTags(value),
                    ),
                  ),

                  // 사진 미리보기
                  if (_selectedImage != null)
                    FeedImagePreview(
                      imageFile: _selectedImage!,
                      onDelete: () {
                        setState(() {
                          _selectedImage = null;
                        });
                        print("이미지 삭제됨");
                      },
                    ),

                  Container(
                    width: double.infinity,
                    height: 12.0,
                    decoration: const BoxDecoration(color: Color(0xFFF8F8F8)),
                  ),

                  // [분리됨] 위치 입력창 (재사용)
                  Container(
                    margin: const EdgeInsets.only(left: 49.0, right: 16.0),
                    child: FeedTextField(
                      controller: locationController,
                      hintText: '친구들에게 내 위치를 공유해보세요!',
                      isImage: true, // 위치 아이콘 활성화
                      minLines: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 하단 버튼 영역
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 16.0,
            ),
            decoration: const BoxDecoration(
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
                      foregroundColor: const Color(0x1188D3BD),
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
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

  // 프로필 위젯은 데이터 바인딩 때문에 여기에 남겨둠
  Widget _profileWidget() {
    return Container(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
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
                    image: const AssetImage(
                      'assets/images/common/profile1.jpg',
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10.0),
              const Text(
                '김헬스',
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'Pretendard',
                ),
              ),
              const SizedBox(width: 10.0),
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 1.0,
                  horizontal: 10.0,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE9FFF9),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: const Text(
                  'Lv.15',
                  style: TextStyle(
                    color: Color(0xFF1AEDB1),
                    fontSize: 11.0,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Pretendard',
                  ),
                ),
              ),
              const SizedBox(width: 20.0),
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
        foregroundColor: const Color(0xFF87D2BD),
        backgroundColor: const Color(0xFFFFFFFF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
          side: const BorderSide(color: Color(0xFF1AEDB0), width: 1.0),
        ),
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
      ),
      onPressed: () {
        switchVisible(); // setState 함수 호출
        print(visible);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 13.0),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0)),
        child: Row(
          children: [
            if (visible == "PUBLIC") ...[
              SvgPicture.asset('assets/buddyzone/public.svg'),
              const SizedBox(width: 6.0),
            ],
            if (visible == "SECRET") ...[
              SvgPicture.asset('assets/buddyzone/mine.svg'),
              const SizedBox(width: 6.0),
            ],
            Text(
              visible == "PUBLIC" ? '전체 공개' : '나만 보기',
              style: const TextStyle(
                color: Color(0xFF1AEDB0),
                fontSize: 14,
                fontFamily: 'Pretendard Variable',
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(width: 8.0),
            SvgPicture.asset('assets/buddyzone/bottom_arrow.svg'),
          ],
        ),
      ),
    );
  }
}
