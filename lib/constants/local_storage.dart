import 'package:get_storage/get_storage.dart';
import '../../models/login/user_model.dart';

class LocalStorage {
  static final LocalStorage _instance = LocalStorage._internal();
  factory LocalStorage() => _instance;
  LocalStorage._internal();

  final GetStorage _box = GetStorage();

  // ===== TOKEN =====
  set token(String? value) {
    if (value == null) {
      _box.remove('token');
    } else {
      _box.write('token', value);
    }
  }

  String? get token => _box.read('token');

  // ===== USER =====
  set user(UserModel? user) {
    if (user == null) {
      _box.remove('user');
    } else {
      _box.write('user', user.toJson());
    }
  }

  UserModel? get user {
    final data = _box.read('user');
    if (data != null) {
      return UserModel.fromJson(Map<String, dynamic>.from(data));
    }
    return null;
  }

  // ===== CLEAR ALL STORAGE =====
  Future<void> clearAll() async {
    await _box.erase();
  }
}
