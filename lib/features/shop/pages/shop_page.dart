import 'package:flutter/material.dart';
import '../data/dummy_shop_data.dart';
import '../models/shop_response_model.dart';
import '../widgets/points_card.dart';
import '../widgets/premium_badge_grid.dart';
import '../widgets/booster_list.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    final shop = ShopResponse.fromJson(dummyShopResponse);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,

        leadingWidth: 48,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Image.asset(
            'assets/challenge/back_vector.png',
            width: 24,
            height: 24,
          ),
        ),

        title: const Text(
          '상점',
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),

        actions: const [SizedBox(width: 48)],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 25),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: PointsCard(points: shop.currentPoints),
            ),

            const SizedBox(height: 25),
            Container(width: double.infinity, height: 10, color: Color(0xFFF8F8F8)),
            const SizedBox(height: 32),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '프리미엄 뱃지',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: PremiumBadgeGrid(items: shop.premiumBadges),
            ),

            const SizedBox(height: 40),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '챌린지 부스터',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: BoosterList(items: shop.boosters),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
