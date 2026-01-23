class OngoingGroupChallenge {
  final int challengeId;
  final String title;
  final String groupCode;
  final String? imageUrl;

  final int myRank;
  final int participantCount;
  final int remainingDays;

  final List<TopParticipant> topParticipants;

  const OngoingGroupChallenge({
    required this.challengeId,
    required this.title,
    required this.groupCode,
    this.imageUrl,
    required this.myRank,
    required this.participantCount,
    required this.remainingDays,
    required this.topParticipants,
  });

  factory OngoingGroupChallenge.fromJson(Map<String, dynamic> json) {
    return OngoingGroupChallenge(
      challengeId: json['challengeId'] as int,
      title: json['title'] ?? '',
      groupCode: json['groupCode'] ?? '',
      imageUrl: json['imageUrl'] as String?,

      myRank: json['myRank'] ?? 0,
      participantCount: json['participantCount'] ?? 0,
      remainingDays: json['remainingDays'] ?? 0,

      topParticipants: (json['topParticipants'] as List<dynamic>?)
              ?.map((e) => TopParticipant.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class TopParticipant {
  final int rank;
  final String nickname;
  final String? profileImageUrl;
  final double achievementRate;
  final bool isMe;

  const TopParticipant({
    required this.rank,
    required this.nickname,
    this.profileImageUrl,
    required this.achievementRate,
    required this.isMe,
  });

  factory TopParticipant.fromJson(Map<String, dynamic> json) {
    return TopParticipant(
      rank: json['rank'] ?? 0,
      nickname: json['nickname'] ?? '',
      profileImageUrl: json['profileImageUrl'] as String?,
      achievementRate:
          json['achievementRate'] == null
              ? 0.0
              : (json['achievementRate'] as num).toDouble(),
      isMe: json['isMe'] ?? false,
    );
  }
}
