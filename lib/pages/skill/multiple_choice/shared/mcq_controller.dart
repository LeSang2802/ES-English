import 'package:get/get.dart';
import '../../../../models/skill/multiple_choice/attempt_request.dart';
import '../../../../models/skill/multiple_choice/mcq_response_model.dart';
import 'mcq_repository.dart';

abstract class McqController extends GetxController {
  final McqRepository attemptRepo = McqRepository();

  late final dynamic contentRepo;

  var isLoading = false.obs;
  var isSubmitted = false.obs;

  var currentQuestionIndex = 0.obs;
  var currentContentIndex = 0.obs;

  var selectedOptions = <String, String>{}.obs;
  var questionResults = <String, bool>{}.obs;
  var checkedQuestions = <String, bool>{}.obs;

  var contentList = <String>[].obs;

  Rxn<McqResponseModel> currentData = Rxn<McqResponseModel>();

  String? attemptId;
  String? contentId;

  late String skillId;
  late String levelId;
  late String topicId;

  // ✅ LƯU TOÀN BỘ KẾT QUẢ CỦA TẤT CẢ CÁC BÀI (KHÔNG XÓA KHI CHUYỂN BÀI)
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

  Future<void> initData() async {
    isLoading.value = true;
    try {
      final all = await fetchAllContentIds(topicId);
      if (all.isEmpty) {
        Get.snackbar("No Data", "Topic này chưa có bài học.");
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

  /// Load bài + tạo attempt mới
  Future<void> loadContentAtIndex(int index) async {
    if (index < 0 || index >= contentList.length) return;

    isLoading.value = true;

    try {
      currentContentIndex.value = index;
      contentId = contentList[index];

      // Load chi tiết
      currentData.value = await fetchDetail(contentId!);

      // ✅ Reset UI cho bài mới (KHÔNG reset _resultsForSummary)
      currentQuestionIndex.value = 0;
      selectedOptions.clear();
      questionResults.clear();
      checkedQuestions.clear();

      // ✅ Tạo attempt cho bài này
      final request = StartAttemptRequest(
        skill_id: skillId,
        level_id: levelId,
        topic_id: topicId,
        content_item_id: contentId!,
        attempt_scope: "CONTENT",
      );

      attemptId = await attemptRepo.startAttempt(request);

      print("✅ Created attempt: $attemptId");
      print("   - Content: $contentId (${index + 1}/${contentList.length})");

    } catch (e) {
      print("❌ loadContentAtIndex error: $e");
      Get.snackbar("Lỗi", "Không tải được bài học.");
    } finally {
      isLoading.value = false;
    }
  }

  void onSelectOption(String questionId, String optionId) {
    selectedOptions[questionId] = optionId;
    selectedOptions.refresh();
  }

  /// Gửi đáp án
  Future<void> checkAnswer(String questionId) async {
    final chosenOptionId = selectedOptions[questionId];

    if (attemptId == null) {
      print("❌ attemptId is null!");
      Get.snackbar("Lỗi", "Không có attempt để gửi đáp án.");
      return;
    }

    if (chosenOptionId == null) {
      print("❌ No option selected");
      return;
    }

    print("""
📤 Sending answer:
   attempt_id: $attemptId
   question_id: $questionId
   chosen_option_id: $chosenOptionId
""");

    final request = AnswerQuestionRequest(
      attempt_id: attemptId!,
      question_id: questionId,
      chosen_option_id: chosenOptionId,
    );

    try {
      final result = await attemptRepo.answerQuestion(request);

      print("📥 Response: $result");

      final isCorrect = result['is_correct'] ?? false;
      questionResults[questionId] = isCorrect;
      checkedQuestions[questionId] = true;

      questionResults.refresh();
      checkedQuestions.refresh();

      // ✅ LƯU KẾT QUẢ VÀO _resultsForSummary (KHÔNG XÓA)
      final q = currentData.value?.questions
          .firstWhereOrNull((x) => x.id == questionId);

      final chosenOpt = q?.options.firstWhereOrNull((o) => o.id == chosenOptionId);
      final correctOpt = q?.options.firstWhereOrNull((o) => o.is_correct == true);

      _resultsForSummary[questionId] = {
        "chosen": chosenOpt?.label ?? '',
        "correct": correctOpt?.label ?? '',
        "is_correct": isCorrect,
      };

      print("💾 Saved result for $questionId. Total results: ${_resultsForSummary.length}");

    } catch (e) {
      print("❌ checkAnswer error: $e");
      Get.snackbar("Lỗi", "Không gửi được đáp án: ${e.toString()}");
    }
  }

  /// Chuyển câu hoặc bài
  Future<void> nextQuestion() async {
    final total = currentData.value?.questions.length ?? 0;

    if (currentQuestionIndex.value < total - 1) {
      currentQuestionIndex.value++;
      return;
    }

    // ✅ Hết câu → submit bài hiện tại trước khi chuyển
    if (attemptId != null) {
      await _submitCurrentContent();
    }

    // Chuyển sang bài mới
    final next = currentContentIndex.value + 1;
    if (next < contentList.length) {
      await loadContentAtIndex(next);
    }
  }

  /// Submit bài hiện tại (nội bộ, không show UI)
  Future<void> _submitCurrentContent() async {
    if (attemptId == null) return;

    try {
      print("📤 Auto-submitting attempt: $attemptId");

      final request = SubmitAttemptRequest(attempt_id: attemptId!);
      await attemptRepo.submitAttempt(request);

      print("✅ Auto-submit successful");
      print("📊 Total results saved so far: ${_resultsForSummary.length}");

      // ❌ KHÔNG XÓA _resultsForSummary ở đây!

    } catch (e) {
      print("❌ Auto-submit error: $e");
    }
  }

  /// Submit bài cuối cùng và chuyển đến màn kết quả
  Future<void> submitCurrentAttempt() async {
    if (attemptId == null) {
      Get.snackbar("Lỗi", "Không có attempt để nộp.");
      return;
    }

    isLoading.value = true;

    try {
      print("📤 Final submit: $attemptId");

      final request = SubmitAttemptRequest(attempt_id: attemptId!);
      final result = await attemptRepo.submitAttempt(request);

      print("✅ Final submit result: $result");

      // ✅ TÍNH TỔNG KẾT QUẢ TỪ TẤT CẢ CÁC BÀI
      final totalCorrect = _resultsForSummary.values
          .where((e) => e['is_correct'] == true)
          .length;

      final resultList = _resultsForSummary.entries.map((e) {
        return {
          "chosen": e.value["chosen"],
          "correct": e.value["correct"],
          "is_correct": e.value["is_correct"],
        };
      }).toList();

      print("📊 Final results:");
      print("   Total questions: ${_resultsForSummary.length}");
      print("   Correct: $totalCorrect");

      // Chuyển màn kết quả
      Get.toNamed('/mcqResult', arguments: {
        "totalCorrect": totalCorrect,
        "totalQuestions": _resultsForSummary.length,
        "resultList": resultList,
        "attemptId": attemptId,
      });

      // ✅ CHỈ XÓA SAU KHI ĐÃ CHUYỂN SANG MÀN KẾT QUẢ
      _resultsForSummary.clear();

    } catch (e) {
      print("❌ Submit error: $e");
      Get.snackbar("Lỗi", "Không thể nộp bài: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  String? getCorrectOptionId(String questionId) {
    final q = currentData.value?.questions
        .firstWhereOrNull((x) => x.id == questionId);
    return q?.options.firstWhereOrNull((o) => o.is_correct == true)?.id;
  }

  double get totalProgress {
    if (contentList.isEmpty) return 0;
    return (currentContentIndex.value + 1) / contentList.length;
  }
}
