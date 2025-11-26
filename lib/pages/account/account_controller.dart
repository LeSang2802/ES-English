import 'package:es_english/pages/progress/progress_repository.dart';
import 'package:get/get.dart';
import '../../constants/local_storage.dart';
import '../../cores/study_time/study_time_service.dart';
import '../../models/login/user_model.dart';
import '../../cores/translates/language_controller.dart';

class AccountController extends GetxController {
  final languageController = Get.find<LanguageController>();
  final ProgressRepository _progressRepo = ProgressRepository();
  final LocalStorage _storage = LocalStorage();
  final Rxn<UserModel> user = Rxn<UserModel>();
  final RxInt learnedThisWeek = 0.obs;
  final RxInt targetWeek = 120.obs;
  final RxBool isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    user.value = _storage.user;

    _loadWeeklyStudyTime();
  }

  Future<void> _loadWeeklyStudyTime() async {
    try {
      final progressData = await _progressRepo.getMyProgress();
      final totalSeconds = progressData.studyTime?.total7Days ?? 0;
      // Chuyển từ giây sang phút
      learnedThisWeek.value = (totalSeconds / 60).round();
    } catch (e) {
      print('❌ Error loading weekly study time: $e');
      learnedThisWeek.value = 0;
    }
  }

  void updateUser(UserModel updatedUser) {
    user.value = updatedUser;
    update();
  }

  Future<void> logout() async {

    await StudyTimeService.to.endSession();
    await _storage.clearAll();

    Get.snackbar('logout'.tr, 'logout_successfully'.tr,
        snackPosition: SnackPosition.BOTTOM);
    Get.offAllNamed('/login');
  }

  String get displayName {
    final fullName = user.value?.fullName?.trim() ?? '';
    if (fullName.isEmpty) return 'user'.tr;
    return fullName.split(' ').last;
  }

  String? get avatarUrl => user.value?.avatarUrl;

  Future<void> changeLanguage(String code) async {
    await languageController.changeLanguage(code);
  }

  String get currentLangCode =>
      languageController.currentLocale.value.languageCode;

  // double get progressToday => progressWeek;

  double get progressWeek => (targetWeek.value == 0)
      ? 0
      : (learnedThisWeek.value / targetWeek.value).clamp(0, 1).toDouble();

  void toggleDarkMode(bool v) {
    isDarkMode.value = v;
  }
}
