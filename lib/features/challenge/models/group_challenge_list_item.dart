enum GroupChallengeStatus { recruiting, ongoing, unknown }

GroupChallengeStatus groupChallengeStatusFromString(String? value) {
  switch (value) {
    case 'RECRUITING':
      return GroupChallengeStatus.recruiting;
    case 'ONGOING':
      return GroupChallengeStatus.ongoing;
    default:
      return GroupChallengeStatus.unknown;
  }
}

class GroupChallengeListItem {
  final int challengeId;
  final String title;
  final String description;

  final String startDate;
  final String endDate;

  final int maxParticipants;
  final int currentParticipants;

  final GroupChallengeStatus status;
  final String groupCode;
  final String? imageUrl;

  const GroupChallengeListItem({
    required this.challengeId,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.maxParticipants,
    required this.currentParticipants,
    required this.status,
    required this.groupCode,
    this.imageUrl,
  });

  bool get isRecruiting => status == GroupChallengeStatus.recruiting;
  bool get isOngoing => status == GroupChallengeStatus.ongoing;

  factory GroupChallengeListItem.fromJson(Map<String, dynamic> json) {
    return GroupChallengeListItem(
      challengeId: (json['challengeId'] as num?)?.toInt() ?? 0,
      title: (json['title'] as String?) ?? '',
      description: (json['description'] as String?) ?? '',
      startDate: (json['startDate'] as String?) ?? '',
      endDate: (json['endDate'] as String?) ?? '',
      maxParticipants: (json['maxParticipants'] as num?)?.toInt() ?? 0,
      currentParticipants: (json['currentParticipants'] as num?)?.toInt() ?? 0,
      status: groupChallengeStatusFromString(json['status'] as String?),
      groupCode: (json['groupCode'] as String?) ?? '',
      imageUrl: json['imageUrl'] as String?,
    );
  }
}
