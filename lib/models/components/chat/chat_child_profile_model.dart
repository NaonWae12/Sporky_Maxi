class ChatChildProfile {
  final String name;
  final String age;
  final List<String> medicalHistories;
  final List<String> allergies;
  final List<String> favorites;
  final List<String> avoided;

  ChatChildProfile({
    required this.name,
    required this.age,
    required this.medicalHistories,
    required this.allergies,
    required this.favorites,
    required this.avoided,
  });

  factory ChatChildProfile.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    final identity = data['identity'] as Map<String, dynamic>? ?? {};
    final health = data['health'] as Map<String, dynamic>? ?? {};
    final diet = data['diet'] as Map<String, dynamic>? ?? {};

    return ChatChildProfile(
      name: identity['name']?.toString() ?? '',
      age: identity['age']?.toString() ?? '',
      medicalHistories: _toList(health['medical_histories']),
      allergies: _toList(health['allergies']),
      favorites: _toList(diet['favorites']),
      avoided: _toList(diet['avoided']),
    );
  }

  static List<String> _toList(dynamic value) {
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    return [];
  }
}
