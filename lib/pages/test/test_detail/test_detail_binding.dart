import 'package:es_english/pages/test/test_detail/test_detail_controller.dart';
import 'package:get/get.dart';

class TestDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TestDetailController>(() => TestDetailController());
  }
}