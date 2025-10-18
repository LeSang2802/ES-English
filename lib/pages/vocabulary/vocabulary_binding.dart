import 'package:es_english/pages/vocabulary/vocabulary_controller.dart';
import 'package:get/get.dart';

class VocabularyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VocabularyController>(() => VocabularyController());
  }
}