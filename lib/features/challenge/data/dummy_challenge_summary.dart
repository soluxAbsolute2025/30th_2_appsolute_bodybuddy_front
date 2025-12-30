class ChallengeSummary {
  final int totalPoint;
  final int successRate; // %

  const ChallengeSummary({
    required this.totalPoint,
    required this.successRate,
  });
}

const dummyChallengeSummary = ChallengeSummary(
  totalPoint: 2450,
  successRate: 85,
);
