import 'package:freezed_annotation/freezed_annotation.dart';
part 'level_response_model.freezed.dart';
part 'level_response_model.g.dart';

@freezed
class LevelResponseModel with _$LevelResponseModel {
  const factory LevelResponseModel({
    @JsonKey(name: '_id') String? id,
    String? code,
    String? name,
    @JsonKey(name: 'sort_order') int? sortOrder,
  }) = _LevelResponseModel;

  factory LevelResponseModel.fromJson(Map<String, dynamic> json) =>
      _$LevelResponseModelFromJson(json);
}
