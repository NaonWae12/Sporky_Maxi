class MealPlan {
  final int id;
  final String uuid;
  final String imageUrl;
  final double calories;

  MealPlan({
    required this.id,
    required this.uuid,
    required this.imageUrl,
    required this.calories,
  });

  factory MealPlan.fromJson(Map<String, dynamic> json) {
    return MealPlan(
      id: json['id'],
      uuid: json['uuid'],
      imageUrl: json['image_url'] ?? '',
      calories: (json['nutrition']?['calories'] ?? 0).toDouble(),
    );
  }
}
