import 'package:get/get.dart';
import '../../constants/local_storage.dart';
import '../../models/login/user_model.dart';
import '../../cores/translates/language_controller.dart';

class AccountController extends GetxController {
  final languageController = Get.find<LanguageController>();
  final LocalStorage _storage = LocalStorage();
  final Rxn<UserModel> user = Rxn<UserModel>();
  final RxInt learnedToday = 46.obs;
  final RxInt targetToday = 60.obs;
  final RxBool isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    user.value = _storage.user;
  }

  void updateUser(UserModel updatedUser) {
    user.value = updatedUser;
    update();
  }

  Future<void> logout() async {
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

  double get progressToday => (targetToday.value == 0)
      ? 0
      : (learnedToday.value / targetToday.value).clamp(0, 1).toDouble();

  void toggleDarkMode(bool v) {
    isDarkMode.value = v;
  }
}
