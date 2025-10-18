import 'package:es_english/pages/vocabulary/flash_card/flash_card_controller.dart';
import 'package:get/get.dart';

class FlashCardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FlashCardController>(() => FlashCardController());
  }
}
