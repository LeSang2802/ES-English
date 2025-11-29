import 'package:es_english/pages/skill/speaking/speaking_controller.dart';
import 'package:get/get.dart';

class SpeakingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SpeakingController>(() => SpeakingController());
  }
}