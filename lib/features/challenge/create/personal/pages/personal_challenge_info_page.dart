import 'package:flutter/material.dart';

import '../models/personal_challenge_create_model.dart';
import '../widgets/personal_challenge_create_controller.dart';
import '../widgets/labeled_text_field.dart';
import '../widgets/bottom_primary_button.dart';

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
  late final descController =
      TextEditingController(text: widget.model.description);

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

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isValid = controller.isInfoPageValid;

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
            const Spacer(),
            BottomPrimaryButton(
              label: '챌린지 생성하기',
              enabled: isValid,
              onPressed: () async {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
            ),
          ],
        ),
      ),
    );
  }
}
