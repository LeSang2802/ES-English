import '../constants/api_paths.dart';
import '../constants/base_api_client.dart';

class StudyTimeRepository {
  final BaseApiClient _apiClient = BaseApiClient();

  /// POST study time lên server
  /// Format: { "date": "2025-11-26", "duration": 1700 }
  Future<void> postStudyTime({
    required String date,
    required int duration,
  }) async {
    try {
      await _apiClient.post(
        ApiPaths.studyTime,
        data: {
          'date': date,
          'duration': duration,
        },
      );

      print('✅ Study time posted: $date - ${duration}s');
    } catch (e) {
      print('❌ StudyTimeRepository error: $e');
      rethrow;
    }
  }
}