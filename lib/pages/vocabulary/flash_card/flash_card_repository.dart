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
      final List data = response.data['items'];
      return data.map((e) => FlashCardModel.fromJson(e)).toList();
    } catch (e) {
      print("Error fetching flashcards: $e");
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
      print(" Lỗi toggleSave: $e");
      rethrow;
    }
  }
}

