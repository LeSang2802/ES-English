import 'package:freezed_annotation/freezed_annotation.dart';

part 'saved_word_model.freezed.dart';
part 'saved_word_model.g.dart';

@freezed
class SavedWordModel with _$SavedWordModel {
  const factory SavedWordModel({
    @JsonKey(name: '_id') String? id,
    String? word,
    String? phonetic,
    String? part_of_speech,
    String? meaning_vi,
    String? audio_url,
    String? image_url,
    @Default(true) bool isSaved,
  }) = _SavedWordModel;

  factory SavedWordModel.fromJson(Map<String, dynamic> json) =>
      _$SavedWordModelFromJson(json);
}
