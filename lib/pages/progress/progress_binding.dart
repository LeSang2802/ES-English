import 'package:es_english/pages/progress/progress_controller.dart';
import 'package:get/get.dart';

class ProgressBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProgressController>(() => ProgressController());
  }
}
