import 'package:flutter/material.dart';

import '../../../common/widgets/main_appbar.dart';
import '../../shop/pages/shop_page.dart';

import '../widgets/challenge_scope_toggle.dart';
import '../widgets/challenge_floating_button.dart';

import 'personal_challenge_page.dart';
import 'group_challenge_page.dart';
import '../create/personal/pages/personal_challenge_type_page.dart';

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
        onButtonPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ShopPage()),
          );
        },
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

      // 개인 탭일 때만 FAB 보이기(공간 유지 옵션 포함)
      floatingActionButton: Visibility(
        visible: isPersonalSelected,
        maintainState: true,
        maintainAnimation: true,
        maintainSize: true,
        child: ChallengeFloatingButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute(
                builder: (_) => const PersonalChallengeTypePage(),
              ),
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
