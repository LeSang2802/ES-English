import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/login/login_request_model.dart';
import '../../../routes/route_name.dart';
import '../../constants/local_storage.dart';
import '../../cores/study_time/study_time_service.dart';
import 'login_repository.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var isPasswordHidden = true.obs;
  var isLoading = false.obs;

  final LoginRepository _loginRepo = LoginRepository();
  final LocalStorage _storage = LocalStorage();

  Future<void> onLogin() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar("Error", "Please enter email and password");
      return;
    }

    isLoading.value = true;

    final request = LoginRequestModel(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    final response = await _loginRepo.login(request);

    isLoading.value = false;

    if (response != null && response.token != null) {
      _storage.token = response.token;
      _storage.user = response.user;

      await StudyTimeService.to.startSession();

      Get.snackbar("Success", "Login successful!");
      Get.offAllNamed(RouteNames.home);
    } else {
      Get.snackbar("Login Failed", response?.message ?? "Invalid credentials");
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}