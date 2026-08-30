import 'package:sporky_maxi/models/api/api_parser.dart';

class ChildMedicalRecord {
  final String parentName;
  final String childName;
  final String dateOfBirth;
  final String ageYears;
  final String weightKg;
  final String heightCm;
  final String complaint;
  final String diagnosisResult;
  final String recommendation;

  const ChildMedicalRecord({
    required this.parentName,
    required this.childName,
    required this.dateOfBirth,
    required this.ageYears,
    required this.weightKg,
    required this.heightCm,
    required this.complaint,
    required this.diagnosisResult,
    required this.recommendation,
  });

  factory ChildMedicalRecord.fromJson(JsonMap json) {
    return ChildMedicalRecord(
      parentName: ApiParser.string(json['parent_name'], '-'),
      childName: ApiParser.string(json['child_name'], '-'),
      dateOfBirth: ApiParser.string(json['date_of_birth'], '-'),
      ageYears: ApiParser.string(json['age_years'], '-'),
      weightKg: ApiParser.string(json['weight_kg'], '-'),
      heightCm: ApiParser.string(json['height_cm'], '-'),
      complaint: ApiParser.string(json['complaint'], '-'),
      diagnosisResult: ApiParser.string(json['diagnosis_result']),
      recommendation: ApiParser.string(json['recommendation']),
    );
  }
}

class ChildScreeningHistoryItem {
  final String date;
  final String weight;
  final String height;
  final double bmi;
  final double zScore;
  final String nutritionStatus;
  final double paValue;
  final String eer;

  const ChildScreeningHistoryItem({
    required this.date,
    required this.weight,
    required this.height,
    required this.bmi,
    required this.zScore,
    required this.nutritionStatus,
    required this.paValue,
    required this.eer,
  });

  factory ChildScreeningHistoryItem.fromJson(JsonMap json) {
    final anthropometry = ApiParser.map(json['anthropometry']);
    final clinicalAnalysis = ApiParser.map(json['clinical_analysis']);

    return ChildScreeningHistoryItem(
      date: ApiParser.string(json['date'], '-'),
      weight: ApiParser.string(anthropometry['weight'], '-'),
      height: ApiParser.string(anthropometry['height'], '-'),
      bmi: ApiParser.decimal(anthropometry['bmi']),
      zScore: ApiParser.decimal(clinicalAnalysis['z_score']),
      nutritionStatus: ApiParser.string(
        clinicalAnalysis['nutrition_status'],
        '-',
      ),
      paValue: ApiParser.decimal(clinicalAnalysis['pa_value']),
      eer: ApiParser.string(clinicalAnalysis['eer'], '-'),
    );
  }
}
