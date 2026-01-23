import 'package:flutter/material.dart';
import 'price_pill.dart';

class PremiumBadgeCard extends StatelessWidget {
  final String title;
  final int price;
  final bool isPurchased;
  final String? imageUrl;

  const PremiumBadgeCard({
    super.key,
    required this.title,
    required this.price,
    required this.isPurchased,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD8D8D8), width: 1),
      ),
      child: Column(
        children: [
          SizedBox(
            width: 79,
            height: 79,
            child: (imageUrl != null && imageUrl!.isNotEmpty)
                ? ClipOval(
                    child: Image.network(
                      imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _placeholder(),
                    ),
                  )
                : _placeholder(),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 15),
          PricePill(
            text: isPurchased ? '구매 완료' : '${price}P',
            enabled: !isPurchased,
          ),
        ],
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFFF3F3F3),
      ),
    );
  }
}