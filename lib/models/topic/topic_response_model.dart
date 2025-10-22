import 'package:freezed_annotation/freezed_annotation.dart';

part 'topic_response_model.freezed.dart';
part 'topic_response_model.g.dart';

@freezed
class TopicResponseModel with _$TopicResponseModel {
  const factory TopicResponseModel({
    @JsonKey(name: '_id') String? id,
    SkillRef? skill_id, // <-- thay đổi
    LevelRef? level_id, // <-- thay đổi
    String? title,
    String? description,
    String? type,
    String? created_at,
    String? updated_at,
  }) = _TopicResponseModel;

  factory TopicResponseModel.fromJson(Map<String, dynamic> json) =>
      _$TopicResponseModelFromJson(json);
}

@freezed
class SkillRef with _$SkillRef {
  const factory SkillRef({
    @JsonKey(name: '_id') String? id,
    String? code,
    String? name,
  }) = _SkillRef;

  factory SkillRef.fromJson(Map<String, dynamic> json) =>
      _$SkillRefFromJson(json);
}

@freezed
class LevelRef with _$LevelRef {
  const factory LevelRef({
    @JsonKey(name: '_id') String? id,
    String? name,
    int? sort_order,
  }) = _LevelRef;

  factory LevelRef.fromJson(Map<String, dynamic> json) =>
      _$LevelRefFromJson(json);
}
