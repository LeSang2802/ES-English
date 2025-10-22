import 'package:dio/dio.dart';
import 'package:es_english/cores/constants/api_paths.dart';
import 'package:es_english/cores/constants/base_api_client.dart';
import 'package:es_english/models/topic/topic_response_model.dart';

class VocabularyRepository {
  final BaseApiClient _client = BaseApiClient();

  Future<List<TopicResponseModel>> getFlashcardTopics() async {
    try {
      final response = await _client.get(
        "${ApiPaths.topic}?type=FLASHCARD",
      );
      final List data = response.data['items'];
      return data.map((e) => TopicResponseModel.fromJson(e)).toList();
    } catch (e) {
      print("Error fetching flashcard topics: $e");
      rethrow;
    }
  }
}
