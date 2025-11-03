// import 'package:get/get.dart';
// import '../../../../models/skill/multiple_choice/mcq_response_model.dart';
// import 'mcq_repository.dart';
//
// /// Base controller dùng chung cho mọi kỹ năng MCQ (Reading, Listening,…)
// abstract class McqController extends GetxController {
//   // Repository chung cho attempt
//   final McqRepository attemptRepo = McqRepository();
//
//   // Subclass tự override repo lấy content riêng (readingRepo, listeningRepo,…)
//   late final dynamic contentRepo;
//
//   var isLoading = false.obs;
//   var isSubmitted = false.obs;
//
//   var currentQuestionIndex = 0.obs;
//   var currentContentIndex = 0.obs;
//
//   var selectedOptions = <String, String>{}.obs;
//   var questionResults = <String, bool>{}.obs;
//
//   var contentList = <String>[].obs;
//   var attemptList = <String>[].obs;
//
//   Rxn<McqResponseModel> currentData = Rxn<McqResponseModel>();
//   String? attemptId;
//   String? contentId;
//
//   late String skillId;
//   late String levelId;
//   late String topicId;
//
//   String get contentType; // Ví dụ: "READING_PASSAGE", "LISTENING_AUDIO"
//
//   // === ABSTRACT METHODS ===
//   Future<McqResponseModel> fetchDetail(String contentId);
//   Future<List<String>> fetchAllContentIds(String topicId);
//
//   @override
//   void onInit() {
//     final args = Get.arguments;
//     skillId = args['skill_id'];
//     levelId = args['level_id'];
//     topicId = args['topic_id'];
//     super.onInit();
//     initData();
//   }
//
//   // === LOAD TOÀN BỘ DỮ LIỆU ===
//   Future<void> initData() async {
//     isLoading.value = true;
//     try {
//       final all = await fetchAllContentIds(topicId);
//       if (all.isEmpty) {
//         Get.snackbar("Không có bài học", "Topic này chưa có nội dung nào.");
//         return;
//       }
//       contentList.value = all;
//       await loadContentAtIndex(0);
//     } catch (e) {
//       print("❌ initData error: $e");
//       Get.snackbar("Lỗi", "Không tải được dữ liệu.");
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   // === LOAD 1 BÀI HỌC ===
//   Future<void> loadContentAtIndex(int index) async {
//     if (index < 0 || index >= contentList.length) return;
//     isLoading.value = true;
//     try {
//       currentContentIndex.value = index;
//       contentId = contentList[index];
//
//       currentData.value = await fetchDetail(contentId!);
//       currentQuestionIndex.value = 0;
//       selectedOptions.clear();
//       questionResults.clear();
//
//       attemptId = await attemptRepo.startAttempt({
//         "skill_id": skillId,
//         "level_id": levelId,
//         "topic_id": topicId,
//         "content_item_id": contentId,
//         "attempt_scope": "CONTENT",
//       });
//
//       if (attemptId != null) attemptList.add(attemptId!);
//       print("✅ Loaded content $index: $contentId");
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   // === ĐIỀU HƯỚNG CÂU HỎI ===
//   Future<void> nextQuestion() async {
//     final totalQ = currentData.value?.questions.length ?? 0;
//     if (currentQuestionIndex.value < totalQ - 1) {
//       currentQuestionIndex.value++;
//     } else {
//       final next = currentContentIndex.value + 1;
//       if (next < contentList.length) {
//         await loadContentAtIndex(next);
//       } else {
//         Get.snackbar("Hoàn thành", "Bạn đã làm hết tất cả bài!");
//       }
//     }
//   }
//
//   void prevQuestion() {
//     if (currentQuestionIndex.value > 0) {
//       currentQuestionIndex.value--;
//     } else if (currentContentIndex.value > 0) {
//       loadContentAtIndex(currentContentIndex.value - 1);
//     }
//   }
//
//   // === GỬI ĐÁP ÁN ===
//   Future<void> onSelectOption(String questionId, String chosenOptionId) async {
//     if (selectedOptions.containsKey(questionId)) return;
//     selectedOptions[questionId] = chosenOptionId;
//     selectedOptions.refresh();
//
//     if (attemptId == null) return;
//     final result = await attemptRepo.answerQuestion(
//       attemptId: attemptId!,
//       questionId: questionId,
//       chosenOptionId: chosenOptionId,
//     );
//     questionResults[questionId] = result['is_correct'] ?? false;
//     questionResults.refresh();
//   }
//
//   String? getCorrectOptionId(String questionId) {
//     final q = currentData.value?.questions
//         .firstWhereOrNull((x) => x.id == questionId);
//     return q?.options.firstWhereOrNull((o) => o.is_correct == true)?.id;
//   }
//
//   // === TÍNH TIẾN ĐỘ ===
//   double get totalProgress {
//     if (contentList.isEmpty) return 0;
//     return (currentContentIndex.value + 1) / contentList.length;
//   }
//
//   // === NỘP TẤT CẢ BÀI ===
//   Future<void> submitAll() async {
//     if (attemptList.isEmpty) {
//       Get.snackbar("Chưa có dữ liệu", "Bạn chưa hoàn thành bài nào.");
//       return;
//     }
//
//     isSubmitted.value = true;
//     isLoading.value = true;
//     try {
//       int totalCorrect = 0;
//       int totalScore = 0;
//
//       for (final att in attemptList) {
//         final res = await attemptRepo.submitAttempt(att);
//         final data = (res is Map && res['data'] is Map) ? res['data'] : res;
//         totalCorrect += (data['correctCount'] ?? 0) as int;
//         totalScore += (data['totalScore'] ?? 0) as int;
//       }
//
//       Get.snackbar(
//         "Kết quả tổng hợp",
//         "🎯 Đúng $totalCorrect câu – Tổng điểm $totalScore/${contentList.length}",
//         snackPosition: SnackPosition.BOTTOM,
//         duration: const Duration(seconds: 6),
//       );
//     } catch (e) {
//       print("❌ submitAll error: $e");
//       Get.snackbar("Lỗi", "Không thể nộp bài. Vui lòng thử lại.");
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }

