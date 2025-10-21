import 'package:get/get.dart';
import 'package:es_english/models/topic/topic_response_model.dart';
import 'package:es_english/pages/topic/topic_repository.dart';

class TopicController extends GetxController {
  final TopicRepository repo = TopicRepository();

  var topics = <TopicResponseModel>[].obs;
  var isLoading = false.obs;

  late String skillId;
  late String levelId;
  late String skillName;
  late String levelName;

  @override
  void onInit() {
    final args = Get.arguments;
    skillId = args['skill_id'];
    levelId = args['level_id'];
    skillName = args['skill_name'];
    levelName = args['level_name'];
    super.onInit();
    loadTopics();
  }

  Future<void> loadTopics() async {
    isLoading.value = true;
    try {
      topics.value = await repo.getTopics(skillId, levelId);
    } catch (e) {
      print("Error load topics: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshData() async {
    await loadTopics();
  }

  void onSelectTopic(TopicResponseModel topic) {
    Get.snackbar(
      "Topic selected",
      topic.title ?? '',
      snackPosition: SnackPosition.BOTTOM,
    );
    // TODO: chuyển sang trang học
  }
}
