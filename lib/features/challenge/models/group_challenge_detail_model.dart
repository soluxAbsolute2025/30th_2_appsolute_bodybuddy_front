class GroupChallengeDetail {
  final String title;
  final DateTime startDate;
  final DateTime endDate;
  final bool isPublic;
  final String description;
  final int currentParticipants;
  final int maxParticipants;
  final String? imageUrl;
  final List<ChallengeRank> ranks;

  const GroupChallengeDetail({
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.isPublic,
    required this.description,
    required this.currentParticipants,
    required this.maxParticipants,
    required this.ranks,
    this.imageUrl,
  });
}

class ChallengeRank {
  final int rank;
  final String name;
  final bool isMe;
  final String? profileImageUrl; 

  const ChallengeRank({
    required this.rank,
    required this.name,
    this.isMe = false,
    this.profileImageUrl,
  });
}
