import 'package:dio/dio.dart';
import '../../cores/constants/api_paths.dart';
import '../../cores/constants/base_api_client.dart';
import '../../models/login/login_request_model.dart';
import '../../models/login/login_response_model.dart';

class LoginRepository {
  final BaseApiClient _client = BaseApiClient();

  Future<LoginResponseModel?> login(LoginRequestModel request) async {
    try {
      final response = await _client.post(
        ApiPaths.login,
        data: request.toJson(),
      );

      return LoginResponseModel.fromJson(response.data);
    } catch (e) {
      print("Login Error: $e");
      return null;
    }
  }
}
