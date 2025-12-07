import 'package:freezed_annotation/freezed_annotation.dart';

part 'attempt_request.freezed.dart';
part 'attempt_request.g.dart';

@freezed
class StartAttemptRequest with _$StartAttemptRequest {
  const factory StartAttemptRequest({
    required String skill_id,
    required String level_id,
    required String topic_id,
    required String content_item_id,
    @Default("CONTENT") String attempt_scope,
  }) = _StartAttemptRequest;

  factory StartAttemptRequest.fromJson(Map<String, dynamic> json) =>
      _$StartAttemptRequestFromJson(json);
}

@freezed
class AnswerQuestionRequest with _$AnswerQuestionRequest {
  const factory AnswerQuestionRequest({
    required String attempt_id,
    required String question_id,
    required String chosen_option_id,
    String? answer_text, // Nullable cho trường hợp fill-in-blank
  }) = _AnswerQuestionRequest;

  factory AnswerQuestionRequest.fromJson(Map<String, dynamic> json) =>
      _$AnswerQuestionRequestFromJson(json);
}

@freezed
class SubmitAttemptRequest with _$SubmitAttemptRequest {
  const factory SubmitAttemptRequest({
    required String attempt_id,
  }) = _SubmitAttemptRequest;

  factory SubmitAttemptRequest.fromJson(Map<String, dynamic> json) =>
      _$SubmitAttemptRequestFromJson(json);
}