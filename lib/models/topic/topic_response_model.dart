import 'package:freezed_annotation/freezed_annotation.dart';
part 'topic_response_model.freezed.dart';
part 'topic_response_model.g.dart';

@freezed
class TopicResponseModel with _$TopicResponseModel {
  const factory TopicResponseModel({
    @JsonKey(name: '_id') String? id,
    String? skill_id,
    String? level_id,
    String? title,
    String? description,
    String? created_at,
    String? updated_at,
  }) = _TopicResponseModel;

  factory TopicResponseModel.fromJson(Map<String, dynamic> json) =>
      _$TopicResponseModelFromJson(json);
}
