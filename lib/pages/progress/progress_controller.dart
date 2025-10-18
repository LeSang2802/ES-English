import 'package:get/get.dart';
import '../../cores/utils/dummy_util.dart';
import '../../models/progress/progress_model.dart';

class ProgressController extends GetxController {
  final RxString selectedLevel = 'intermediate'.obs;

  List<SkillProgress> get filtered =>
      DummyUtil.progressList.where((e) => e.level == selectedLevel.value).toList();

  void pickLevel(String level) => selectedLevel.value = level;

  void onTapContinue(SkillProgress item) {
    Get.snackbar(
      'Tiếp tục',
      'Chức năng đang phát triển cho ${item.skill} (${item.level})',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
