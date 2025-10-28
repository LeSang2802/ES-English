import 'package:dio/dio.dart';
import 'package:es_english/cores/constants/api_paths.dart';
import 'package:es_english/cores/constants/base_api_client.dart';
import 'package:es_english/models/vocabulary/flash_card/flash_card_model.dart';

class FlashCardRepository {
  final BaseApiClient _client = BaseApiClient();

  //Lấy danh sách flashcard theo topic
  Future<List<FlashCardModel>> getFlashcards(String topicId) async {
    try {
      final response = await _client.get(
        "${ApiPaths.flashcard}?topic_id=$topicId",
      );

      final data = response.data;

      if (data is Map<String, dynamic> && data['items'] is List) {
        final items = data['items'] as List<dynamic>;
        return items
            .map((e) => FlashCardModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else if (data is List) {
        // Trường hợp backend trả thẳng mảng
        return data
            .map((e) => FlashCardModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        print("⚠️ Định dạng API flashcards không đúng: $data");
        return [];
      }
    } catch (e) {
      print("❌ Lỗi getFlashcards: $e");
      rethrow;
    }
  }

  //Lưu hoặc bỏ lưu từ vựng
  Future<bool> toggleSave(String flashcardId) async {
    try {
      final res = await _client.post(
        ApiPaths.savedWordToggle,
        data: {"flashcard_id": flashcardId},
      );
      return res.data["saved"] ?? false; // Trả về true nếu đã lưu, false nếu bỏ lưu
    } catch (e) {
      print("❌ Lỗi toggleSave: $e");
      rethrow;
    }
  }
}
