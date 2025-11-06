import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/login/reset_password_request_model.dart';
import 'reset_password_repository.dart';


class ResetPasswordController extends GetxController {
  final ResetPasswordRepository repo = ResetPasswordRepository();

  final formKey = GlobalKey<FormState>();

  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  var isOldPasswordHidden = true.obs;
  var isNewPasswordHidden = true.obs;
  var isConfirmPasswordHidden = true.obs;
  var isLoading = false.obs;

  @override
  void onClose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  // Validate mật khẩu cũ - chỉ kiểm tra không được để trống
  String? validateOldPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'old_password_required'.tr;
    }
    return null;
  }

  // Validate mật khẩu mới - chỉ kiểm tra không được để trống và không trùng mật khẩu cũ
  String? validateNewPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'new_password_required'.tr;
    }

    // Chỉ kiểm tra không trùng mật khẩu cũ
    if (value == oldPasswordController.text) {
      return 'new_password_same_as_old'.tr;
    }

    return null;
  }

  // Validate xác nhận mật khẩu - chỉ kiểm tra khớp với mật khẩu mới
  String? validateConfirmPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'confirm_password_required'.tr;
    }
    if (value != newPasswordController.text) {
      return 'passwords_not_match'.tr;
    }
    return null;
  }

  // Đổi mật khẩu
  Future<void> resetPassword() async {
    // Validate form
    if (formKey.currentState == null || !formKey.currentState!.validate()) {
      Get.snackbar(
        'error'.tr,
        'please_check_input'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
      );
      return;
    }

    isLoading.value = true;

    try {
      final request = ResetPasswordRequestModel(
        old_password: oldPasswordController.text.trim(),
        new_password: newPasswordController.text.trim(),
      );

      final success = await repo.resetPassword(request);

      if (success) {
        Get.snackbar(
          'success'.tr,
          'password_changed_successfully'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade100,
          duration: const Duration(seconds: 3),
        );

        // Đợi 1 giây rồi quay lại
        await Future.delayed(const Duration(seconds: 1));
        Get.back();
      } else {
        Get.snackbar(
          'error'.tr,
          'password_change_failed'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
        );
      }
    } catch (e) {
      print("Error resetting password: $e");

      // Xử lý lỗi cụ thể
      String errorMessage = 'password_change_failed'.tr;
      if (e.toString().contains('401') || e.toString().contains('incorrect')) {
        errorMessage = 'old_password_incorrect'.tr;
      }

      Get.snackbar(
        'error'.tr,
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }
}