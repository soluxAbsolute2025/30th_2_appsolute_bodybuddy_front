class GroupChallengeListItem {
  final int challengeId;
  final String title;
  final String description;
  final int maxParticipants;
  final int currentParticipants;
  final String? imageUrl;

  const GroupChallengeListItem({
    required this.challengeId,
    required this.title,
    required this.description,
    required this.maxParticipants,
    required this.currentParticipants,
    this.imageUrl,
  });

  bool get isFull => currentParticipants >= maxParticipants;
  bool get isRecruiting => !isFull;

  factory GroupChallengeListItem.fromJson(Map<String, dynamic> json) {
    return GroupChallengeListItem(
      challengeId: (json['challengeId'] as num?)?.toInt() ?? 0,
      title: (json['title'] as String?) ?? '',
      description: (json['description'] as String?) ?? '',
      maxParticipants: (json['maxParticipants'] as num?)?.toInt() ?? 0,
      currentParticipants: (json['currentParticipants'] as num?)?.toInt() ?? 0,
      imageUrl: json['imageUrl'] as String?,
    );
  }
}
