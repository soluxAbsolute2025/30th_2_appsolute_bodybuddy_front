import 'package:flutter/material.dart';
import '../models/group_challenge.dart';

class GroupChallengeInfoSection extends StatelessWidget {
  final GroupChallenge challenge;

  const GroupChallengeInfoSection({
    super.key,
    required this.challenge,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            challenge.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _InfoRow(
            icon: Icons.calendar_today,
            text:
                '${_format(challenge.startDate)} ~ ${_format(challenge.endDate)}',
          ),
          _InfoRow(
            icon: Icons.people,
            text:
                '${challenge.currentParticipants}명 참여 / ${challenge.maxParticipants}명',
          ),
          _InfoRow(
            icon: Icons.lock_open,
            text: challenge.isPublic ? '친구 공개' : '비공개',
          ),
        ],
      ),
    );
  }

  String _format(DateTime d) => '${d.year}.${d.month}.${d.day}';
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.green),
          const SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }
}
