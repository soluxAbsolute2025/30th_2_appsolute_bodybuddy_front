enum ChallengeType {
  daily,  
  weekly, 
}

class Challenge {
  final String title;
  final String description;
  final int current;
  final int total;
  final int rewardXp;
  final int dDay;
  final String? imageUrl;
  final String category;

  const Challenge({
    required this.title,
    required this.description,
    required this.current,
    required this.total,
    required this.rewardXp,
    required this.dDay,
    this.imageUrl,
    required this.category,
  });

  double get progress => current / total;
}
