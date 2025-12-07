import 'package:freezed_annotation/freezed_annotation.dart';

part 'content_item_speaking_model.freezed.dart';
part 'content_item_speaking_model.g.dart';

@freezed
class ContentItemSpeaking with _$ContentItemSpeaking {
  const factory ContentItemSpeaking({
    @JsonKey(name: '_id') String? id,
    String? topic_id,
    String? type,
    String? title,
    String? body_text,
    String? media_audio_url,
    String? media_image_url,
    bool? is_published,
    @Default([]) List<SpeakingQuestion> questions,
  }) = _ContentItemSpeaking;

  factory ContentItemSpeaking.fromJson(Map<String, dynamic> json) =>
      _$ContentItemSpeakingFromJson(json);
}

@freezed
class SpeakingQuestion with _$SpeakingQuestion {
  const factory SpeakingQuestion({
    @JsonKey(name: '_id') String? id,
    String? question_type,
    String? question_text,
    int? order_in_item,
    @Default([]) List<String> options,
  }) = _SpeakingQuestion;

  factory SpeakingQuestion.fromJson(Map<String, dynamic> json) =>
      _$SpeakingQuestionFromJson(json);
}