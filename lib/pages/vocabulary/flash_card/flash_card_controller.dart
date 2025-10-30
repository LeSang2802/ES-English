import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:es_english/models/vocabulary/flash_card/flash_card_model.dart';
import 'package:es_english/pages/vocabulary/flash_card/flash_card_repository.dart';
import 'package:es_english/pages/vocabulary/saved_word/saved_word_repository.dart';

class FlashCardController extends GetxController {
  final player = AudioPlayer();
  final flashRepo = FlashCardRepository();
  final savedRepo = SavedWordRepository();

  var vocabularies = <FlashCardModel>[].obs;
  var currentIndex = 0.obs;
  var isLoading = false.obs;

  late String topicId;
  late String topicTitle;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    topicId = args['topic_id'];
    topicTitle = args['topic_title'] ?? 'Flashcards';
    loadFlashcards();
  }

  //Load flashcards và đánh dấu từ nào đã lưu
  Future<void> loadFlashcards() async {
    isLoading.value = true;
    try {
      // Lấy danh sách flashcards của topic
      final allCards = await flashRepo.getFlashcards(topicId);

      // Lấy danh sách từ đã lưu của user
      final saved = await savedRepo.getSavedWords();
      final savedIds = saved.map((x) => x.id).toSet();

      // Gắn cờ isSaved = true cho flashcards trùng ID
      vocabularies.value = allCards.map((e) {
        return e.copyWith(isSaved: savedIds.contains(e.id));
      }).toList();
    } catch (e) {
      print("Error load flashcards: $e");
    } finally {
      isLoading.value = false;
    }
  }

  //Toggle lưu / bỏ lưu
  Future<void> toggleSave(FlashCardModel word) async {
    final index = vocabularies.indexWhere((w) => w.id == word.id);
    if (index == -1) return;

    try {
      final saved = await flashRepo.toggleSave(word.id!);
      vocabularies[index] = word.copyWith(isSaved: saved);
      vocabularies.refresh();
    } catch (e) {
      print("Lỗi toggleSave: $e");
    }
  }

  // void nextCard() {
  //   if (currentIndex.value < vocabularies.length - 1) currentIndex.value++;
  // }
  void nextCard() {
    if (currentIndex.value < vocabularies.length - 1) {
      currentIndex.value++;
    } else {
      currentIndex.value = 0;
      Get.toNamed('/endFlashCard', arguments: {
        'topic_id': topicId,
        'topic_title': topicTitle,
      });
    }
  }


  void prevCard() {
    if (currentIndex.value > 0) currentIndex.value--;
  }

  Future<void> playAudio(String? url) async {
    if (url != null && url.isNotEmpty) {
      try {
        await player.stop();
        await player.play(UrlSource(url));
      } catch (e) {
        print("Audio error: $e");
      }
    }
  }
}
