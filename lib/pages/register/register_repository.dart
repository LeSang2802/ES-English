import 'package:dio/dio.dart';

import '../../cores/constants/api_paths.dart';
import '../../cores/constants/base_api_client.dart';
import '../../models/login/register_request_model.dart';
import '../../models/login/register_response_model.dart';

class RegisterRepository {
  final BaseApiClient _client = BaseApiClient();

  /// Gửi mã OTP đến email
  Future<bool> sendCode(String email) async {
    try {
      final response = await _client.post(
        ApiPaths.sendCode,
        data: {"email": email},
      );
      return response.statusCode == 200;
    } catch (e) {
      print("SendCode Error: $e");
      return false;
    }
  }

  /// Xác minh mã OTP
  Future<bool> verifyCode(String email, String code) async {
    try {
      final response = await _client.post(
        ApiPaths.verifyCode,
        data: {"email": email, "code": code},
      );
      return response.statusCode == 200;
    } catch (e) {
      print("VerifyCode Error: $e");
      return false;
    }
  }

  /// Đăng ký tài khoản sau khi OTP OK
  Future<RegisterResponseModel?> register(RegisterRequestModel request) async {
    try {
      final response = await _client.post(
        ApiPaths.register,
        data: request.toJson(),
      );
      return RegisterResponseModel.fromJson(response.data);
    } catch (e) {
      print("Register Error: $e");
      return null;
    }
  }
}
