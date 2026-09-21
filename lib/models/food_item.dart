class FoodItem {
  const FoodItem({
    required this.name,
    required this.calories,
    this.protein = 0,
    this.carbs = 0,
    this.fat = 0,
  });

  final String name;
  final int calories;
  final int protein;
  final int carbs;
  final int fat;
}
