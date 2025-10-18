import 'package:get/get.dart';
import 'package:es_english/cores/utils/dummy_util.dart';
import 'package:es_english/models/home/home_continue_model.dart';
import 'package:es_english/models/home/home_flashcard_model.dart';

class HomeController extends GetxController {
  final RxInt learnedTodayMin = 0.obs;
  final RxInt targetMin = DummyUtil.targetMinutes.obs;

  final Rx<HomeContinue?> dailyChallenge = Rx<HomeContinue?>(null);
  final Rx<HomeFlashcardSuggestion?> flashcard = Rx<HomeFlashcardSuggestion?>(null);

  final RxList<String> sliderImages = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    // mock load
    learnedTodayMin.value = DummyUtil.learnedTodayMinutes;
    // dailyChallenge.value = DummyUtil.continueStudy;
    flashcard.value = DummyUtil.flashcard;
    sliderImages.assignAll(DummyUtil.homeSliderImages);
  }

  void onTapChatbot() {
    // Get.snackbar('Chatbot', 'Opening Long L-GPT…');
    Get.toNamed('/chatbot');
  }

  void onTapDailyChallenge() {
    Get.toNamed('/test');
  }

  void onTapFlashcard() {
    final f = flashcard.value;
    if (f == null) return;
    // Get.snackbar('FlashCard', 'Go to: ${f.title}');
    // Get.toNamed('/flashcard', arguments: f);
    Get.toNamed('/vocabulary');
  }

  double get progressToday =>
      (targetMin.value == 0) ? 0 : (learnedTodayMin.value / targetMin.value).clamp(0, 1);
}
