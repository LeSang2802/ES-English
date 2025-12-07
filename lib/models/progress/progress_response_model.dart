// import 'package:freezed_annotation/freezed_annotation.dart';
//
// part 'progress_response_model.freezed.dart';
// part 'progress_response_model.g.dart';
//
// @freezed
// class ProgressResponseModel with _$ProgressResponseModel {
//   const factory ProgressResponseModel({
//     @JsonKey(name: 'total_user_attempts') int? totalUserAttempts,
//     @JsonKey(name: 'total_user_score') int? totalUserScore,
//     List<ProgressItem>? progress,
//     @JsonKey(name: 'skills_summary') List<SkillSummary>? skillsSummary,
//     @JsonKey(name: 'study_time') StudyTime? studyTime,
//     @JsonKey(name: 'mock_tests') List<MockTest>? mockTests,
//   }) = _ProgressResponseModel;
//
//   factory ProgressResponseModel.fromJson(Map<String, dynamic> json) =>
//       _$ProgressResponseModelFromJson(json);
// }
//
// @freezed
// class ProgressItem with _$ProgressItem {
//   const factory ProgressItem({
//     @JsonKey(name: 'skill_code') String? skillCode,
//     @JsonKey(name: 'skill_name') String? skillName,
//     String? level,
//     @JsonKey(name: 'topic_title') String? topicTitle,
//     @JsonKey(name: 'topic_description') String? topicDescription,
//     @JsonKey(name: 'correct_count') int? correctCount,
//     @JsonKey(name: 'total_lessons') int? totalLessons,
//     @JsonKey(name: 'total_questions') int? totalQuestions,
//     @JsonKey(name: 'progress_percent') int? progressPercent,
//     @JsonKey(name: 'last_activity_at') String? lastActivityAt,
//   }) = _ProgressItem;
//
//   factory ProgressItem.fromJson(Map<String, dynamic> json) =>
//       _$ProgressItemFromJson(json);
// }
//
// @freezed
// class SkillSummary with _$SkillSummary {
//   const factory SkillSummary({
//     String? skill,
//     @JsonKey(name: 'total_score') int? totalScore,
//     @JsonKey(name: 'total_attempts') int? totalAttempts,
//     @JsonKey(name: 'progress_percent') int? progressPercent,
//   }) = _SkillSummary;
//
//   factory SkillSummary.fromJson(Map<String, dynamic> json) =>
//       _$SkillSummaryFromJson(json);
// }
//
// @freezed
// class StudyTime with _$StudyTime {
//   const factory StudyTime({
//     @JsonKey(name: 'total_7days') int? total7Days,
//     List<DailyStudy>? daily,
//   }) = _StudyTime;
//
//   factory StudyTime.fromJson(Map<String, dynamic> json) =>
//       _$StudyTimeFromJson(json);
// }
//
// @freezed
// class DailyStudy with _$DailyStudy {
//   const factory DailyStudy({
//     String? date,
//     int? duration,
//   }) = _DailyStudy;
//
//   factory DailyStudy.fromJson(Map<String, dynamic> json) =>
//       _$DailyStudyFromJson(json);
// }
//
// @freezed
// class MockTest with _$MockTest {
//   const factory MockTest({
//     @JsonKey(name: 'mock_test_id') String? mockTestId,
//     @JsonKey(name: 'test_title') String? testTitle,
//     @JsonKey(name: 'total_questions_test') int? totalQuestionsTest,
//     @JsonKey(name: 'test_correct') int? testCorrect,
//     @JsonKey(name: 'test_incorrect') int? testIncorrect,
//     @JsonKey(name: 'test_score') int? testScore,
//     @JsonKey(name: 'submitted_at') String? submittedAt,
//   }) = _MockTest;
//
//   factory MockTest.fromJson(Map<String, dynamic> json) =>
//       _$MockTestFromJson(json);
// }

import 'package:freezed_annotation/freezed_annotation.dart';

