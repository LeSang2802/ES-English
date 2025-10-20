import 'package:es_english/models/skill/skill_response_model.dart';
import '../../cores/constants/base_api_client.dart';
import '../../cores/constants/api_paths.dart';

class SkillRepository {
  final BaseApiClient _apiClient = BaseApiClient();

  Future<List<SkillResponseModel>> getSkills() async {
    final response = await _apiClient.get(ApiPaths.skill);

    final List data = response.data;
    return data.map((json) => SkillResponseModel.fromJson(json)).toList();
  }
}
