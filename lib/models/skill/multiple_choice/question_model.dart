import 'package:freezed_annotation/freezed_annotation.dart';
part 'question_model.freezed.dart';
part 'question_model.g.dart';

@freezed
class QuestionModel with _$QuestionModel {
  const factory QuestionModel({
    @JsonKey(name: '_id') String? id,
    String? question_type,
    String? question_text,
    int? order_in_item,
    @Default([]) List<QuestionOptionModel> options,
  }) = _QuestionModel;

  factory QuestionModel.fromJson(Map<String, dynamic> json) =>
      _$QuestionModelFromJson(json);
}

@freezed
class QuestionOptionModel with _$QuestionOptionModel {
  const factory QuestionOptionModel({
    @JsonKey(name: '_id') String? id,
    String? label,
    String? option_text,
    bool? is_correct,
  }) = _QuestionOptionModel;

  factory QuestionOptionModel.fromJson(Map<String, dynamic> json) =>
      _$QuestionOptionModelFromJson(json);
}
