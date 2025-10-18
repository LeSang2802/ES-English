import 'package:get/get.dart';
import 'level_controller.dart';

class LevelBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LevelController>(() => LevelController());
  }
}