part 'progress_response_model.freezed.dart';
part 'progress_response_model.g.dart';

@freezed
class ProgressResponseModel with _$ProgressResponseModel {
  const factory ProgressResponseModel({
    @JsonKey(name: 'total_user_score') int? totalUserScore,
    @JsonKey(name: 'total_user_questions') int? totalUserQuestions,
    List<ProgressItem>? progress,
    @JsonKey(name: 'skills_summary') List<SkillSummary>? skillsSummary,
    @JsonKey(name: 'study_time') StudyTime? studyTime,
    @JsonKey(name: 'mock_tests') List<MockTest>? mockTests,
  }) = _ProgressResponseModel;

  factory ProgressResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ProgressResponseModelFromJson(json);
}

@freezed
class ProgressItem with _$ProgressItem {
  const factory ProgressItem({
    @JsonKey(name: 'skill_code') String? skillCode,
    @JsonKey(name: 'skill_name') String? skillName,
    String? level,
    @JsonKey(name: 'total_attempts') double? totalAttempts,
    int? point,
    @JsonKey(name: 'correct_count') int? correctCount,
    @JsonKey(name: 'total_questions_topic') int? totalQuestionsTopic,
    @JsonKey(name: 'progress_percent') int? progressPercent,
    @JsonKey(name: 'last_activity_at') String? lastActivityAt,
    @JsonKey(name: 'topic_details') TopicDetails? topicDetails,
  }) = _ProgressItem;

  factory ProgressItem.fromJson(Map<String, dynamic> json) =>
      _$ProgressItemFromJson(json);
}

@freezed
class TopicDetails with _$TopicDetails {
  const factory TopicDetails({
    @JsonKey(name: '_id') String? id,
    @JsonKey(name: 'skill_id') String? skillId,
    @JsonKey(name: 'level_id') String? levelId,
    String? title,
    String? description,
    String? type,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
  }) = _TopicDetails;

  factory TopicDetails.fromJson(Map<String, dynamic> json) =>
      _$TopicDetailsFromJson(json);
}

@freezed
class SkillSummary with _$SkillSummary {
  const factory SkillSummary({
    String? skill,
    @JsonKey(name: 'total_done') int? totalDone,
    @JsonKey(name: 'total_point') int? totalPoint,
    @JsonKey(name: 'total_not_done') int? totalNotDone,
    @JsonKey(name: 'total_questions_skill_all_topics') int? totalQuestionsSkillAllTopics,
    @JsonKey(name: 'avg_progress_percent') double? avgProgressPercent,
  }) = _SkillSummary;

  factory SkillSummary.fromJson(Map<String, dynamic> json) =>
      _$SkillSummaryFromJson(json);
}

@freezed
class StudyTime with _$StudyTime {
  const factory StudyTime({
    @JsonKey(name: 'total_7days') int? total7Days,
    List<DailyStudy>? daily,
  }) = _StudyTime;

  factory StudyTime.fromJson(Map<String, dynamic> json) =>
      _$StudyTimeFromJson(json);
}

@freezed
class DailyStudy with _$DailyStudy {
  const factory DailyStudy({
    String? date,
    int? duration,
  }) = _DailyStudy;

  factory DailyStudy.fromJson(Map<String, dynamic> json) =>
      _$DailyStudyFromJson(json);
}

@freezed
class MockTest with _$MockTest {
  const factory MockTest({
    @JsonKey(name: 'mock_test_id') String? mockTestId,
    @JsonKey(name: 'test_title') String? testTitle,
    @JsonKey(name: 'total_questions_test') int? totalQuestionsTest,
    @JsonKey(name: 'test_correct') int? testCorrect,
    @JsonKey(name: 'test_incorrect') int? testIncorrect,
    @JsonKey(name: 'test_score') int? testScore,
    @JsonKey(name: 'submitted_at') String? submittedAt,
  }) = _MockTest;

  factory MockTest.fromJson(Map<String, dynamic> json) =>
      _$MockTestFromJson(json);
}