import 'package:get/get.dart';
import '../../../../models/skill/multiple_choice/mcq_response_model.dart';
import 'mcq_repository.dart';

/// Base controller dùng chung cho mọi kỹ năng MCQ (Reading, Listening,…)
abstract class McqController extends GetxController {
  final McqRepository attemptRepo = McqRepository();

  late final dynamic contentRepo;

  var isLoading = false.obs;
  var isSubmitted = false.obs;

  var currentQuestionIndex = 0.obs;
  var currentContentIndex = 0.obs;

  var selectedOptions = <String, String>{}.obs;
  var questionResults = <String, bool>{}.obs;

  var contentList = <String>[].obs;
  var attemptList = <String>[].obs;

  Rxn<McqResponseModel> currentData = Rxn<McqResponseModel>();
  String? attemptId;
  String? contentId;

  late String skillId;
  late String levelId;
  late String topicId;

  // ✅ Thêm: dùng để lưu toàn bộ kết quả các câu đã làm
  final Map<String, Map<String, dynamic>> _resultsForSummary = {};

  String get contentType;

  Future<McqResponseModel> fetchDetail(String contentId);
  Future<List<String>> fetchAllContentIds(String topicId);

  @override
  void onInit() {
    final args = Get.arguments;
    skillId = args['skill_id'];
    levelId = args['level_id'];
    topicId = args['topic_id'];
    super.onInit();
    initData();
  }

  // === LOAD TOÀN BỘ DỮ LIỆU ===
  Future<void> initData() async {
    isLoading.value = true;
    try {
      final all = await fetchAllContentIds(topicId);
      if (all.isEmpty) {
        Get.snackbar("Không có bài học", "Topic này chưa có nội dung nào.");
        return;
      }
      contentList.value = all;
      await loadContentAtIndex(0);
    } catch (e) {
      print("❌ initData error: $e");
      Get.snackbar("Lỗi", "Không tải được dữ liệu.");
    } finally {
      isLoading.value = false;
    }
  }

