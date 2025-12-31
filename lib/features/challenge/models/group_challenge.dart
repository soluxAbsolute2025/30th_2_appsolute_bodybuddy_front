class GroupChallenge {
  final String title;
  final DateTime startDate;
  final DateTime endDate;
  final int currentParticipants;
  final int maxParticipants;
  final bool isPublic;
  final String description;
  final List<ChallengeRank> ranks;

  const GroupChallenge({
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.currentParticipants,
    required this.maxParticipants,
    required this.isPublic,
    required this.description,
    required this.ranks,
  });
}

class ChallengeRank {
  final int rank;
  final String name;
  final bool isMe;

  const ChallengeRank({
    required this.rank,
    required this.name,
    this.isMe = false,
  });
}
