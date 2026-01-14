import 'package:flutter/material.dart';
import '../models/premium_badge_model.dart';
import 'premium_badge_card.dart';

class PremiumBadgeGrid extends StatelessWidget {
  final List<PremiumBadge> items;

  /// 구매 완료 상태는 API 붙으면 purchased 필드로 바꾸면 됨
  final Set<int> purchasedIds;

  const PremiumBadgeGrid({
    super.key,
    required this.items,
    this.purchasedIds = const {1},
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: items.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 0.95,
      ),
      itemBuilder: (_, index) {
        final item = items[index];
        return PremiumBadgeCard(
          title: item.name,
          price: item.price,
          isPurchased: purchasedIds.contains(item.id),
          imageUrl: item.iconUrl,
        );
      },
    );
  }
}
