// import 'package:es_english/cores/constants/api_paths.dart';
// import 'package:es_english/cores/constants/base_api_client.dart';
// import 'package:es_english/models/test/test_response_model.dart';
//
// class TestRepository {
//   final BaseApiClient _client = BaseApiClient();
//
//   /// Lấy danh sách các bài thi
//   Future<List<TestResponseModel>> getTests() async {
//     try {
//       final response = await _client.get('${ApiPaths.test}');
//       final data = TestListResponse.fromJson(response.data);
//       return data.items ?? [];
//     } catch (e) {
//       print('Error getTests: $e');
//       rethrow;
//     }
//   }
//
//   /// Lấy nội dung bài thi (danh sách câu hỏi)
//   Future<TestQuestionsResponse> getTestQuestions(String testId) async {
//     try {
//       final response = await _client.get('${ApiPaths.test}/$testId/questions');
//       return TestQuestionsResponse.fromJson(response.data);
//     } catch (e) {
//       print('Error getTestQuestions: $e');
//       rethrow;
//     }
//   }
//
//   /// Bắt đầu bài thi
//   Future<String> startTest(String testId) async {
//     try {
//       final response = await _client.post('${ApiPaths.test}/$testId/start');
//       final data = StartTestResponse.fromJson(response.data);
//       return data.attemptId ?? '';
//     } catch (e) {
//       print('Error startTest: $e');
//       rethrow;
//     }
//   }
//
//
//   Future<AnswerMultiResponse> answerMulti(String attemptId, List<UserAnswer> answers) async {
//     try {
//       final response = await _client.post(
//         ApiPaths.testAnswerMulti,
//         data: {
//           'attempt_id': attemptId,
//           'answers': answers.map((a) => {
//             'bank_question_id': a.bankQuestionId,
//             'chosen_option_label': a.chosenOptionLabel,
//           }).toList(),
//         },
//       );
//       return AnswerMultiResponse.fromJson(response.data);
//     } catch (e) {
//       print('Error answerMulti: $e');
//       rethrow;
//     }
//   }
//
//   Future<SubmitTestResponse> submitTest(String attemptId) async {
//     try {
//       final response = await _client.post(
//         ApiPaths.testSubmit,
//         data: {'attempt_id': attemptId},
//       );
//       return SubmitTestResponse.fromJson(response.data);
//     } catch (e) {
//       print('Error submitTest: $e');
//       rethrow;
//     }
//   }
// }

import 'package:es_english/cores/constants/api_paths.dart';
import 'package:es_english/cores/constants/base_api_client.dart';
import 'package:es_english/models/test/test_response_model.dart';

class TestRepository {
  final BaseApiClient _client = BaseApiClient();

  /// Lấy danh sách các bài thi
  Future<List<TestResponseModel>> getTests() async {
    try {
      final response = await _client.get('${ApiPaths.test}');
      final data = TestListResponse.fromJson(response.data);
      return data.items ?? [];
    } catch (e) {
      print('❌ Error getTests: $e');
      rethrow;
    }
  }

  /// Lấy nội dung bài thi (danh sách câu hỏi)
  Future<TestQuestionsResponse> getTestQuestions(String testId) async {
    try {
      final response = await _client.get('${ApiPaths.test}/$testId/questions');
      return TestQuestionsResponse.fromJson(response.data);
    } catch (e) {
      print('❌ Error getTestQuestions: $e');
      rethrow;
    }
  }

  /// Bắt đầu bài thi
  Future<String> startTest(String testId) async {
    try {
      print('🚀 Calling API: POST ${ApiPaths.test}/$testId/start');

      final response = await _client.post('${ApiPaths.test}/$testId/start');

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response data: ${response.data}');

      // Response trả về object "attempt", không phải trực tiếp "attempt_id"
      if (response.data != null && response.data is Map<String, dynamic>) {
        // Kiểm tra cấu trúc: { "attempt": { "_id": "...", ... } }
        if (response.data.containsKey('attempt')) {
          final attemptData = response.data['attempt'];
          final attemptId = attemptData['_id'] as String?;

          if (attemptId != null && attemptId.isNotEmpty) {
            print('✅ Got attempt_id: $attemptId');
            return attemptId;
          }
        }

        // Fallback: Thử parse bằng model
        final data = StartTestResponse.fromJson(response.data);
        if (data.attemptId != null && data.attemptId!.isNotEmpty) {
          print('✅ Got attempt_id from model: ${data.attemptId}');
          return data.attemptId!;
        }
      }

      throw Exception('Response không chứa attempt_id');
    } catch (e) {
      print('❌ Error startTest: $e');
      rethrow;
    }
  }

