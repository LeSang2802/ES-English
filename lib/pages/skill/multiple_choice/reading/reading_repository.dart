import 'package:es_english/cores/constants/api_paths.dart';
import 'package:es_english/cores/constants/base_api_client.dart';

import '../../../../models/skill/multiple_choice/mcq_response_model.dart';

class ReadingRepository {
  final BaseApiClient _client = BaseApiClient();

  Future<List<String>> getAllContentIdsByTopic(
      String topicId, {
        String type = 'READING_PASSAGE',
      }) async {
    final resp = await _client.get(
      "${ApiPaths.content}?topic_id=$topicId&type=$type",
    );
    final items = (resp.data['items'] as List?) ?? const [];
    return items.map((e) => e['_id'] as String).toList();
  }

  Future<McqResponseModel> getReadingDetail(String contentId) async {
    final resp = await _client.get("${ApiPaths.content}/$contentId/detail");
    return McqResponseModel.fromJson(resp.data);
  }
}
