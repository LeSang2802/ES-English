import 'package:es_english/pages/account/profile/profile_repository.dart';
import 'package:get/get.dart';
import '../../../models/login/user_model.dart';

class ProfileController extends GetxController {
  final repo = ProfileRepository();
  final user = Rxn<UserModel>();
  final isLoading = false.obs;
  final isSaving = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  //Gọi API lấy thông tin hồ sơ
  Future<void> loadProfile() async {
    isLoading.value = true;
    try {
      user.value = await repo.getProfile();
    } catch (e) {
      Get.snackbar("Lỗi", "Không tải được thông tin hồ sơ");
    } finally {
      isLoading.value = false;
    }
  }

  //Gọi API cập nhật hồ sơ
  Future<void> saveProfile() async {
    if (user.value == null) return;
    isSaving.value = true;
    try {
      user.value = await repo.updateProfile(user.value!);
      Get.snackbar("Thành công", "Cập nhật hồ sơ thành công");
    } catch (e) {
      Get.snackbar("Lỗi", "Không thể lưu thông tin");
    } finally {
      isSaving.value = false;
    }
  }
}
