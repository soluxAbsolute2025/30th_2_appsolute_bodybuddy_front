class RecruitingGroupChallenge {
  final String title;
  final String description;
  final String imageUrl;
  final int totalMembers;
  final int currentMembers;
  final bool isRecruiting;

  const RecruitingGroupChallenge({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.totalMembers,
    required this.currentMembers,
    required this.isRecruiting,
  });

  bool get isFull => currentMembers >= totalMembers;
}
