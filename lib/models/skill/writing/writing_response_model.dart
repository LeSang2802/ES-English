import 'package:freezed_annotation/freezed_annotation.dart';
import 'content_item_writing_model.dart';
import 'writing_question_model.dart';

part 'writing_response_model.freezed.dart';
part 'writing_response_model.g.dart';

@freezed
class WritingResponseModel with _$WritingResponseModel {
  const factory WritingResponseModel({
    ContentItemWriting? item,
    @Default(0) int total_questions,
    @Default([]) List<WritingQuestionModel> questions,
  }) = _WritingResponseModel;

  factory WritingResponseModel.fromJson(Map<String, dynamic> json) =>
      _$WritingResponseModelFromJson(json);
}
