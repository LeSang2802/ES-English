import 'package:get/get.dart';
import '../../cores/translates/language_controller.dart';

class AccountController extends GetxController {
  final languageController = Get.find<LanguageController>();

  // Mock user data
  final RxString userName = "Pham Long".obs;
  final RxInt learnedToday = 46.obs;
  final RxInt targetToday = 60.obs;

  // Dark mode (tạm thời chưa kích hoạt theme engine)
  final RxBool isDarkMode = false.obs;

  // Đổi ngôn ngữ
  Future<void> changeLanguage(String code) async {
    await languageController.changeLanguage(code);
  }

  String get currentLangCode =>
      languageController.currentLocale.value.languageCode;

  double get progressToday =>
      (targetToday.value == 0) ? 0 : (learnedToday.value / targetToday.value)
          .clamp(0, 1)
          .toDouble();

  void toggleDarkMode(bool v) {
    isDarkMode.value = v;
    // TODO: hook vào ThemeService nếu bạn có
  }

  void logout() {
    Get.snackbar("Logout", "Bạn đã đăng xuất!");
  }
}
