import 'package:es_english/cores/constants/api_paths.dart';
import 'package:es_english/cores/constants/base_api_client.dart';

import '../../../models/login/user_model.dart';

class ProfileRepository {
  final BaseApiClient _client = BaseApiClient();

  //Lấy thông tin hồ sơ người dùng
  Future<UserModel?> getProfile() async {
    try {
      final res = await _client.get(ApiPaths.profile);
      return UserModel.fromJson(res.data['user']);
    } catch (e) {
      print(" getProfile error: $e");
      rethrow;
    }
  }

  //Cập nhật thông tin hồ sơ người dùng
  Future<UserModel?> updateProfile(UserModel user) async {
    try {
      final body = {
        "full_name": user.fullName,
        "gender": user.gender,
        "age": user.age,
        "occupation": user.occupation,
        "avatar_url": user.avatarUrl,
      };
      final res = await _client.put(ApiPaths.profile, data: body);
      return UserModel.fromJson(res.data['user']);
    } catch (e) {
      print("updateProfile error: $e");
      rethrow;
    }
  }
}
