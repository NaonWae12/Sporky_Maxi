class ChildActivity {
  final int id;
  final String name;
  final bool isActive;

  ChildActivity({
    required this.id,
    required this.name,
    required this.isActive,
  });

  factory ChildActivity.fromJson(Map<String, dynamic> json) {
    final rawIsActive = json['is_active'];

    return ChildActivity(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name']?.toString() ?? '',
      isActive: rawIsActive == true || rawIsActive == 1 || rawIsActive == "1",
    );
  }
}
