import 'package:freezed_annotation/freezed_annotation.dart';

part 'writing_question_model.freezed.dart';
part 'writing_question_model.g.dart';

@freezed
class WritingQuestionModel with _$WritingQuestionModel {
  const factory WritingQuestionModel({
    @JsonKey(name: '_id') String? id,
    String? question_text,  // Câu hỏi, ví dụ: "Fill in the blank: ______"
    int? order_in_item,  // Vị trí câu hỏi trong bài (nếu có nhiều câu hỏi)
  }) = _WritingQuestionModel;

  factory WritingQuestionModel.fromJson(Map<String, dynamic> json) =>
      _$WritingQuestionModelFromJson(json);
}
