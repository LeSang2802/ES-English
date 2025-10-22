import 'package:get/get.dart';
import 'package:es_english/cores/utils/dummy_util.dart';
import 'package:es_english/models/home/home_continue_model.dart';
import 'package:es_english/models/home/home_flashcard_model.dart';

import '../../constants/local_storage.dart';
import '../../models/login/user_model.dart';

class HomeController extends GetxController {
  final LocalStorage _storage = LocalStorage();

  final Rxn<UserModel> user = Rxn<UserModel>();
  final RxInt learnedTodayMin = 0.obs;
  final RxInt targetMin = DummyUtil.targetMinutes.obs;

  final Rx<HomeContinue?> dailyChallenge = Rx<HomeContinue?>(null);
  final Rx<HomeFlashcardSuggestion?> flashcard = Rx<HomeFlashcardSuggestion?>(null);

  final RxList<String> sliderImages = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    user.value = _storage.user;
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
    Get.toNamed('/vocabulary');
  }

  double get progressToday =>
      (targetMin.value == 0) ? 0 : (learnedTodayMin.value / targetMin.value).clamp(0, 1);

  String get displayName {
    final fullName = user.value?.fullName?.trim() ?? '';
    if (fullName.isEmpty) return 'User';
    return fullName.split(' ').last;
  }
}
