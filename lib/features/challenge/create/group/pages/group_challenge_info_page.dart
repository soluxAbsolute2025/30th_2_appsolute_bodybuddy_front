import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/group_challenge_create_model.dart';
import '../widgets/group_challenge_create_controller.dart';
import '../widgets/labeled_text_field.dart';
import '../widgets/bottom_primary_button.dart';
import '../api/group_challenge_api.dart';
import '../pages/group_challenge_created_page.dart';

class GroupChallengeInfoPage extends StatefulWidget {
  final GroupChallengeCreateModel model;
  const GroupChallengeInfoPage({super.key, required this.model});

  @override
  State<GroupChallengeInfoPage> createState() => _GroupChallengeInfoPageState();
}

class _GroupChallengeInfoPageState extends State<GroupChallengeInfoPage> {
  late final titleC = TextEditingController(text: widget.model.title);
  late final descC = TextEditingController(text: widget.model.description);

  bool isLoading = false;

  XFile? get _pickedImage => widget.model.imageFile;

  @override
  void dispose() {
    titleC.dispose();
    descC.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (file == null) return;

    setState(() {
      widget.model.imageFile = file;
    });
  }

  void _removeImage() {
    setState(() {
      widget.model.imageFile = null;
    });
  }

  Future<void> _create() async {
    if (isLoading) return;

    // ✅ create 직전에 모델 반영
    widget.model.title = titleC.text.trim();
    widget.model.description = descC.text.trim();

    final controller = GroupChallengeCreateController(widget.model);
    if (!controller.isCreateValid) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('입력값을 확인해 주세요.')));
      return;
    }

    setState(() => isLoading = true);

    try {
      // ✅ 너가 이미 만들어 둔 multipart API (DioClient.dio 사용 버전)로 연결해야 함
      final api = GroupChallengeApi();
      final res = await api.createGroupChallenge(widget.model);

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => GroupChallengeCreatedPage(groupCode: res.groupCode),
        ),
      );
      if (!mounted) return;
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

  @override
  Widget build(BuildContext context) {
    widget.model.title = titleC.text.trim();
    widget.model.description = descC.text.trim();
    // ✅ build에서는 controller만 읽기
    final controller = GroupChallengeCreateController(widget.model);
    final isValid = controller.isCreateValid;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Image.asset(
            'assets/challenge/back_vector.png',
            width: 24,
            height: 24,
          ),
        ),
        title: const Text(
          '그룹 챌린지 만들기',
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(16),
          child: SizedBox(height: 16),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // ✅ 위 내용은 스크롤 영역
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '챌린지를 소개해 주세요',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
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

                      // ✅ 이미지 영역도 너무 커지지 않게 살짝 제한(선택이지만 추천)
                            GestureDetector(
                              onTap: _pickImage,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Divider(
                                    height: 0.4,
                                    color: Color(0xFFA6A6A6),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 16,
                                    ),
                                    alignment: Alignment.centerLeft,
                                    child: _pickedImage == null
                                        ? Image.asset(
                                            'assets/challenge/image.png',
                                            width: 30,
                                            height: 30,
                                          )
                                        : ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            child: AspectRatio(
                                              aspectRatio: 16 / 9,
                                              child: Image.file(
                                                File(_pickedImage!.path),
                                                width: double.infinity,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                  ),
                            if (_pickedImage != null)
                              Positioned(
                                right: 8,
                                top: 8,
                                child: GestureDetector(
                                  onTap: _removeImage,
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

                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),

              // ✅ 아래 버튼은 항상 고정 + SafeArea로 홈 인디케이터 침범 방지
              SafeArea(
                top: false,
                child: BottomPrimaryButton(
                  text: isLoading ? '생성 중...' : '챌린지 생성하기',
                  isEnabled: isValid && !isLoading,
                  onPressed: _create,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
