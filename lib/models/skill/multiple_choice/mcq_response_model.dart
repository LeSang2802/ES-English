import 'package:freezed_annotation/freezed_annotation.dart';
import 'content_item_model.dart';
import 'question_model.dart';

part 'mcq_response_model.freezed.dart';
part 'mcq_response_model.g.dart';

@freezed
class McqResponseModel with _$McqResponseModel {
  const factory McqResponseModel({
    ContentItem? item,
    @Default(0) int total_questions,
    @Default([]) List<QuestionModel> questions,
  }) = _McqResponseModel;

  factory McqResponseModel.fromJson(Map<String, dynamic> json) =>
      _$McqResponseModelFromJson(json);
}
