import 'package:flutter/material.dart';
import '../data/dummy_shop_points.dart';
import '../models/shop_points_model.dart';
import '../widgets/points_card.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    final shopPoints = ShopPoints.fromJson(dummyShopPointsResponse);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,

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

      actions: const [
        SizedBox(width: 48),
      ],

      centerTitle: true, 
    ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 25),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: PointsCard(points: shopPoints.currentPoints),
            ),

            const SizedBox(height: 25),

            Container(
              width: double.infinity,
              height: 10,
              color: const Color(0xFFF8F8F8),
            ),
          ],
        ),
      ),
    );
  }
}
