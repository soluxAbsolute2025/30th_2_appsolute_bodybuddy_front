class OngoingChallenge {
  final int challengeId;
  final String title;
  final int? dday;
  final int? rank;
  final String? profileUrl;

  OngoingChallenge({
    required this.challengeId,
    required this.title,
    this.dday,
    this.rank,
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
