import 'package:es_english/cores/constants/api_paths.dart';
import 'package:es_english/cores/constants/base_api_client.dart';
import '../../../models/login/reset_password_request_model.dart';

class ResetPasswordRepository {
  final BaseApiClient _client = BaseApiClient();

  Future<bool> resetPassword(ResetPasswordRequestModel request) async {
    try {
      final response = await _client.post(
        ApiPaths.resetPassword,
        data: request.toJson(),
      );

      // Kiểm tra response thành công
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        return true;
      }
      return false;
    } catch (e) {
      print("Reset Password Error: $e");
      rethrow;
    }
  }
}