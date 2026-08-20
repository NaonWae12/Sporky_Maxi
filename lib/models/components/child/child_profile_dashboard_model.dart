class ChildProfileDashboard {
  final String uuid;
  final String name;
  final String gender;
  final String dob;
  final double ageYears;

  final List<String> conditions;
  final List<String> allergies;
  final List<String> avoidedFoods;
  final List<String> favoriteFoods;

  ChildProfileDashboard({
    required this.uuid,
    required this.name,
    required this.gender,
    required this.dob,
    required this.ageYears,
    required this.conditions,
    required this.allergies,
    required this.avoidedFoods,
    required this.favoriteFoods,
  });

  factory ChildProfileDashboard.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};

    final medicalSummary =
        data['medical_summary'] as Map<String, dynamic>? ?? {};
    final allergySummary =
        data['allergy_summary'] as Map<String, dynamic>? ?? {};
    final foodWarning = data['food_warning'] as Map<String, dynamic>? ?? {};
    final favoriteFoodsMap =
        data['favorite_foods'] as Map<String, dynamic>? ?? {};

    return ChildProfileDashboard(
      uuid: data['uuid']?.toString() ?? '',
      name: data['name']?.toString() ?? '',
      gender: data['gender']?.toString() ?? '',
      dob: data['dob']?.toString() ?? '',
      ageYears: _toDouble(data['age_years']),
      conditions: _toList(medicalSummary['conditions']),
      allergies: _toList(allergySummary['allergies']),
      avoidedFoods: _toList(foodWarning['avoided_foods']),
      favoriteFoods: _toList(favoriteFoodsMap['foods']),
    );
  }

  static List<String> _toList(dynamic value) {
    if (value is List) return value.map((e) => e.toString()).toList();
    return [];
  }

  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}
