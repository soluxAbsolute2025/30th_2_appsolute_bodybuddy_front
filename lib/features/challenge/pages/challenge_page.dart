import 'package:flutter/material.dart';
import '../widgets/challenge_scope_toggle.dart';

class ChallengePage extends StatelessWidget {
  const ChallengePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        titleSpacing: 16,
        centerTitle: false,
        title: const Text(
          '바디 챌린지',
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            height: 1.0, // line-height 100%
            letterSpacing: 0,
            color: Colors.black,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Image.asset(
              'asset/challenge/shop.png',
              width: 24,
              height: 24,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            ChallengeScopeToggle(),
            SizedBox(height: 0),
          ],
        ),
      ),
    );
  }
}
