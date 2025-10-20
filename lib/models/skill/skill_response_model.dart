import 'package:freezed_annotation/freezed_annotation.dart';

part 'skill_response_model.freezed.dart';
part 'skill_response_model.g.dart';

@freezed
class SkillResponseModel with _$SkillResponseModel {
  const factory SkillResponseModel({
    @JsonKey(name: '_id') String? id,
    String? code,
    String? name,
  }) = _SkillResponseModel;

  factory SkillResponseModel.fromJson(Map<String, dynamic> json) =>
      _$SkillResponseModelFromJson(json);
}
