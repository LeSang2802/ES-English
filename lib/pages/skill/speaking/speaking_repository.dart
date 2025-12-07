import 'package:dio/dio.dart';
import 'package:es_english/cores/constants/api_paths.dart';
import 'package:es_english/cores/constants/base_api_client.dart';
import '../../../models/skill/speaking/content_item_speaking_model.dart';
import '../../../models/skill/writing/writing_submit_request_model.dart';

class SpeakingRepository {
  final BaseApiClient _client = BaseApiClient();

  Future<List<String>> getAllContentIdsByTopic(String topicId, {String type = 'SPEAKING_PROMPT'}) async {
    final Response<dynamic> resp = await _client.get("${ApiPaths.content}?topic_id=$topicId&type=$type");
    final items = (resp.data['items'] as List?) ?? const [];
    return items.map((e) => e['_id'] as String).toList();
  }

  Future<ContentItemSpeaking> getSpeakingDetail(String contentId) async {
    final Response<dynamic> resp = await _client.get("${ApiPaths.content}/$contentId/detail");

    // ✅ FIX: Lấy item và questions từ response
    final itemData = resp.data['item'] as Map<String, dynamic>;
    final questionsList = (resp.data['questions'] as List?) ?? [];

    // ✅ FIX: Gộp questions vào itemData trước khi parse
    itemData['questions'] = questionsList;

    print("📦 Speaking Detail - Item Data: $itemData");

    return ContentItemSpeaking.fromJson(itemData);
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
        print("Speaking result submitted successfully: ${response.data}");
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
      print("Error submitting speaking result: $e");
      rethrow;
    }
  }
}