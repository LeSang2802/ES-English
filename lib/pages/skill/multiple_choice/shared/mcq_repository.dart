import 'package:es_english/cores/constants/api_paths.dart';
import 'package:es_english/cores/constants/base_api_client.dart';

/// Repository xử lý toàn bộ logic Attempt (start, answer, submit)
class McqRepository {
  final BaseApiClient _client = BaseApiClient();

  /// Bắt đầu attempt mới cho 1 content
  Future<String> startAttempt(Map<String, dynamic> payload) async {
    final res = await _client.post(ApiPaths.attemptStart, data: payload);
    return res.data['_id'];
  }

  /// Gửi đáp án cho 1 câu hỏi
  Future<Map<String, dynamic>> answerQuestion({
    required String attemptId,
    required String questionId,
    required String chosenOptionId,
  }) async {
    final res = await _client.post(ApiPaths.attemptAnswer, data: {
      "attempt_id": attemptId,
      "question_id": questionId,
      "chosen_option_id": chosenOptionId,
    });
    return res.data;
  }

  /// Nộp bài
  Future<Map<String, dynamic>> submitAttempt(String attemptId) async {
    final res = await _client.post(ApiPaths.attemptSubmit, data: {
      "attempt_id": attemptId,
    });
    return res.data;
  }

  /// Lấy tiến độ tổng hợp người dùng
  Future<Map<String, dynamic>> getMyProgress() async {
    final res = await _client.get(ApiPaths.attemptProgress);
    return res.data;
  }
}
