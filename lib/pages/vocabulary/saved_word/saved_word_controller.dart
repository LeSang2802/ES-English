import 'package:get/get.dart';
import '../../../models/vocabulary/saved_word/saved_word_model.dart';
import 'saved_word_repository.dart';

class SavedWordController extends GetxController {
  final repo = SavedWordRepository();
  final words = <SavedWordModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadSavedWords();
  }

  /// 🔹 Load danh sách từ đã lưu từ API
  // Future<void> loadSavedWords() async {
  //   isLoading.value = true;
  //   try {
  //     final data = await repo.getSavedWords();
  //     words.value = data.map((w) => w.copyWith(isSaved: true)).toList();
  //   } catch (e) {
  //     print("❌ Lỗi loadSavedWords: $e");
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  Future<void> loadSavedWords() async {
    isLoading.value = true;
    try {
      final data = await repo.getSavedWords();
      print("📘 API trả về ${data.length} từ");
      for (final w in data) {
        print("🔹 ${w.word} (${w.part_of_speech}) - ${w.meaning_vi}");
      }
      words.value = data.map((w) => w.copyWith(isSaved: true)).toList();
    } catch (e) {
      print("❌ Lỗi loadSavedWords: $e");
    } finally {
      isLoading.value = false;
    }
  }


  /// 🔹 Toggle lưu / bỏ lưu
  Future<void> toggleSave(SavedWordModel word) async {
    final index = words.indexWhere((w) => w.id == word.id);
    if (index == -1) return;

    try {
      final saved = await repo.toggleSave(word.id ?? '');
      // Nếu user bỏ lưu → xóa khỏi list luôn
      if (!saved) {
        words.removeAt(index);
      } else {
        words[index] = word.copyWith(isSaved: true);
      }
      words.refresh();
    } catch (e) {
      print("❌ Lỗi toggleSave: $e");
    }
  }
}
