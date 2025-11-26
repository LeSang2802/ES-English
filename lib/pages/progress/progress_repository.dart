import '../../cores/constants/base_api_client.dart';
import '../../cores/constants/api_paths.dart';
import '../../models/progress/progress_response_model.dart';

class ProgressRepository {
  final BaseApiClient _apiClient = BaseApiClient();

  Future<ProgressResponseModel> getMyProgress() async {
    try {
      final response = await _apiClient.get(ApiPaths.progress);
      return ProgressResponseModel.fromJson(response.data);
    } catch (e) {
      print('❌ ProgressRepository error: $e');
      rethrow;
    }
  }
}