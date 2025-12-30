import 'package:flutter/material.dart';
import '../../../common/widgets/main_appbar.dart';
import '../widgets/challenge_floating_button.dart'; 
import 'personal_challenge_page.dart';
import 'group_challenge_page.dart';
import '../widgets/challenge_scope_toggle.dart';

class ChallengePage extends StatefulWidget {
  const ChallengePage({super.key});

  @override
  State<ChallengePage> createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengePage> {
  bool isPersonalSelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppbar(
        navIndex: 2,
        titleText: '바디 챌린지',
        imageUrl: 'assets/challenge/shop.svg',
        buttonText: '상점',
        onButtonPressed: () {},
      ),
      body: Column(
        children: [
          ChallengeScopeToggle(
            isPersonalSelected: isPersonalSelected,
            onChanged: (value) {
              setState(() {
                isPersonalSelected = value;
              });
            },
          ),
          Expanded(
            child: isPersonalSelected
                ? const PersonalChallengePage()
                : const GroupChallengePage(),
          ),
        ],
      ),
      floatingActionButton: Visibility(
        visible: isPersonalSelected,
        maintainState: true,
        maintainAnimation: true,
        maintainSize: true,
        child: ChallengeFloatingButton(
          onPressed: () {},
        ),
      ),
    );
  }
}
