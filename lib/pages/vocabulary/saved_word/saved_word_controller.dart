import 'package:flutter/material.dart';
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
  // Future<void> toggleSave(SavedWordModel word) async {
  //   final index = words.indexWhere((w) => w.id == word.id);
  //   if (index == -1) return;
  //
  //   try {
  //     final saved = await repo.toggleSave(word.id ?? '');
  //     // Nếu user bỏ lưu → xóa khỏi list luôn
  //     if (!saved) {
  //       words.removeAt(index);
  //     } else {
  //       words[index] = word.copyWith(isSaved: true);
  //     }
  //     words.refresh();
  //   } catch (e) {
  //     print("❌ Lỗi toggleSave: $e");
  //   }
  // }

  /// Toggle lưu / bỏ lưu với xác nhận khi bỏ lưu
  Future<void> toggleSave(SavedWordModel word) async {
    final index = words.indexWhere((w) => w.id == word.id);
    if (index == -1) return;

    // Nếu đang là ĐÃ LƯU → hỏi xác nhận bỏ lưu
    if (word.isSaved) {
      final confirm = await Get.dialog<bool>(
        AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.orange),
              SizedBox(width: 8),
              Text("Xác nhận", style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: Text("Bạn có chắc muốn bỏ lưu từ \"${word.word}\"?"),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: Text("Hủy", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () => Get.back(result: true),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text("Bỏ lưu", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );

      // Nếu người dùng hủy → không làm gì
      if (confirm != true) return;

      // Tiến hành bỏ lưu
      try {
        final saved = await repo.toggleSave(word.id ?? '');
        if (!saved) {
          words.removeAt(index);
          words.refresh();
          Get.snackbar(
            "Đã bỏ lưu",
            "Từ \"${word.word}\" đã được xóa khỏi danh sách.",
            backgroundColor: Colors.red.shade100,
            colorText: Colors.red.shade900,
            icon: Icon(Icons.star_border, color: Colors.red),
          );
        }
      } catch (e) {
        print("Lỗi toggleSave: $e");
        Get.snackbar("Lỗi", "Không thể bỏ lưu. Vui lòng thử lại.");
      }
    }
    // Nếu đang là CHƯA LƯU → lưu ngay
    else {
      try {
        final saved = await repo.toggleSave(word.id ?? '');
        if (saved) {
          words[index] = word.copyWith(isSaved: true);
          words.refresh();
          Get.snackbar(
            "Đã lưu",
            "Từ \"${word.word}\" đã được thêm vào danh sách.",
            backgroundColor: Colors.green.shade100,
            colorText: Colors.green.shade900,
            icon: Icon(Icons.star, color: Colors.amber),
          );
        }
      } catch (e) {
        print("Lỗi toggleSave: $e");
        Get.snackbar("Lỗi", "Không thể lưu từ. Vui lòng thử lại.");
      }
    }
  }
}
