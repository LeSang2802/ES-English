import 'package:es_english/pages/skill/skill_controller.dart';
import 'package:get/get.dart';

class SkillBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SkillController>(() => SkillController());
  }
}