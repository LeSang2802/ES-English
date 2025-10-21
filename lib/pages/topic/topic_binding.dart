import 'package:es_english/pages/topic/topic_controller.dart';
import 'package:get/get.dart';

class TopicBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TopicController>(() => TopicController());
  }
}