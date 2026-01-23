import 'package:flutter/material.dart';
import '../models/group_challenge_detail_model.dart';

class GroupChallengeRankItem extends StatelessWidget {
  final ChallengeRank rank;

  const GroupChallengeRankItem({
    super.key,
    required this.rank,
  });

  @override
  Widget build(BuildContext context) {
    final bool isMe = rank.isMe;
    final bool isFirst = rank.rank == 1;

    Color backgroundColor;
    if (isMe) {
      backgroundColor = const Color(0xFFB8FFEB);
    } else if (isFirst) {
      backgroundColor = const Color(0xFFFFFBB2);
    } else {
      backgroundColor = Colors.white;
    }

    return Container(
      width: double.infinity,
      height: 30, 
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(5), 
        border: isFirst
          ? null
          : Border.all(
              color: isMe
                  ? const Color(0xFF1AEDB1)
                  : const Color(0xFFEBEBEB), 
              width: 0.5, 
            ),
      ),
      child: Row(
        children: [
          /// 순위
          SizedBox(
            width: 16,
            child:Text(
              '${rank.rank}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: rank.isMe ? FontWeight.w700 : FontWeight.w500,
                height: 1.0,
                letterSpacing: 0,
                color: rank.isMe
                    ? const Color(0xFF00D397)
                    : Colors.black,  
              ),
            ),
          ),

          const SizedBox(width: 4),

          /// 프로필 원
          Container(
            width: 17,
            height: 17,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: _RankProfileImage(url: rank.profileImageUrl),
            ),
          ),

          const SizedBox(width: 5),

          /// 이름
          Text(
            rank.name,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class _RankProfileImage extends StatelessWidget {
  final String? url;

  const _RankProfileImage({required this.url});

  bool get _useNetwork {
    final u = url?.trim();
    if (u == null) return false;
    if (u.isEmpty) return false;
    if (u.toLowerCase() == 'null') return false;
    return u.startsWith('http://') || u.startsWith('https://');
  }

  @override
  Widget build(BuildContext context) {
    return _useNetwork
        ? Image.network(
            url!.trim(),
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) {
              return Image.asset(
                'assets/challenge/profile.png',
                fit: BoxFit.cover,
              );
            },
          )
        : Image.asset(
            'assets/challenge/profile.png',
            fit: BoxFit.cover,
          );
  }
}
