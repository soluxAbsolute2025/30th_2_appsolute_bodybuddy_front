import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/personal_challenge_create_model.dart';
import '../widgets/personal_challenge_create_controller.dart';
import '../widgets/labeled_text_field.dart';
import '../widgets/bottom_primary_button.dart';
import '../../../modal/top_notice_toast.dart';
import '../api/personal_challenge_api.dart';
import '../../../pages/personal_challenge_page.dart';

class PersonalChallengeInfoPage extends StatefulWidget {
  final PersonalChallengeCreateModel model;

  const PersonalChallengeInfoPage({super.key, required this.model});

  @override
  State<PersonalChallengeInfoPage> createState() =>
      _PersonalChallengeInfoPageState();
}

class _PersonalChallengeInfoPageState extends State<PersonalChallengeInfoPage> {
  late final controller = PersonalChallengeCreateController(widget.model);

  late final titleController = TextEditingController(text: widget.model.title);
  late final descController = TextEditingController(
    text: widget.model.description,
  );

  final _picker = ImagePicker();

  File? get _pickedImage => widget.model.imageFile;

  @override
  void initState() {
    super.initState();

    void onChanged() {
      widget.model.title = titleController.text;
      widget.model.description = descController.text;
      setState(() {});
    }

    titleController.addListener(onChanged);
    descController.addListener(onChanged);
  }

  Future<void> _pickImage() async {
    try {
      final xfile = await _picker.pickImage(source: ImageSource.gallery);
      if (xfile == null) return;

      setState(() {
        widget.model.imageFile = File(xfile.path);
      });
    } catch (_) {}
  }

  void _removeImage() {
    setState(() {
      widget.model.imageFile = null;
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isValid = controller.isInfoPageValid;
    final _api = PersonalChallengeApi();

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
          '개인 챌린지 만들기',
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '챌린지를 소개해 주세요',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 40),
            LabeledTextField(
              label: '챌린지 명',
              hint: '예) 30일 걷기 챌린지',
              controller: titleController,
            ),
            const SizedBox(height: 25),
            LabeledTextField(
              label: '챌린지 설명',
              hint: '예) 매일 10,000보 걷기',
              controller: descController,
            ),
            const SizedBox(height: 50),
            Stack(
              children: [
                GestureDetector(
                  onTap: _pickImage,
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
                        child: _pickedImage == null
                            ? Image.asset(
                                'assets/challenge/image.png',
                                width: 30,
                                height: 30,
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: AspectRatio(
                                  aspectRatio: 16 / 9,
                                  child: Image.file(
                                    _pickedImage!,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                      ),
                    ],
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
            const Spacer(),
            BottomPrimaryButton(
              label: '챌린지 생성하기',
              enabled: isValid,
              onPressed: () async {
                try {
                  await _api.createPersonalChallenge(widget.model);

                  if (!mounted) return;

                  await TopNoticeToast.show(
                    context,
                    message: '개인 챌린지를 만들었어요!',
                    duration: const Duration(milliseconds: 1200),
                  );

                  if (!mounted) return;

                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const PersonalChallengePage()),
                    (route) => false,
                  );
                } catch (e) {
                  // 에러 처리
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
