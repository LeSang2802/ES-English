import 'package:dio/dio.dart';
import 'package:es_english/cores/constants/api_paths.dart';
import 'package:es_english/cores/constants/base_api_client.dart';
import 'package:es_english/models/topic/topic_response_model.dart';

class TopicRepository {
  final BaseApiClient _client = BaseApiClient();

  Future<List<TopicResponseModel>> getTopics(String skillId, String levelId) async {
    try {
      final response = await _client.get(
        "${ApiPaths.topic}?skill_id=$skillId&level_id=$levelId",
      );

      final List data = response.data['items'];
      return data.map((json) => TopicResponseModel.fromJson(json)).toList();
    } catch (e) {
      print("Error fetching topics: $e");
      rethrow;
    }
  }
}
