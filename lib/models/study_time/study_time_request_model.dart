import 'package:freezed_annotation/freezed_annotation.dart';

part 'study_time_request_model.freezed.dart';
part 'study_time_request_model.g.dart';

@freezed
class StudyTimeRequest with _$StudyTimeRequest {
  const factory StudyTimeRequest({
    required String date,
    required int duration,
  }) = _StudyTimeRequest;

  factory StudyTimeRequest.fromJson(Map<String, dynamic> json) =>
      _$StudyTimeRequestFromJson(json);
}