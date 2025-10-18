import 'package:es_english/pages/vocabulary/saved_word/saved_word_controller.dart';
import 'package:get/get.dart';

class SavedWordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SavedWordController>(() => SavedWordController());
  }
}