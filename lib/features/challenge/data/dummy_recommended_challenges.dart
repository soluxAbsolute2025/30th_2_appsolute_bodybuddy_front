class RecommendedChallenge {
  final String title;
  final String description;
  final String? imageUrl;

  const RecommendedChallenge({
    required this.title,
    required this.description,
    this.imageUrl,
  });
}


const List<RecommendedChallenge> dummyRecommendedChallenges = [
  RecommendedChallenge(
    title: '하루 만보 걷기',
    description: '매일 10,000보 걷기',
    imageUrl: 'https://cdn-icons-png.flaticon.com/512/3048/3048394.png',
  ),
  RecommendedChallenge(
    title: '주 3회 스트레칭',
    description: '몸 풀기 루틴',
    imageUrl: 'https://cdn-icons-png.flaticon.com/512/2965/2965567.png',
  ),
];
