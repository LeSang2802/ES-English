import 'package:freezed_annotation/freezed_annotation.dart';
part 'content_item_model.freezed.dart';
part 'content_item_model.g.dart';

@freezed
class ContentItem with _$ContentItem {
  const factory ContentItem({
    @JsonKey(name: '_id') String? id,
    String? topic_id,
    String? type,
    String? title,
    String? body_text,
    String? media_audio_url,
    String? media_image_url,
    bool? is_published,
  }) = _ContentItem;

  factory ContentItem.fromJson(Map<String, dynamic> json) =>
      _$ContentItemFromJson(json);
}
