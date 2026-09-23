import 'dart:io';

import '../models/food_item.dart';

class FoodRecognitionResult {
  const FoodRecognitionResult({required this.items, this.source = 'demo'});

  final List<FoodItem> items;
  final String source;
}

class FoodRecognitionService {
  static const demoFoods = [
    FoodItem(name: 'Rice', calories: 210, carbs: 45, protein: 4),
    FoodItem(name: 'Dal', calories: 180, carbs: 28, protein: 10),
    FoodItem(name: 'Vegetables', calories: 90, carbs: 14, protein: 4),
  ];

  Future<FoodRecognitionResult> recognize(File image) async {
    if (!await image.exists() || (await image.stat()).size == 0) {
      throw const FormatException('The selected image is empty or unavailable.');
    }
    return const FoodRecognitionResult(items: demoFoods);
  }
}
