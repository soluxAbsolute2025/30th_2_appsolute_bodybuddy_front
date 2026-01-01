class OngoingChallenge {
  final int challengeId;
  final String title;
  final int dday;
  final String? profileUrl;

  OngoingChallenge({
    required this.challengeId,
    required this.title,
    required this.dday,
    this.profileUrl,
  });

  factory OngoingChallenge.fromJson(Map<String, dynamic> json) {
    return OngoingChallenge(
      challengeId: json['challengeId'],
      title: json['title'],
      dday: json['dday'],
      profileUrl: json['profileUrl'],
    );
  }
}
