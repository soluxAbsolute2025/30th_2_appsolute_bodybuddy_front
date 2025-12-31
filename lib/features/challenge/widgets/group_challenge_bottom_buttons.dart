import 'package:flutter/material.dart';

class GroupChallengeBottomButtons extends StatelessWidget {
  const GroupChallengeBottomButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {},
              child: const Text('챌린지 공유'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1DE9B6),
              ),
              child: const Text('인증하기'),
            ),
          ),
        ],
      ),
    );
  }
}
