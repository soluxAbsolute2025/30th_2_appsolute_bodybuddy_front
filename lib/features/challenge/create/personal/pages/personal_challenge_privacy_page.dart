import 'package:flutter/material.dart';

import '../data/personal_challenge_privacy_options.dart';
import '../models/personal_challenge_create_model.dart';
import '../widgets/personal_challenge_privacy_tile.dart';
import 'personal_challenge_info_page.dart';
import '../widgets/bottom_primary_button.dart';

class PersonalChallengePrivacyPage extends StatefulWidget {
  final PersonalChallengeCreateModel model;
  const PersonalChallengePrivacyPage({super.key, required this.model});

  @override
  State<PersonalChallengePrivacyPage> createState() =>
      _PersonalChallengePrivacyPageState();
}

class _PersonalChallengePrivacyPageState
    extends State<PersonalChallengePrivacyPage> {
  @override
  Widget build(BuildContext context) {
    final isValid = widget.model.visibility != null;

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
          '개인 챌린지 만들기',
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

            ...PersonalChallengePrivacyOptions.items.map(
              (opt) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: PersonalChallengePrivacyTile(
                  value: opt.value,
                  title: opt.title,
                  subtitle: opt.subtitle,
                  groupValue: widget.model.visibility, // ✅ 변경
                  onChanged: (v) => setState(() {
                    widget.model.visibility = v; // ✅ 변경
                  }),
                ),
              ),
            ),

            const Spacer(),
            BottomPrimaryButton(
              label: '다음',
              enabled: isValid, // ✅ 변경(또는 widget.model.visibility != null)
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        PersonalChallengeInfoPage(model: widget.model),
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
