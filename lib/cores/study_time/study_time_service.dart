import 'dart:async';
import 'package:es_english/cores/study_time/study_time_repository.dart';
import 'package:get/get.dart';
import '../../constants/local_storage.dart';
import '../../models/study_time/study_time_request_model.dart';

class StudyTimeService extends GetxService {
  static StudyTimeService get to => Get.find();

  final StudyTimeRepository _repository = StudyTimeRepository();
  final LocalStorage _storage = LocalStorage();

  Timer? _timer;
  int _accumulatedSeconds = 0;
  bool _isTracking = false;

  static const int POST_INTERVAL_SECONDS = 300; // 5 phút = 300 giây

  /// Bắt đầu tracking và đếm thời gian
  Future<void> startSession() async {
    if (_isTracking) {
      print('⚠️ Session already started');
      return;
    }

    _isTracking = true;
    _storage.isTrackingSession = true;

    // Khôi phục số giây đã tích lũy (nếu có)
    _accumulatedSeconds = _storage.accumulatedSeconds ?? 0;

    print('📚 Started tracking study time. Accumulated: $_accumulatedSeconds seconds');

    // Bắt đầu timer đếm mỗi giây
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _accumulatedSeconds++;
      _storage.accumulatedSeconds = _accumulatedSeconds;

      // Mỗi 5 phút (300 giây), post lên server
      if (_accumulatedSeconds >= POST_INTERVAL_SECONDS) {
        _postAndReset();
      }
    });
  }

  /// Kết thúc session
  Future<void> endSession() async {
    if (!_isTracking) {
      print('⚠️ No active session to end');
      return;
    }

    _timer?.cancel();
    _timer = null;

    // Nếu có số giây tích lũy < 300s, vẫn lưu lại để lần sau tiếp tục đếm
    print('⏸️ Session paused. Accumulated: $_accumulatedSeconds seconds (saved for next session)');

    _isTracking = false;
    _storage.isTrackingSession = false;
  }

  /// Post lên server và reset về 0
  Future<void> _postAndReset() async {
    try {
      final date = _formatDate(DateTime.now());

      final request = StudyTimeRequest(
        date: date,
        duration: POST_INTERVAL_SECONDS,
      );

      await _repository.postStudyTime(request);

      print('✅ Posted study time: $date - $POST_INTERVAL_SECONDS seconds');

      // Reset về 0 sau khi post thành công
      _accumulatedSeconds = 0;
      _storage.accumulatedSeconds = 0;
    } catch (e) {
      print('❌ Error posting study time: $e');

      // Lưu vào failed sessions để retry sau
      final date = _formatDate(DateTime.now());
      _storage.addFailedSession(date, POST_INTERVAL_SECONDS);

      // Vẫn reset về 0 để tiếp tục đếm chu kỳ mới
      _accumulatedSeconds = 0;
      _storage.accumulatedSeconds = 0;
    }
  }

  /// Khôi phục session nếu app bị kill
  Future<void> restoreSession() async {
    final isTracking = _storage.isTrackingSession;
    final accumulated = _storage.accumulatedSeconds ?? 0;

    if (isTracking) {
      _accumulatedSeconds = accumulated;
      _isTracking = false; // Set false để startSession() có thể chạy lại
      print('🔄 Restored accumulated time: $_accumulatedSeconds seconds');
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

        final request = StudyTimeRequest(
          date: date,
          duration: duration,
        );

        await _repository.postStudyTime(request);

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

  int get currentAccumulatedSeconds => _accumulatedSeconds;

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}