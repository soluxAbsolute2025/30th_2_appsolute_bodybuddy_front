import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/group_challenge_create_model.dart';
import '../widgets/group_challenge_create_controller.dart';
import '../widgets/group_challenge_participant_counter.dart';
import '../widgets/bottom_primary_button.dart';
import '../widgets/labeled_text_field.dart';
import 'group_challenge_privacy_page.dart';

class GroupChallengeTypePage extends StatefulWidget {
  final GroupChallengeCreateModel model;
  const GroupChallengeTypePage({super.key, required this.model});

  @override
  State<GroupChallengeTypePage> createState() => _GroupChallengeTypePageState();
}

class _GroupChallengeTypePageState extends State<GroupChallengeTypePage> {
  late final TextEditingController _periodController;

  @override
  void initState() {
    super.initState();
    _periodController = TextEditingController(
      text: widget.model.period?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _periodController.dispose();
    super.dispose();
  }

  void _dec() => setState(() {
    if (widget.model.maxParticipants > 2) widget.model.maxParticipants--;
  });

  void _inc() => setState(() {
    if (widget.model.maxParticipants < 99) widget.model.maxParticipants++;
  });

  @override
  Widget build(BuildContext context) {
    final controller = GroupChallengeCreateController(widget.model);
    final isValid = controller.isTypePageValid;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
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
            height: 1.0,
            letterSpacing: 0,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '기간과 함께 할\n최대 인원을 설정해주세요!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 40),

            LabeledTextField(
              label: '기간',
              hint: '최소 7일 이상으로 설정해 주세요',
              controller: _periodController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              suffixText: '일',
              onChanged: (value) {
                final parsed = int.tryParse(value.trim());
                widget.model.period = parsed; // int?
                setState(() {});
              },
            ),

            const SizedBox(height: 25),
            const Text(
              '최대 인원',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            GroupChallengeParticipantCounter(
              value: widget.model.maxParticipants,
              onDecrease: _dec,
              onIncrease: _inc,
            ),

            const Spacer(),
            BottomPrimaryButton(
              text: '다음',
              isEnabled: isValid,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        GroupChallengePrivacyPage(model: widget.model),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
