import 'package:get/get.dart';
import '../../cores/translates/language_controller.dart';
import 'account_controller.dart';

class AccountBinding extends Bindings {
  @override
  void dependencies() {
    // Bảo đảm LanguageController đã sẵn sàng
    if (!Get.isRegistered<LanguageController>()) {
      Get.put(LanguageController(), permanent: true);
    }
    Get.lazyPut<AccountController>(() => AccountController());
  }
}
