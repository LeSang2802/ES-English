import 'package:es_english/pages/account/profile/profile_repository.dart';
import 'package:get/get.dart';
import '../../../constants/local_storage.dart';
import '../../../models/login/user_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:es_english/cores/services/cloudinary_service.dart';
import '../../home/home_controller.dart';
import '../account_controller.dart';

class ProfileController extends GetxController {
  final repo = ProfileRepository();
  final _localStorage = LocalStorage();
  final user = Rxn<UserModel>();
  final isLoading = false.obs;
  final isSaving = false.obs;
  final isUploadingAvatar = false.obs;
  final ImagePicker _imagePicker = ImagePicker();
  final CloudinaryService _cloudinaryService = CloudinaryService();
  late TextEditingController fullNameController;
  late TextEditingController ageController;
  late TextEditingController occupationController;

  @override
  void onInit() {
    super.onInit();
    fullNameController = TextEditingController();
    ageController = TextEditingController();
    occupationController = TextEditingController();

    loadProfile();
  }

  Future<void> loadProfile() async {
    isLoading.value = true;
    try {
      user.value = await repo.getProfile();
      fullNameController.text = user.value?.fullName ?? "";
      ageController.text = user.value?.age?.toString() ?? "";
      occupationController.text = user.value?.occupation ?? "";
    } catch (e) {
      Get.snackbar('error'.tr, 'no_data'.tr);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickAndUploadAvatar() async {
    final XFile? image =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    isUploadingAvatar.value = true;
    try {
      final newUrl = await _cloudinaryService.uploadImage(image.path);

      if (newUrl != null) {
        user.value = user.value?.copyWith(avatarUrl: newUrl);
        Get.snackbar('success'.tr, 'photo_uploaded'.tr);
      } else {
        Get.snackbar('error'.tr, 'photo_upload_failed'.tr);
      }
    } catch (e) {
      Get.snackbar('error'.tr, "${'photo_upload_failed'.tr} $e");
    } finally {
      isUploadingAvatar.value = false;
    }
  }

  Future<void> saveProfile() async {
    if (user.value == null) return;
    isSaving.value = true;
    try {
      final updatedUser = await repo.updateProfile(user.value!);
      user.value = updatedUser;
      if (updatedUser != null) {
        _localStorage.user = updatedUser;

        if (Get.isRegistered<AccountController>()) {
          Get.find<AccountController>().updateUser(updatedUser);
        }
        if (Get.isRegistered<HomeController>()) {
          Get.find<HomeController>().updateUser(updatedUser);
        }
      }

      Get.snackbar('success'.tr, 'profile_update_successful'.tr);
    } catch (e) {
      Get.snackbar('error', 'cannot_save'.tr);
    } finally {
      isSaving.value = false;
    }
  }

  @override
  void onClose() {
    super.onClose();
    fullNameController.dispose();
    ageController.dispose();
    occupationController.dispose();
  }
}
