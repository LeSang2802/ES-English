import 'package:es_english/pages/skill/writing/writing_controller.dart';
import 'package:get/get.dart';

class WritingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WritingController>(() => WritingController());
  }
}