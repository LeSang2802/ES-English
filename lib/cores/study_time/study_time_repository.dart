import '../constants/api_paths.dart';
import '../constants/base_api_client.dart';
import '../../models/study_time/study_time_request_model.dart';

class StudyTimeRepository {
  final BaseApiClient _apiClient = BaseApiClient();

  /// POST study time lên server
  /// Format: { "date": "2025-11-26", "duration": 300 }
  Future<void> postStudyTime(StudyTimeRequest request) async {
    try {
      await _apiClient.post(
        ApiPaths.studyTime,
        data: request.toJson(),
      );

      print('✅ Study time posted: ${request.date} - ${request.duration}s');
    } catch (e) {
      print('❌ StudyTimeRepository error: $e');
      rethrow;
    }
  }
}