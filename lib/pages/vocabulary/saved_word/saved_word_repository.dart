import 'package:dio/dio.dart';
import 'package:es_english/cores/constants/api_paths.dart';
import 'package:es_english/cores/constants/base_api_client.dart';
import 'package:es_english/models/vocabulary/saved_word/saved_word_model.dart';

class SavedWordRepository {
  final BaseApiClient _client = BaseApiClient();

  /// 🔹 Lấy danh sách từ đã lưu
  Future<List<SavedWordModel>> getSavedWords() async {
    try {
      final res = await _client.get(ApiPaths.saveWord);
      final List data = res.data;
      return data.map((e) => SavedWordModel.fromJson(e)).toList();
    } catch (e) {
      print("❌ Lỗi getSavedWords: $e");
      rethrow;
    }
  }

  /// 🔹 Toggle lưu / bỏ lưu
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
