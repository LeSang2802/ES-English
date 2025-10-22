import 'package:get/get.dart';
import '../../constants/local_storage.dart';
import '../../cores/translates/language_controller.dart';
import '../../models/login/user_model.dart';

class AccountController extends GetxController {
  final languageController = Get.find<LanguageController>();

  final LocalStorage _storage = LocalStorage();

  final Rxn<UserModel> user = Rxn<UserModel>();
  final RxInt learnedToday = 46.obs;
  final RxInt targetToday = 60.obs;

  // Dark mode (tạm thời chưa kích hoạt theme engine)
  final RxBool isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Lấy user từ LocalStorage
    user.value = _storage.user;
  }

  String get displayName {
    final fullName = user.value?.fullName?.trim() ?? '';
    if (fullName.isEmpty) return 'User';
    return fullName.split(' ').last;
  }

  String? get avatarUrl => user.value?.avatarUrl;

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
    // hook vào ThemeService
  }

  void logout() {
    Get.snackbar("Logout", "Bạn đã đăng xuất!");
  }
}
