import 'package:dio/dio.dart'; // THÊM
import 'package:es_english/cores/constants/api_paths.dart';
import 'package:es_english/cores/constants/base_api_client.dart';
import '../../../models/skill/writing/content_item_writing_model.dart';
import '../../../models/skill/writing/writing_submit_request_model.dart';

class WritingRepository {
  final BaseApiClient _client = BaseApiClient();

  Future<List<String>> getAllContentIdsByTopic(String topicId, {String type = 'WRITING_PROMPT'}) async {
    final Response<dynamic> resp = await _client.get("${ApiPaths.content}?topic_id=$topicId&type=$type");
    final items = (resp.data['items'] as List?) ?? const [];
    return items.map((e) => e['_id'] as String).toList();
  }

  Future<ContentItemWriting> getWritingDetail(String contentId) async {
    final Response<dynamic> resp = await _client.get("${ApiPaths.content}/$contentId/detail");
    final itemData = resp.data['item'] as Map<String, dynamic>;
    final questions = resp.data['questions'] as List?;
    String? questionText;
    if (questions != null && questions.isNotEmpty) {
      questionText = questions[0]['question_text'] as String?;
    }
    itemData['question_text'] = questionText;
    return ContentItemWriting.fromJson(itemData);
  }

  Future<void> receiveResult(WritingSubmitRequest request) async {
    try {
      final Response<dynamic> response = await _client.post(
        ApiPaths.reciveResult,
        data: request.toJson(),
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        print("Result submitted successfully: ${response.data}");
      } else {
        throw Exception("Submit failed: ${response.statusCode}");
      }
    } on DioException catch (e) {
      String message = "Network error";
      if (e.response != null) {
        message = "Server error: ${e.response!.statusCode}";
      } else if (e.message != null) {
        message = e.message!;
      }
      print("Dio error: $message");
      throw Exception(message);
    } catch (e) {
      print("Error submitting result: $e");
      rethrow;
    }
  }
}