class CompletedGroupChallenge {
  final String title;
  final String description;
  final String imageUrl;
  final int totalMembers;
  final int currentMembers;
  final bool isSuccess;

  const CompletedGroupChallenge({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.totalMembers,
    required this.currentMembers,
    required this.isSuccess,
  });

  String get memberText => '$currentMembers/$totalMembers명';
}
