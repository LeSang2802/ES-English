import 'package:es_english/pages/register/register_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/local_storage.dart';
import '../../models/login/register_request_model.dart';

class RegisterController extends GetxController {
  final emailController = TextEditingController();
  final otpController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  var currentStep = 0.obs; // 0 = email, 1 = otp, 2 = create account
  var isLoading = false.obs;

  final RegisterRepository _registerRepo = RegisterRepository();
  final LocalStorage _storage = LocalStorage();

  // ================= STEP 1: SEND CODE =================
  Future<void> sendCode() async {
    if (emailController.text.isEmpty) {
      Get.snackbar("Lỗi", "Vui lòng nhập Email");
      return;
    }

    isLoading.value = true;
    bool success = await _registerRepo.sendCode(emailController.text.trim());
    isLoading.value = false;

    if (success) {
      Get.snackbar("Thành công", "Mã xác minh đã được gửi");
      currentStep.value = 1;
    } else {
      Get.snackbar("Thất bại", "Không gửi được mã xác minh");
    }
  }

  // ================= STEP 2: VERIFY CODE =================
  Future<void> verifyCode() async {
    if (otpController.text.isEmpty) {
      Get.snackbar("Lỗi", "Vui lòng nhập mã OTP");
      return;
    }

    isLoading.value = true;
    bool success = await _registerRepo.verifyCode(
      emailController.text.trim(),
      otpController.text.trim(),
    );
    isLoading.value = false;

    if (success) {
      Get.snackbar("Thành công", "Xác minh OTP thành công");
      currentStep.value = 2;
    } else {
      Get.snackbar("Thất bại", "Mã OTP không chính xác");
    }
  }

  // ================= STEP 3: REGISTER ACCOUNT =================
  Future<void> registerAccount() async {
    if (usernameController.text.isEmpty ||
        passwordController.text.isEmpty) {
      Get.snackbar("Lỗi", "Vui lòng nhập Username & Password");
      return;
    }

    final request = RegisterRequestModel(
      username: usernameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    isLoading.value = true;
    final response = await _registerRepo.register(request);
    isLoading.value = false;

    if (response != null && response.user != null) {
      Get.snackbar("Thành công", "Đăng ký thành công, vui lòng đăng nhập!");

      // 🔁 Điều hướng về Login (thay đổi route nếu cần)
      Get.offAllNamed("/login");

    } else {
      Get.snackbar("Thất bại", response?.message ?? "Không thể đăng ký");
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    otpController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
