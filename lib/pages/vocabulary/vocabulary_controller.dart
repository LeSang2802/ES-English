import 'package:get/get.dart';
import 'package:es_english/models/topic/topic_response_model.dart';
import 'package:es_english/pages/vocabulary/vocabulary_repository.dart';

class VocabularyController extends GetxController {
  final VocabularyRepository repo = VocabularyRepository();

  var topics = <TopicResponseModel>[].obs;
  var filteredTopics = <TopicResponseModel>[].obs;
  var isLoading = false.obs;
  var searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadTopics();
  }

  Future<void> loadTopics() async {
    isLoading.value = true;
    try {
      topics.value = await repo.getFlashcardTopics();
      filteredTopics.value = topics;
    } catch (e) {
      print("Error load flashcard topics: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;

    if (query.isEmpty) {
      filteredTopics.value = topics;
    } else {
      filteredTopics.value = topics.where((topic) {
        final title = topic.title?.toLowerCase() ?? '';
        final searchLower = query.toLowerCase();
        return title.contains(searchLower);
      }).toList();
    }
  }

  void clearSearch() {
    searchQuery.value = '';
    filteredTopics.value = topics;
  }

  void goToSavedWords() {
    Get.toNamed('/savedWord');
  }

  void onSelectTopic(TopicResponseModel topic) {
    Get.toNamed('/flashCard', arguments: {
      'topic_id': topic.id,
      'topic_title': topic.title,
    });
  }
}