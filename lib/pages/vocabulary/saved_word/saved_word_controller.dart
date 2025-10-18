import 'package:get/get.dart';
import '../../../cores/utils/dummy_util.dart';
import '../../../models/vocabulary/saved_word/saved_word_model.dart';

class SavedWordController extends GetxController {
  final words = <SavedWordModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadSavedWords();
  }

  /// 🔹 Load danh sách từ đã lưu từ DummyUtil
  void loadSavedWords() {
    isLoading.value = true;
    Future.delayed(const Duration(milliseconds: 400), () {
      words.value = DummyUtil.savedWords;
      isLoading.value = false;
    });
  }

  /// 🔹 Bật / tắt trạng thái lưu
  void toggleSave(SavedWordModel word) {
    final index = words.indexWhere((w) => w.id == word.id);
    if (index != -1) {
      words[index] = word.copyWith(isSaved: !word.isSaved);
      words.refresh();
    }
  }
}
