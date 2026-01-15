import 'package:flutter/material.dart';

import '../data/group_challenge_privacy_options.dart';
import '../models/group_challenge_create_model.dart';
import '../widgets/group_challenge_create_controller.dart';
import '../widgets/group_challenge_privacy_tile.dart';
import 'group_challenge_info_page.dart';

import '../widgets/bottom_primary_button.dart';

class GroupChallengePrivacyPage extends StatefulWidget {
  final GroupChallengeCreateModel model;
  const GroupChallengePrivacyPage({super.key, required this.model});

  @override
  State<GroupChallengePrivacyPage> createState() => _GroupChallengePrivacyPageState();
}

class _GroupChallengePrivacyPageState extends State<GroupChallengePrivacyPage> {
  late final controller = GroupChallengeCreateController(widget.model);

  @override
  Widget build(BuildContext context) {
    final isValid = controller.isPrivacyPageValid;

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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '챌린지 공개 여부를\n설정해주세요',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 40),

            ...GroupChallengePrivacyOptions.items.map((opt) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GroupChallengePrivacyTile(
                    value: opt.value,
                    title: opt.title,
                    subtitle: opt.subtitle,
                    groupValue: widget.model.privacyScope,
                    onChanged: (v) => setState(() => widget.model.privacyScope = v),
                  ),
                )),

            const Spacer(),
            BottomPrimaryButton(
              text: '다음',
              isEnabled: isValid,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => GroupChallengeInfoPage(model: widget.model),
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
