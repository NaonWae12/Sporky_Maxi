class ZScoreChartPoint {
  final double x; // minggu ke-berapa / timestamp
  final double y; // z_score
  final DateTime date;

  ZScoreChartPoint({required this.x, required this.y, required this.date});

  /// Parsing dari API
  factory ZScoreChartPoint.fromJson(Map<String, dynamic> json) {
    final zScore = json['z_score'] != null
        ? (json['z_score'] as num).toDouble()
        : 0.0;
    final date = DateTime.parse(json['date'] as String);

    return ZScoreChartPoint(
      x: date.millisecondsSinceEpoch.toDouble(),
      y: zScore,
      date: date,
    );
  }
}
