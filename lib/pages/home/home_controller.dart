import 'package:get/get.dart';
import 'package:es_english/cores/utils/dummy_util.dart';
import 'package:es_english/models/home/home_continue_model.dart';
import 'package:es_english/models/home/home_flashcard_model.dart';

import '../../constants/local_storage.dart';
import '../../models/login/user_model.dart';
import '../progress/progress_repository.dart';

class HomeController extends GetxController {
  final LocalStorage _storage = LocalStorage();
  final ProgressRepository _progressRepo = ProgressRepository();
  final Rxn<UserModel> user = Rxn<UserModel>();
  // final RxInt learnedTodayMin = 0.obs;
  // final RxInt targetMin = DummyUtil.targetMinutes.obs;
  final RxInt learnedThisWeekMin = 0.obs;
  final RxInt targetWeekMin = 120.obs;
  final Rx<HomeContinue?> dailyChallenge = Rx<HomeContinue?>(null);
  final Rx<HomeFlashcardSuggestion?> flashcard =
      Rx<HomeFlashcardSuggestion?>(null);
  final RxList<String> sliderImages = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    user.value = _storage.user;
    // learnedTodayMin.value = DummyUtil.learnedTodayMinutes;
    // dailyChallenge.value = DummyUtil.continueStudy;
    flashcard.value = DummyUtil.flashcard;
    sliderImages.assignAll(DummyUtil.homeSliderImages);

    _loadWeeklyStudyTime();
  }

  Future<void> _loadWeeklyStudyTime() async {
    try {
      final progressData = await _progressRepo.getMyProgress();
      final totalSeconds = progressData.studyTime?.total7Days ?? 0;
      // Chuyển từ giây sang phút
      learnedThisWeekMin.value = (totalSeconds / 60).round();
    } catch (e) {
      print('❌ Error loading weekly study time: $e');
      learnedThisWeekMin.value = 0;
    }
  }

  void updateUser(UserModel updatedUser) {
    user.value = updatedUser;
    update();
  }

  void onTapChatbot() {
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

  double get progressWeek => (targetWeekMin.value == 0)
      ? 0
      : (learnedThisWeekMin.value / targetWeekMin.value).clamp(0, 1);

  String get displayName {
    final fullName = user.value?.fullName?.trim() ?? '';
    if (fullName.isEmpty) return 'user'.tr;
    return fullName.split(' ').last;
  }
}