  // === LOAD 1 BÀI HỌC ===
  Future<void> loadContentAtIndex(int index) async {
    if (index < 0 || index >= contentList.length) return;
    isLoading.value = true;
    try {
      currentContentIndex.value = index;
      contentId = contentList[index];

      currentData.value = await fetchDetail(contentId!);
      currentQuestionIndex.value = 0;
      selectedOptions.clear();
      questionResults.clear();

      attemptId = await attemptRepo.startAttempt({
        "skill_id": skillId,
        "level_id": levelId,
        "topic_id": topicId,
        "content_item_id": contentId,
        "attempt_scope": "CONTENT",
      });

      if (attemptId != null) attemptList.add(attemptId!);
      print("✅ Loaded content $index: $contentId");
    } finally {
      isLoading.value = false;
    }
  }

  // === ĐIỀU HƯỚNG CÂU HỎI ===
  Future<void> nextQuestion() async {
    final totalQ = currentData.value?.questions.length ?? 0;
    if (currentQuestionIndex.value < totalQ - 1) {
      currentQuestionIndex.value++;
    } else {
      final next = currentContentIndex.value + 1;
      if (next < contentList.length) {
        await loadContentAtIndex(next);
      } else {
        // ✅ Tự động chuyển sang kết quả nếu đã hết bài
        await submitAll();
      }
    }
  }

  void prevQuestion() {
    if (currentQuestionIndex.value > 0) {
      currentQuestionIndex.value--;
    } else if (currentContentIndex.value > 0) {
      loadContentAtIndex(currentContentIndex.value - 1);
    }
  }

  // === GỬI ĐÁP ÁN ===
  Future<void> onSelectOption(String questionId, String chosenOptionId) async {
    if (selectedOptions.containsKey(questionId)) return;
    selectedOptions[questionId] = chosenOptionId;
    selectedOptions.refresh();

    if (attemptId == null) return;
    final result = await attemptRepo.answerQuestion(
      attemptId: attemptId!,
      questionId: questionId,
      chosenOptionId: chosenOptionId,
    );

    final isCorrect = result['is_correct'] ?? false;
    questionResults[questionId] = isCorrect;
    questionResults.refresh();

    // ✅ Ghi lại kết quả từng câu để hiển thị ở màn kết quả
    final q = currentData.value?.questions.firstWhereOrNull((x) => x.id == questionId);
    final chosenOpt = q?.options.firstWhereOrNull((o) => o.id == chosenOptionId);
    final correctOpt = q?.options.firstWhereOrNull((o) => o.is_correct == true);

    _resultsForSummary[questionId] = {
      "chosen": chosenOpt?.label ?? '',
      "correct": correctOpt?.label ?? '',
      "is_correct": isCorrect,
    };
  }

  String? getCorrectOptionId(String questionId) {
    final q = currentData.value?.questions
        .firstWhereOrNull((x) => x.id == questionId);
    return q?.options.firstWhereOrNull((o) => o.is_correct == true)?.id;
  }

  // === TÍNH TIẾN ĐỘ ===
  double get totalProgress {
    if (contentList.isEmpty) return 0;
    return (currentContentIndex.value + 1) / contentList.length;
  }

  // === NỘP TẤT CẢ BÀI ===
  Future<void> submitAll() async {
    if (_resultsForSummary.isEmpty) {
      Get.snackbar("Chưa có dữ liệu", "Bạn chưa hoàn thành bài nào.");
      return;
    }

    isSubmitted.value = true;
    isLoading.value = true;
    try {
      int totalCorrect =
          _resultsForSummary.values.where((e) => e['is_correct'] == true).length;
      int totalQuestions = _resultsForSummary.length;

      // ✅ Gửi dữ liệu sang màn kết quả
      final resultList = _resultsForSummary.entries.map((e) {
        final data = e.value;
        return {
          "chosen": data["chosen"],
          "correct": data["correct"],
          "is_correct": data["is_correct"],
        };
      }).toList();

      Get.toNamed('/mcqResult', arguments: {
        "totalCorrect": totalCorrect,
        "totalQuestions": totalQuestions,
        "resultList": resultList,
      });
    } catch (e) {
      print("❌ submitAll error: $e");
      Get.snackbar("Lỗi", "Không thể nộp bài. Vui lòng thử lại.");
    } finally {
      isLoading.value = false;
    }
  }
}
