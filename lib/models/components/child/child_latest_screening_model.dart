class ChildLatestScreening {
  final Child child;
  final Screening? screening;

  ChildLatestScreening({
    required this.child,
    required this.screening,
  });

  factory ChildLatestScreening.fromJson(Map<String, dynamic> json) {
    final childJson = json['child'] as Map<String, dynamic>? ?? {};
    final screeningJson = json['screening'];

    return ChildLatestScreening(
      child: Child.fromJson(childJson),
      screening: screeningJson is Map<String, dynamic>
          ? Screening.fromJson(screeningJson)
          : null,
    );
  }
}

// ================= CHILD =================
class Child {
  final String uuid;
  final String name;
  final DateTime dob;

  Child({
    required this.uuid,
    required this.name,
    required this.dob,
  });

  factory Child.fromJson(Map<String, dynamic> json) {
    final dobRaw = json['dob']?.toString() ?? '';
    return Child(
      uuid: (json['uuid']?.toString() ?? '').trim(),
      name: (json['name']?.toString() ?? '').trim(),
      dob: DateTime.tryParse(dobRaw) ?? DateTime(1970, 1, 1),
    );
  }
}

// ================= SCREENING =================
class Screening {
  final int? id;
  final int? activityId;
  final int? height;
  final double? weight;
  final double? bmi;
  final double? zScore;
  final String? nutritionStatus;
  final double? paValue;
  final double? eer;

  Screening({
    this.id,
    this.activityId,
    this.height,
    this.weight,
    this.bmi,
    this.zScore,
    this.nutritionStatus,
    this.paValue,
    this.eer,
  });

  factory Screening.fromJson(Map<String, dynamic> json) {
    return Screening(
      id: _toInt(json['id']),
      activityId: _toInt(json['activity_id']),
      height: _toInt(json['height']),
      weight: _toDouble(json['weight']),
      bmi: _toDouble(json['bmi']),
      zScore: _toDouble(json['z_score']),
      nutritionStatus: json['nutrition_status'] as String?,
      paValue: _toDouble(json['pa_value']),
      eer: _toDouble(json['eer']),
    );
  }

  static int? _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  static double? _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}
