import 'package:flutter/material.dart';
import '../models/booster_model.dart';
import 'booster_tile.dart';

class BoosterList extends StatelessWidget {
  final List<Booster> items;
  const BoosterList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items
          .map((b) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: BoosterTile(
                  title: b.name,
                  desc: b.description,
                  price: b.price,
                ),
              ))
          .toList(),
    );
  }
}
