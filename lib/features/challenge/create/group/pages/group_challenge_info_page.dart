import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:image_picker/image_picker.dart';

import '../models/group_challenge_create_model.dart';
import '../widgets/group_challenge_create_controller.dart';
import '../api/group_challenge_api.dart';
import '../widgets/group_challenge_created_modal.dart';
import '../widgets/labeled_text_field.dart';
import '../widgets/bottom_primary_button.dart';
import '../../../../../api/dio_client.dart';

class GroupChallengeInfoPage extends StatefulWidget {
  final GroupChallengeCreateModel model;
  const GroupChallengeInfoPage({super.key, required this.model});

  @override
  State<GroupChallengeInfoPage> createState() => _GroupChallengeInfoPageState();
}

class _GroupChallengeInfoPageState extends State<GroupChallengeInfoPage> {
  late final controller = GroupChallengeCreateController(widget.model);

  late final titleC = TextEditingController(text: widget.model.title);
  late final descC = TextEditingController(text: widget.model.description);
  final _picker = ImagePicker();

  bool isLoading = false;

  @override
  void dispose() {
    titleC.dispose();
    descC.dispose();
    super.dispose();
  }

  Future<void> _create() async {
    if (isLoading) return;
    setState(() => isLoading = true);

    try {
      widget.model.title = titleC.text;
      widget.model.description = descC.text;

      final api = GroupChallengeApi(DioClient.dio);

      final res = await api.create(widget.model);

      if (!mounted) return;
      await showDialog(
        context: context,
        builder: (_) => GroupChallengeCreatedModal(groupCode: res.groupCode),
      );

      if (!mounted) return;
      Navigator.popUntil(context, (route) => route.isFirst);
    } on DioException catch (e) {
      if (!mounted) return;

      final status = e.response?.statusCode;
      final message = e.response?.data is Map
          ? (e.response?.data['message']?.toString() ?? e.message)
          : e.message;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('생성 실패${status != null ? ' ($status)' : ''}: $message'),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('생성 실패: $e')));
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> _pickAndProcessImage() async {
    try {
      final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
      if (picked == null) return;

      final CroppedFile? cropped = await ImageCropper().cropImage(
        sourcePath: picked.path,
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
      if (cropped == null) return;

      final dir = await getTemporaryDirectory();
      final targetPath = p.join(
        dir.path,
        'group_${DateTime.now().millisecondsSinceEpoch}_out.jpg',
      );

      final result = await FlutterImageCompress.compressAndGetFile(
        cropped.path,
        targetPath,
        format: CompressFormat.jpeg,
        quality: 80,
      );

      if (result == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('이미지 압축에 실패했어요')),
        );
        return;
      }

      setState(() {
        widget.model.imageFile = File(result.path); 
      });

      print('✅ [IMG] processed file=${widget.model.imageFile!.path}');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('이미지 처리 실패: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    widget.model.title = titleC.text;
    widget.model.description = descC.text;

    final isValid = controller.isCreateValid;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Image.asset(
            'assets/challenge/back_vector.png',
            width: 30,
            height: 30,
          ),
        ),
        title: const Text(
          '그룹 챌린지 만들기',
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            height: 1.0,
            color: Colors.black,
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 32, 20, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '챌린지를 소개해 주세요',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF111111),
                ),
              ),
              const SizedBox(height: 40),

              LabeledTextField(
                label: '챌린지 명',
                hint: '예) 함께 만보 걷기',
                controller: titleC,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 25),

              LabeledTextField(
                label: '챌린지 설명',
                hint: '예) 30일간 매일 10,000보 걷기',
                controller: descC,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 50),

              GestureDetector(
                onTap: _pickAndProcessImage,
                child: Column(
                  children: [
                    const Divider(height: 0.4, color: Color(0xFFA6A6A6)),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 16,
                      ),
                      alignment: Alignment.centerLeft,
                      child: widget.model.imageFile == null
                          ? Image.asset(
                              'assets/challenge/image.png',
                              width: 30,
                              height: 30,
                            )
                          : Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: AspectRatio(
                                    aspectRatio: 16 / 9,
                                    child: Image.file(
                                      widget.model.imageFile!,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        widget.model.imageFile = null;
                                      });
                                    },
                                    child: Image.asset(
                                        'assets/challenge/del_image.png',
                                        width: 20,
                                        height: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: BottomPrimaryButton(
          text: isLoading ? '생성 중...' : '챌린지 생성하기',
          isEnabled: isValid && !isLoading,
          onPressed: _create,
        ),
      ),
    );
  }
}
