import 'package:freezed_annotation/freezed_annotation.dart';

part 'test_response_model.freezed.dart';
part 'test_response_model.g.dart';

@freezed
class TestResponseModel with _$TestResponseModel {
  const factory TestResponseModel({
    @JsonKey(name: '_id') String? id,
    String? title,
    @JsonKey(name: 'duration_minutes') int? durationMinutes,
    @JsonKey(name: 'skill_id') String? skillId,
    @JsonKey(name: 'created_at') String? createdAt,
  }) = _TestResponseModel;

  factory TestResponseModel.fromJson(Map<String, dynamic> json) =>
      _$TestResponseModelFromJson(json);
}

@freezed
class TestListResponse with _$TestListResponse {
  const factory TestListResponse({
    int? total,
    List<TestResponseModel>? items,
  }) = _TestListResponse;

  factory TestListResponse.fromJson(Map<String, dynamic> json) =>
      _$TestListResponseFromJson(json);
}

@freezed
class QuestionOption with _$QuestionOption {
  const factory QuestionOption({
    @JsonKey(name: '_id') String? id,
    String? label,
    @JsonKey(name: 'option_text') String? optionText,
    @JsonKey(name: 'is_correct') bool? isCorrect,
  }) = _QuestionOption;

  factory QuestionOption.fromJson(Map<String, dynamic> json) =>
      _$QuestionOptionFromJson(json);
}

@freezed
class BankQuestion with _$BankQuestion {
  const factory BankQuestion({
    @JsonKey(name: '_id') String? id,
    @JsonKey(name: 'question_text') String? questionText,
    int? points,
    List<QuestionOption>? options,
  }) = _BankQuestion;

  factory BankQuestion.fromJson(Map<String, dynamic> json) =>
      _$BankQuestionFromJson(json);
}

@freezed
class TestQuestionItem with _$TestQuestionItem {
  const factory TestQuestionItem({
    @JsonKey(name: 'mapping_id') String? mappingId,
    @JsonKey(name: 'test_id') String? testId,
    @JsonKey(name: 'order_in_test') int? orderInTest,
    @JsonKey(name: 'bank_question_id') String? bankQuestionId,
    BankQuestion? question,
  }) = _TestQuestionItem;

  factory TestQuestionItem.fromJson(Map<String, dynamic> json) =>
      _$TestQuestionItemFromJson(json);
}

@freezed
class TestQuestionsResponse with _$TestQuestionsResponse {
  const factory TestQuestionsResponse({
    int? total,
    List<TestQuestionItem>? items,
  }) = _TestQuestionsResponse;

  factory TestQuestionsResponse.fromJson(Map<String, dynamic> json) =>
      _$TestQuestionsResponseFromJson(json);
}

@freezed
class StartTestResponse with _$StartTestResponse {
  const factory StartTestResponse({
    // Thêm field attempt
    AttemptModel? attempt,
    // Giữ lại field cũ để tương thích
    @JsonKey(name: 'attempt_id') String? attemptId,
  }) = _StartTestResponse;

  factory StartTestResponse.fromJson(Map<String, dynamic> json) =>
      _$StartTestResponseFromJson(json);
}

// Thêm model Attempt
@freezed
class AttemptModel with _$AttemptModel {
  const factory AttemptModel({
    @JsonKey(name: '_id') String? id,
    @JsonKey(name: 'user_id') String? userId,
    @JsonKey(name: 'test_id') String? testId,
    int? score,
    @JsonKey(name: 'correct_count') int? correctCount,
    @JsonKey(name: 'wrong_count') int? wrongCount,
    String? status,
  }) = _AttemptModel;

  factory AttemptModel.fromJson(Map<String, dynamic> json) =>
      _$AttemptModelFromJson(json);
}

@freezed
class UserAnswer with _$UserAnswer {
  const factory UserAnswer({
    @JsonKey(name: 'bank_question_id') required String bankQuestionId,
    @JsonKey(name: 'chosen_option_label') required String chosenOptionLabel,
  }) = _UserAnswer;

  factory UserAnswer.fromJson(Map<String, dynamic> json) =>
      _$UserAnswerFromJson(json);
}

@freezed
class SubmitAnswersRequest with _$SubmitAnswersRequest {
  const factory SubmitAnswersRequest({
    @JsonKey(name: 'attempt_id') required String attemptId,
    required List<UserAnswer> answers,
  }) = _SubmitAnswersRequest;

  factory SubmitAnswersRequest.fromJson(Map<String, dynamic> json) =>
      _$SubmitAnswersRequestFromJson(json);
}

@freezed
class AnswerMultiResponse with _$AnswerMultiResponse {
  const factory AnswerMultiResponse({
    @JsonKey(name: 'attempt_id') String? attemptId,
    @JsonKey(name: 'saved_count') int? savedCount,
    List<UserAnswerResult>? answers,
  }) = _AnswerMultiResponse;

  factory AnswerMultiResponse.fromJson(Map<String, dynamic> json) =>
      _$AnswerMultiResponseFromJson(json);
}

@freezed
class UserAnswerResult with _$UserAnswerResult {
  const factory UserAnswerResult({
    @JsonKey(name: '_id') String? id,
    @JsonKey(name: 'bank_question_id') String? bankQuestionId,
    @JsonKey(name: 'chosen_option_label') String? chosenOptionLabel,
    @JsonKey(name: 'is_correct') bool? isCorrect,
    int? score,
  }) = _UserAnswerResult;

  factory UserAnswerResult.fromJson(Map<String, dynamic> json) =>
      _$UserAnswerResultFromJson(json);
}

@freezed
class SubmitTestResponse with _$SubmitTestResponse {
  const factory SubmitTestResponse({
    @JsonKey(name: 'attempt_id') String? attemptId,
    int? correct,
    int? wrong,
    @JsonKey(name: 'total_questions') int? totalQuestions,
    int? score,
  }) = _SubmitTestResponse;

  factory SubmitTestResponse.fromJson(Map<String, dynamic> json) =>
      _$SubmitTestResponseFromJson(json);
}

