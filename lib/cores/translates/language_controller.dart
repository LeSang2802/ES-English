import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';

class LanguageController extends GetxController {
  var currentLocale = const Locale('en').obs;
  RxString currentLanguage = 'en'.obs;

  @override
  void onInit() {
    super.onInit();
    loadLanguage();
  }

  Future<void> loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    String? code = prefs.getString('language');
    if (code != null) {
      currentLocale.value = Locale(code);
      Get.updateLocale(Locale(code));
    }
  }

  Future<void> changeLanguage(String code) async {
    final prefs = await SharedPreferences.getInstance();
    currentLocale.value = Locale(code);
    await prefs.setString('language', code);
    Get.updateLocale(Locale(code));
  }

  void switchLanguage(String langCode) async {
    currentLanguage.value = langCode;
    Get.updateLocale(Locale(langCode));

    final prefs = await SharedPreferences.getInstance();
    prefs.setString('language_code', langCode);
  }
}
