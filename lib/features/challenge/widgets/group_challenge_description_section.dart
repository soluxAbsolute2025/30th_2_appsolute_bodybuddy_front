import 'package:flutter/material.dart';
import '../models/group_challenge_detail_model.dart';

class GroupChallengeDescriptionSection extends StatelessWidget {
  final GroupChallengeDetail challenge;

  const GroupChallengeDescriptionSection({
    super.key,
    required this.challenge,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '챌린지 설명',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),

          Padding(
            padding: const EdgeInsets.only(left: 1), 
            child: Text(
              challenge.description,
              style: const TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 1.0,
                letterSpacing: 0,
                color: Color(0xFF747474),
              ),
            ),
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}
