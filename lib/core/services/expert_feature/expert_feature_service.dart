import 'package:sporky_maxi/components/globals/constants/api_endpoints.dart';
import 'package:sporky_maxi/core/services/api/api_client.dart';
import 'package:sporky_maxi/models/api/api_parser.dart';
import 'package:sporky_maxi/models/components/expert_feature/child_medical_model.dart';
import 'package:sporky_maxi/models/components/expert_feature/expert_insight_model.dart';

class ExpertFeatureService {
  const ExpertFeatureService({ApiClient apiClient = const ApiClient()})
    : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<ExpertConsultationInsight> getConsultationInsight({
    String period = 'all',
  }) async {
    final response = await _apiClient.get(
      ApiEndpoints.expertMyInsights(period: period),
    );
    return ExpertConsultationInsight.fromJson(ApiParser.map(response['data']));
  }

  Future<ChildMedicalRecord> getChildMedicalRecord(String roomUuid) async {
    final response = await _apiClient.get(
      ApiEndpoints.chatRoomChildMedicalHistory(roomUuid),
    );
    return ChildMedicalRecord.fromJson(ApiParser.map(response['data']));
  }

  Future<List<ChildScreeningHistoryItem>> getChildScreeningHistory(
    String roomUuid,
  ) async {
    final response = await _apiClient.get(
      ApiEndpoints.chatRoomChildScreeningHistory(roomUuid),
    );
    final data = ApiParser.map(response['data']);
    return ApiParser.mapList(
      data['medical_records'],
    ).map(ChildScreeningHistoryItem.fromJson).toList();
  }

  Future<ChildMedicalRecord> saveConsultationNotes({
    required String roomUuid,
    required String diagnosisResult,
    required String recommendation,
  }) async {
    final response = await _apiClient.patch(
      ApiEndpoints.chatRoomConsultationNotes(roomUuid),
      body: {
        'diagnosis_result': diagnosisResult,
        'recommendation': recommendation,
      },
    );

    final data = ApiParser.map(response['data']);
    return ChildMedicalRecord(
      parentName: '-',
      childName: '-',
      dateOfBirth: '-',
      ageYears: '-',
      weightKg: '-',
      heightCm: '-',
      complaint: ApiParser.string(data['complaint'], '-'),
      diagnosisResult: ApiParser.string(data['diagnosis_result']),
      recommendation: ApiParser.string(data['recommendation']),
    );
  }
}
