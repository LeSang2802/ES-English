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

  /// ===== STUDY TIME SESSION =====

  // Lưu số giây đã tích lũy
  set accumulatedSeconds(int? value) {
    if (value == null) {
      _box.remove('accumulated_seconds');
    } else {
      _box.write('accumulated_seconds', value);
    }
  }

  int? get accumulatedSeconds => _box.read('accumulated_seconds');

  // Tracking status
  set isTrackingSession(bool value) {
    _box.write('is_tracking', value);
  }

  bool get isTrackingSession => _box.read('is_tracking') ?? false;

  // Lưu các session thất bại để retry
  void addFailedSession(String date, int duration) {
    List<String> failed = failedSessions;
    failed.add('$date|$duration');
    _box.write('failed_sessions', failed);
  }

  List<String> get failedSessions {
    final data = _box.read('failed_sessions');
    if (data is List) {
      return List<String>.from(data);
    }
    return [];
  }

  void removeFailedSession(String session) {
    List<String> failed = failedSessions;
    failed.remove(session);
    _box.write('failed_sessions', failed);
  }

  void clearFailedSessions() {
    _box.remove('failed_sessions');
  }


  // ===== CLEAR ALL STORAGE =====
  Future<void> clearAll() async {
    await _box.erase();
  }
}
