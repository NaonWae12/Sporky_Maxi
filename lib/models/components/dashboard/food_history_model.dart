import 'package:sporky_maxi/models/api/api_parser.dart';

class DailyNutritionSummary {
  final DateTime date;
  final double calories;
  final double carbohydrate;
  final double protein;
  final double fat;
  final int entryCount;

  const DailyNutritionSummary({
    required this.date,
    required this.calories,
    required this.carbohydrate,
    required this.protein,
    required this.fat,
    required this.entryCount,
  });

  factory DailyNutritionSummary.fromJson(JsonMap json) {
    return DailyNutritionSummary(
      date: ApiParser.dateTime(json['date']) ?? DateTime.now(),
      calories: ApiParser.decimal(json['calories']),
      carbohydrate: ApiParser.decimal(json['carbohydrate']),
      protein: ApiParser.decimal(json['protein']),
      fat: ApiParser.decimal(json['fat']),
      entryCount: ApiParser.integer(json['entry_count']),
    );
  }
}
