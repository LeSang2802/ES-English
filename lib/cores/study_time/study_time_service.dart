

import 'package:es_english/cores/study_time/study_time_repository.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';

import '../../constants/local_storage.dart';

class StudyTimeService extends GetxService {
  static StudyTimeService get to => Get.find();

  final StudyTimeRepository _repository = StudyTimeRepository();
  final LocalStorage _storage = LocalStorage();

  DateTime? _sessionStartTime;
  bool _isTracking = false;

  /// Bắt đầu tracking thời gian học
  Future<void> startSession() async {
    if (_isTracking) {
      print('⚠️ Session already started');
      return;
    }

    _sessionStartTime = DateTime.now();
    _isTracking = true;

    _storage.sessionStartTime = _sessionStartTime;
    _storage.isTrackingSession = true;

    print('📚 Started tracking study time: $_sessionStartTime');
  }

  /// Kết thúc session và POST lên API
  Future<void> endSession() async {
    if (!_isTracking || _sessionStartTime == null) {
      print('⚠️ No active session to end');
      return;
    }

    final endTime = DateTime.now();
    final durationInSeconds = endTime.difference(_sessionStartTime!).inSeconds;

    // Chỉ gửi nếu học >= 5 giây
    if (durationInSeconds >= 5) {
      try {
        final date = _formatDate(endTime);

        await _repository.postStudyTime(
          date: date,
          duration: durationInSeconds,
        );

        print('✅ Posted study time: $date - $durationInSeconds seconds');
      } catch (e) {
        print('❌ Error posting study time: $e');
        final date = _formatDate(endTime);
        _storage.addFailedSession(date, durationInSeconds);
      }
    } else {
      print('⏭️ Session too short ($durationInSeconds seconds), skipped');
    }

    // Reset session
    _sessionStartTime = null;
    _isTracking = false;
    _storage.sessionStartTime = null;
    _storage.isTrackingSession = false;
  }

  /// Khôi phục session nếu app bị kill
  Future<void> restoreSession() async {
    final isTracking = _storage.isTrackingSession;
    final startTime = _storage.sessionStartTime;

    if (isTracking && startTime != null) {
      _sessionStartTime = startTime;
      _isTracking = true;
      print('🔄 Restored session from: $_sessionStartTime');
    }
  }

  /// Retry các session thất bại
  Future<void> retryFailedSessions() async {
    final failedSessions = _storage.failedSessions;

    if (failedSessions.isEmpty) {
      print('✅ No failed sessions to retry');
      return;
    }

    print('🔄 Retrying ${failedSessions.length} failed sessions...');

    for (final sessionStr in List.from(failedSessions)) {
      try {
        final parts = sessionStr.split('|');
        final date = parts[0];
        final duration = int.parse(parts[1]);

        await _repository.postStudyTime(date: date, duration: duration);

        _storage.removeFailedSession(sessionStr);
        print('✅ Retry success: $date - $duration seconds');
      } catch (e) {
        print('❌ Retry failed: $sessionStr - $e');
      }
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  bool get isTracking => _isTracking;

  int get currentSessionDuration {
    if (!_isTracking || _sessionStartTime == null) return 0;
    return DateTime.now().difference(_sessionStartTime!).inSeconds;
  }
}