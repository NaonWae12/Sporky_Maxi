class ChildGrowthUpdatesModel {
  final String uuid;
  final String name;

  ChildGrowthUpdatesModel({
    required this.uuid,
    required this.name,
  });

  factory ChildGrowthUpdatesModel.fromJson(Map<String, dynamic> json) {
    return ChildGrowthUpdatesModel(
      uuid: json['uuid'],
      name: json['name'],
    );
  }
}
