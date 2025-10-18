import 'package:get/get.dart';
import '../../cores/utils/dummy_util.dart';
import '../../models/level/level_model.dart';

class LevelController extends GetxController {
  final levels = <Level>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadLevels();
  }

  /// 🔹 Load danh sách cấp độ (từ DummyUtil)
  void loadLevels() {
    isLoading.value = true;
    Future.delayed(const Duration(milliseconds: 300), () {
      levels.value = DummyUtil.Levels; // ⚠️ Tạm dùng dữ liệu reading, sau này đổi API
      isLoading.value = false;
    });
  }

  /// 🔹 Refresh danh sách cấp độ
  Future<void> refreshData() async {
    await Future.delayed(const Duration(milliseconds: 500));
    loadLevels();
  }

  /// 🔹 Khi chọn cấp độ → điều hướng sang danh sách bài học theo cấp độ
  void onSelectLevel(Level level) {
    Get.snackbar(
      "Chọn cấp độ",
      "Bạn đã chọn: ${level.title}",
      snackPosition: SnackPosition.BOTTOM,
    );

    // TODO: chuyển sang TopicPage hoặc LessonPage
    // Get.toNamed('/topic', arguments: level);
  }
}
