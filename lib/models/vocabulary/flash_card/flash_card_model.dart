import 'package:freezed_annotation/freezed_annotation.dart';

part 'flash_card_model.freezed.dart';
part 'flash_card_model.g.dart';

@freezed
class FlashCardModel with _$FlashCardModel {
  const factory FlashCardModel({
    @JsonKey(name: '_id') String? id,
    String? topic_id,
    String? word,
    String? phonetic,
    String? part_of_speech,
    String? meaning_vi,
    String? example_en,
    String? example_vi,
    String? audio_url,
    String? image_url,
    @Default(false) bool isSaved,
  }) = _FlashCardModel;

  factory FlashCardModel.fromJson(Map<String, dynamic> json) =>
      _$FlashCardModelFromJson(json);
}
