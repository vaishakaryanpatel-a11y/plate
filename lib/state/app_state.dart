import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/meal_entry.dart';
import '../models/user_profile.dart';
import '../services/storage_service.dart';
import '../services/step_service.dart';

class AppState extends ChangeNotifier {
  AppState(this.storage) : _steps = StepService();

  final StorageService storage;
  final StepService _steps;
  final UserProfile profile = const UserProfile();
  final List<MealEntry> meals = [];
  StreamSubscription<int>? _stepsSubscription;
  int _todaySteps = 0;

  int get waterCount => storage.waterCount;
  int get calories => meals.fold(0, (total, meal) => total + meal.calories);
  int get steps => _todaySteps;

  Future<void> bootstrap() async {
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final baseline = storage.stepsBaselineDate == today ? storage.stepsBaseline : 0;
    _stepsSubscription = _steps.stepsStream.listen((value) {
      _todaySteps = value;
      notifyListeners();
    });
    await _steps.start(
      todayBaseline: baseline,
      onBaselineEstablished: (value) {
        return storage.saveStepsBaseline(baseline: value, date: today);
      },
    );
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

  @override
  void dispose() {
    _stepsSubscription?.cancel();
    _steps.dispose();
    super.dispose();
  }
}
