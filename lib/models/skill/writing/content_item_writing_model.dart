import 'package:freezed_annotation/freezed_annotation.dart';

part 'content_item_writing_model.freezed.dart';
part 'content_item_writing_model.g.dart';

@freezed
class ContentItemWriting with _$ContentItemWriting {
  const factory ContentItemWriting({
    @JsonKey(name: '_id') String? id,
    String? topic_id,
    String? type,
    String? title,
    String? body_text,
    String? media_image_url,
    bool? is_published,
    String? question_text,
  }) = _ContentItemWriting;

  factory ContentItemWriting.fromJson(Map<String, dynamic> json) =>
      _$ContentItemWritingFromJson(json);
}
