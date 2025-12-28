class CompletedChallenge {
  final String title;
  final String description;
  final String? imageUrl;

  const CompletedChallenge({
    required this.title,
    required this.description,
    this.imageUrl,
  });
}

const List<CompletedChallenge> dummyCompletedChallenges = [
  CompletedChallenge(
    title: '7일 수면 챌린지',
    description: '매일 8시간 수면',
    imageUrl: 'https://cdn-icons-png.flaticon.com/512/2965/2965567.png',
  ),
  CompletedChallenge(
    title: '건강한 식단 14일',
    description: '균형잡힌 식사 기록',
    imageUrl: 'null',
  ),
];