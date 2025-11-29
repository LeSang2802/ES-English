import 'package:freezed_annotation/freezed_annotation.dart';

part 'writing_submit_request_model.freezed.dart';
part 'writing_submit_request_model.g.dart';

@freezed
class WritingSubmitRequest with _$WritingSubmitRequest {
  const factory WritingSubmitRequest({
    required String topic_id,
    required String content_item_id,
    required double score,
    double? band_score,
    String? feedback,
  }) = _WritingSubmitRequest;

  factory WritingSubmitRequest.fromJson(Map<String, dynamic> json) =>
      _$WritingSubmitRequestFromJson(json);
}