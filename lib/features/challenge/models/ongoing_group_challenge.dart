class OngoingGroupChallenge {
  final int challengeId;
  final String title;
  final String groupCode;
  final String? imageUrl;
  final int myRank;
  final int participantCount;
  final int remainingDays;
  final List<TopParticipant> topParticipants;

  OngoingGroupChallenge({
    required this.challengeId,
    required this.title,
    required this.groupCode,
    required this.imageUrl,
    required this.myRank,
    required this.participantCount,
    required this.remainingDays,
    required this.topParticipants,
  });

  factory OngoingGroupChallenge.fromJson(Map<String, dynamic> json) {
    return OngoingGroupChallenge(
      challengeId: (json['challengeId'] as num?)?.toInt() ?? 0,
      title: json['title'] ?? '',
      groupCode: json['groupCode'] ?? '',
      imageUrl: json['imageUrl'] as String?,
      myRank: (json['myRank'] as num?)?.toInt() ?? 1,
      participantCount: (json['participantCount'] as num?)?.toInt() ?? 0,
      remainingDays: (json['remainingDays'] as num?)?.toInt() ?? 0,
      topParticipants: (json['topParticipants'] as List<dynamic>? ?? [])
          .map((e) => TopParticipant.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class TopParticipant {
  final int rank;
  final String nickname;
  final String? profileImageUrl;
  final double achievementRate;
  final bool isMe;

  TopParticipant({
    required this.rank,
    required this.nickname,
    required this.profileImageUrl,
    required this.achievementRate,
    required this.isMe,
  });

  factory TopParticipant.fromJson(Map<String, dynamic> json) {
    return TopParticipant(
      rank: (json['rank'] as num?)?.toInt() ?? 0,
      nickname: json['nickname'] ?? '',
      profileImageUrl: json['profileImageUrl'] as String?,
      achievementRate: (json['achievementRate'] as num?)?.toDouble() ?? 0.0,
      isMe: json['isMe'] ?? false,
    );
  }
}
