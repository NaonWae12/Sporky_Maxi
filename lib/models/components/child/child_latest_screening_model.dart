class ChildLatestScreening {
  final Child child;
  final Screening screening;

  ChildLatestScreening({
    required this.child,
    required this.screening,
  });

  factory ChildLatestScreening.fromJson(Map<String, dynamic> json) {
    return ChildLatestScreening(
      child: Child.fromJson(json['child']),
      screening: Screening.fromJson(json['screening']),
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
    return Child(
      uuid: json['uuid'],
      name: json['name'],
      dob: DateTime.parse(json['dob']),
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
      id: json['id'] as int?,
      activityId: json['activity_id'] as int?,
      height: json['height'] as int?,
      weight: (json['weight'] as num?)?.toDouble(),
      bmi: (json['bmi'] as num?)?.toDouble(),
      zScore: (json['z_score'] as num?)?.toDouble(),
      nutritionStatus: json['nutrition_status'] as String?,
      paValue: (json['pa_value'] as num?)?.toDouble(),
      eer: (json['eer'] as num?)?.toDouble(),
    );
  }
}
