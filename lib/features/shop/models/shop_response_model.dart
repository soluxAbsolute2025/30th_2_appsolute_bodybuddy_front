import 'premium_badge_model.dart';
import 'booster_model.dart';

class ShopResponse {
  final int status;
  final int currentPoints;
  final int earnedPoints;
  final int usedPoints;
  final int rewardCount;
  final List<PremiumBadge> premiumBadges;
  final List<Booster> boosters;

  const ShopResponse({
    required this.status,
    required this.currentPoints,
    required this.earnedPoints,
    required this.usedPoints,
    required this.rewardCount,
    required this.premiumBadges,
    required this.boosters,
  });

  factory ShopResponse.fromJson(Map<String, dynamic> json) {
    final badges = (json['premiumBadges'] as List<dynamic>)
        .map((e) => PremiumBadge.fromJson(e as Map<String, dynamic>))
        .toList();

    final boosters = (json['boosters'] as List<dynamic>)
        .map((e) => Booster.fromJson(e as Map<String, dynamic>))
        .toList();

    return ShopResponse(
      status: json['status'] as int,
      currentPoints: json['currentPoints'] as int,
      earnedPoints: json['earnedPoints'] as int,
      usedPoints: json['usedPoints'] as int,
      rewardCount: json['rewardCount'] as int,
      premiumBadges: badges,
      boosters: boosters,
    );
  }
}
