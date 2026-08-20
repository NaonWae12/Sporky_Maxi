class MealPlan {
  final int id;
  final String uuid;
  final String name;
  final String subtitle;
  final List<String> type;
  final String imageUrl;
  final double carbohydrate;
  final double protein;
  final double fat;
  final double calories;

  MealPlan({
    required this.id,
    required this.uuid,
    required this.name,
    required this.subtitle,
    required this.type,
    required this.imageUrl,
    required this.carbohydrate,
    required this.protein,
    required this.fat,
    required this.calories,
  });

  String get displayType {
    if (type.isEmpty) return 'Menu';
    final rawType = type.first;
    return rawType
        .split('_')
        .map((word) => word.isNotEmpty
            ? '${word[0].toUpperCase()}${word.substring(1)}'
            : '')
        .join(' ');
  }

  factory MealPlan.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> nutrition = {};
    if (json['nutrition'] is Map<String, dynamic>) {
      nutrition = json['nutrition'] as Map<String, dynamic>;
    } else if (json['nutritions'] is List && (json['nutritions'] as List).isNotEmpty) {
      final firstNutrition = (json['nutritions'] as List).first;
      if (firstNutrition is Map<String, dynamic>) {
        nutrition = firstNutrition;
      }
    }

    final rawImageUrl = (json['image_url'] ?? '').toString();
    final rawImagePath = (json['image_path'] ?? '').toString();
    final imageUrl = rawImageUrl.isNotEmpty ? rawImageUrl : rawImagePath;

    final typeList = json['type'];
    final parsedType = typeList is List
        ? typeList.map((e) => e.toString()).toList()
        : <String>[];

    return MealPlan(
      id: _toInt(json['id']),
      uuid: (json['uuid'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      subtitle: (json['subtitle'] ?? '').toString(),
      type: parsedType,
      imageUrl: imageUrl,
      carbohydrate: _toDouble(nutrition['carbohydrate']),
      protein: _toDouble(nutrition['protein']),
      fat: _toDouble(nutrition['fat']),
      calories: _toDouble(nutrition['calories']),
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static double _toDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0.0;
  }
}
