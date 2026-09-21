import 'package:flutter/foundation.dart';

import '../models/meal_entry.dart';
import '../models/user_profile.dart';
import '../services/storage_service.dart';

class AppState extends ChangeNotifier {
  AppState(this.storage);

  final StorageService storage;
  final UserProfile profile = const UserProfile();
  final List<MealEntry> meals = [];

  int get waterCount => storage.waterCount;
  int get calories => meals.fold(0, (total, meal) => total + meal.calories);
  int get steps => 0;

  Future<void> bootstrap() async {
    notifyListeners();
  }

  Future<void> addWater() async {
    await storage.saveWaterCount(waterCount + 1);
    notifyListeners();
  }

  void addMeal(MealEntry meal) {
    meals.add(meal);
    notifyListeners();
  }
}
