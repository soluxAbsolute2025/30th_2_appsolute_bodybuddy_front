class ShopPoints {
  final int currentPoints;
  final int earnedPoints;
  final int usedPoints;
  final int rewardCount;

  ShopPoints({
    required this.currentPoints,
    required this.earnedPoints,
    required this.usedPoints,
    required this.rewardCount,
  });

  factory ShopPoints.fromJson(Map<String, dynamic> json) {
    return ShopPoints(
      currentPoints: json['currentPoints'],
      earnedPoints: json['earnedPoints'],
      usedPoints: json['usedPoints'],
      rewardCount: json['rewardCount'],
    );
  }
}
