import 'package:flutter/material.dart';

import '../models/food_item.dart';

class CalorieOverlay extends StatelessWidget {
  const CalorieOverlay({super.key, required this.items});

  final List<FoodItem> items;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black.withOpacity(.72),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Demo recognition', style: TextStyle(color: Colors.amber)),
            ...items.map(
              (item) => Text(
                '${item.name} · ${item.calories} kcal',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
