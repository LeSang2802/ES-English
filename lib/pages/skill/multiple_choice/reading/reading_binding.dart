import 'package:es_english/pages/skill/multiple_choice/reading/reading_controller.dart';
import 'package:get/get.dart';

class ReadingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReadingController>(() => ReadingController());
  }
}