import 'package:get/get.dart';
import '../../../models/skill/skill_model.dart';
import '../../../cores/utils/dummy_util.dart';

class SkillController extends GetxController {
  final skills = <Skill>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadSkills();
  }

  Future<void> loadSkills() async {
    if (isLoading.value) return;
    isLoading.value = true;

    await Future.delayed(const Duration(milliseconds: 500));
    skills.assignAll(DummyUtil.skills);

    isLoading.value = false;
  }

  // void onSelectSkill(Skill skill) {
  //   Get.snackbar(
  //     "Skill Selected",
  //     "ID: ${skill.id} — ${skill.name}",
  //     snackPosition: SnackPosition.BOTTOM,
  //     duration: const Duration(seconds: 2),
  //   );
  // }
  void onSelectSkill(Skill skill) {
    // Chuyển sang trang tiếp theo (ví dụ: chọn cấp độ của skill)
    Get.toNamed(
      '/level',     // Route của màn kế tiếp
      arguments: skill,    // Truyền toàn Skill (bao gồm id, name, ...)
    );
  }
}