  Future<AnswerMultiResponse> answerMulti(String attemptId, List<UserAnswer> answers) async {
    try {
      print('🚀 Calling API: POST ${ApiPaths.testAnswerMulti}');
      print('📤 Payload: attempt_id=$attemptId, answers count=${answers.length}');

      final response = await _client.post(
        ApiPaths.testAnswerMulti,
        data: {
          'attempt_id': attemptId,
          'answers': answers.map((a) => {
            'bank_question_id': a.bankQuestionId,
            'chosen_option_label': a.chosenOptionLabel,
          }).toList(),
        },
      );

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response data: ${response.data}');

      return AnswerMultiResponse.fromJson(response.data);
    } catch (e) {
      print('❌ Error answerMulti: $e');
      rethrow;
    }
  }

  Future<SubmitTestResponse> submitTest(String attemptId) async {
    try {
      print('🚀 Calling API: POST ${ApiPaths.testSubmit}');
      print('📤 Payload: attempt_id=$attemptId');

      final response = await _client.post(
        ApiPaths.testSubmit,
        data: {'attempt_id': attemptId},
      );

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response data: ${response.data}');

      return SubmitTestResponse.fromJson(response.data);
    } catch (e) {
      print('❌ Error submitTest: $e');
      rethrow;
    }
  }
}


// import 'package:es_english/cores/constants/api_paths.dart';
// import 'package:es_english/cores/constants/base_api_client.dart';
// import 'package:es_english/models/test/test_response_model.dart';
//
// class TestRepository {
//   final BaseApiClient _client = BaseApiClient();
//
//   /// Lấy danh sách các bài thi
//   Future<List<TestResponseModel>> getTests() async {
//     try {
//       print('🔵 API Call: GET ${ApiPaths.test}');
//       final response = await _client.get(ApiPaths.test);
//       print('✅ Response getTests: ${response.data}');
//
//       final data = TestListResponse.fromJson(response.data);
//       return data.items ?? [];
//     } catch (e) {
//       print('❌ Error getTests: $e');
//       rethrow;
//     }
//   }
//
//   /// Lấy nội dung bài thi (danh sách câu hỏi)
//   Future<TestQuestionsResponse> getTestQuestions(String testId) async {
//     try {
//       final url = '${ApiPaths.test}/$testId/questions';
//       print('🔵 API Call: GET $url');
//
//       final response = await _client.get(url);
//       print('✅ Response getTestQuestions: ${response.data}');
//
//       return TestQuestionsResponse.fromJson(response.data);
//     } catch (e) {
//       print('❌ Error getTestQuestions: $e');
//       rethrow;
//     }
//   }
//
//   /// Bắt đầu bài thi
//   Future<String> startTest(String testId) async {
//     try {
//       final url = '${ApiPaths.test}/$testId/start';
//       print('🔵 API Call: POST $url');
//
//       final response = await _client.post(url, data: {});
//       print('✅ Response startTest: ${response.data}');
//
//       // Kiểm tra cả 2 trường hợp: attempt_id hoặc _id
//       final attemptId = response.data['attempt_id'] ??
//           response.data['_id'] ??
//           '';
//
//       if (attemptId.isEmpty) {
//         throw Exception('attempt_id not found in response: ${response.data}');
//       }
//
//       print('✅ Got attemptId: $attemptId');
//       return attemptId;
//     } catch (e) {
//       print('❌ Error startTest: $e');
//       rethrow;
//     }
//   }
//
//   /// Gửi câu trả lời (nhiều câu)
//   Future<AnswerMultiResponse> answerMulti(
//       String attemptId,
//       List<UserAnswer> answers
//       ) async {
//     try {
//       final payload = {
//         'attempt_id': attemptId,
//         'answers': answers.map((a) => {
//           'bank_question_id': a.bankQuestionId,
//           'chosen_option_label': a.chosenOptionLabel,
//         }).toList(),
//       };
//
//       print('🔵 API Call: POST ${ApiPaths.testAnswerMulti}');
//       print('📦 Payload: $payload');
//
//       final response = await _client.post(
//         ApiPaths.testAnswerMulti,
//         data: payload,
//       );
//
//       print('✅ Response answerMulti: ${response.data}');
//       return AnswerMultiResponse.fromJson(response.data);
//     } catch (e) {
//       print('❌ Error answerMulti: $e');
//       rethrow;
//     }
//   }
//
//   /// Nộp bài thi
//   Future<SubmitTestResponse> submitTest(String attemptId) async {
//     try {
//       final payload = {'attempt_id': attemptId};
//
//       print('🔵 API Call: POST ${ApiPaths.testSubmit}');
//       print('📦 Payload: $payload');
//
//       final response = await _client.post(
//         ApiPaths.testSubmit,
//         data: payload,
//       );
//
//       print('✅ Response submitTest: ${response.data}');
//       return SubmitTestResponse.fromJson(response.data);
//     } catch (e) {
//       print('❌ Error submitTest: $e');
//       rethrow;
//     }
//   }
// }