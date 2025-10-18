import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'register_controller.dart';

class RegisterPage extends GetView<RegisterController> {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Đăng ký tài khoản"),
        centerTitle: true,
      ),
      body: Obx(() {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Stack(
            children: [
              _buildContent(),
              if (controller.isLoading.value)
                const Center(child: CircularProgressIndicator()),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildContent() {
    switch (controller.currentStep.value) {
      case 0:
        return _buildEmailStep();
      case 1:
        return _buildOtpStep();
      case 2:
        return _buildRegisterStep();
      default:
        return Container();
    }
  }

  // STEP 1: EMAIL
  Widget _buildEmailStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Nhập Email để nhận mã xác minh"),
        const SizedBox(height: 20),
        TextField(
          controller: controller.emailController,
          decoration: const InputDecoration(
            labelText: "Email",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: controller.sendCode,
          child: const Text("Gửi mã xác minh"),
        ),
      ],
    );
  }

  // STEP 2: OTP
  Widget _buildOtpStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Nhập mã OTP đã gửi Email"),
        const SizedBox(height: 20),
        TextField(
          controller: controller.otpController,
          decoration: const InputDecoration(
            labelText: "Mã OTP",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: controller.verifyCode,
          child: const Text("Xác minh mã"),
        ),
      ],
    );
  }

  // STEP 3: ĐĂNG KÝ
  Widget _buildRegisterStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Tạo tài khoản"),
        const SizedBox(height: 20),
        TextField(
          controller: controller.usernameController,
          decoration: const InputDecoration(
            labelText: "Username",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: controller.passwordController,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: "Password",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: controller.registerAccount,
          child: const Text("Đăng ký"),
        ),
      ],
    );
  }
}
