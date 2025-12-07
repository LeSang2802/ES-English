import 'package:dio/dio.dart';
import 'package:es_english/cores/constants/api_paths.dart';
import 'package:es_english/cores/constants/base_api_client.dart';
import '../../../../models/skill/multiple_choice/attempt_request.dart';

class McqRepository {
  final BaseApiClient _client = BaseApiClient();

  /// Bắt đầu attempt mới
  Future<String> startAttempt(StartAttemptRequest request) async {
    try {
      print("📤 POST ${ApiPaths.attemptStart}");
      print("   Body: ${request.toJson()}");

      final res = await _client.post(
        ApiPaths.attemptStart,
        data: request.toJson(),
      );

      print("📥 Response: ${res.data}");

      final attemptId = res.data['_id']?.toString();

      if (attemptId == null || attemptId.isEmpty) {
        throw Exception('Backend không trả về _id');
      }

      return attemptId;

    } on DioException catch (e) {
      print("❌ DioException in startAttempt:");
      print("   Status: ${e.response?.statusCode}");
      print("   Data: ${e.response?.data}");
      print("   Message: ${e.message}");
      rethrow;
    } catch (e) {
      print("❌ Error in startAttempt: $e");
      rethrow;
    }
  }

  /// Gửi đáp án
  Future<Map<String, dynamic>> answerQuestion(
      AnswerQuestionRequest request,
      ) async {
    try {
      print("📤 POST ${ApiPaths.attemptAnswer}");
      print("   Body: ${request.toJson()}");

      final res = await _client.post(
        ApiPaths.attemptAnswer,
        data: request.toJson(),
      );

      print("📥 Response: ${res.data}");

      return Map<String, dynamic>.from(res.data);

    } on DioException catch (e) {
      print("❌ DioException in answerQuestion:");
      print("   Status: ${e.response?.statusCode}");
      print("   Data: ${e.response?.data}");
      print("   Message: ${e.message}");
      rethrow;
    } catch (e) {
      print("❌ Error in answerQuestion: $e");
      rethrow;
    }
  }

  /// Nộp bài
  Future<Map<String, dynamic>> submitAttempt(
      SubmitAttemptRequest request,
      ) async {
    try {
      print("📤 POST ${ApiPaths.attemptSubmit}");
      print("   Body: ${request.toJson()}");

      final res = await _client.post(
        ApiPaths.attemptSubmit,
        data: request.toJson(),
      );

      print("📥 Response: ${res.data}");

      return Map<String, dynamic>.from(res.data);

    } on DioException catch (e) {
      print("❌ DioException in submitAttempt:");
      print("   Status: ${e.response?.statusCode}");
      print("   Data: ${e.response?.data}");
      print("   Message: ${e.message}");
      rethrow;
    } catch (e) {
      print("❌ Error in submitAttempt: $e");
      rethrow;
    }
  }

  /// Lấy tiến độ
  Future<Map<String, dynamic>> getMyProgress() async {
    try {
      print("📤 GET ${ApiPaths.progress}");

      final res = await _client.get(ApiPaths.progress);

      print("📥 Response keys: ${res.data.keys}");

      return Map<String, dynamic>.from(res.data);

    } on DioException catch (e) {
      print("❌ DioException in getMyProgress:");
      print("   Status: ${e.response?.statusCode}");
      print("   Data: ${e.response?.data}");
      rethrow;
    } catch (e) {
      print("❌ Error in getMyProgress: $e");
      rethrow;
    }
  }
}