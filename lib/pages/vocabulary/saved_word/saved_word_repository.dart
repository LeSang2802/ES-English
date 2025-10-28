import 'package:dio/dio.dart';
import 'package:es_english/cores/constants/api_paths.dart';
import 'package:es_english/cores/constants/base_api_client.dart';
import 'package:es_english/models/vocabulary/saved_word/saved_word_model.dart';

class SavedWordRepository {
  final BaseApiClient _client = BaseApiClient();

  //Lấy danh sách từ đã lưu của người dùng
  Future<List<SavedWordModel>> getSavedWords() async {
    try {
      final res = await _client.get(ApiPaths.saveWord);
      final data = res.data;

      if (data is Map<String, dynamic> && data['items'] is List) {
        final items = data['items'] as List<dynamic>;
        return items
            .map((e) => SavedWordModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else if (data is List) {
        return data
            .map((e) => SavedWordModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        print("⚠️ Định dạng API saved-words không đúng: $data");
        return [];
      }
    } catch (e) {
      print("❌ Lỗi getSavedWords: $e");
      rethrow;
    }
  }

  //Toggle lưu / bỏ lưu từ vựng
  Future<bool> toggleSave(String flashcardId) async {
    try {
      final res = await _client.post(
        ApiPaths.savedWordToggle,
        data: {"flashcard_id": flashcardId},
      );
      return res.data['saved'] ?? false;
    } catch (e) {
      print("❌ Lỗi toggleSave: $e");
      rethrow;
    }
  }
}
