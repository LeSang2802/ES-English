// pages/reading/reading_controller.dart
import 'package:get/get.dart';

import '../../cores/utils/dummy_util.dart';
import '../../models/reading/reading.dart';

class ReadingController extends GetxController {
  var passages = <Passage>[].obs;
  var currentPassageIndex = 0.obs;
  var selectedAnswers = <int, int>{}.obs;  // {questionIndex: selectedOptionIndex}
  var score = 0.obs;
  var isQuizCompleted = false.obs;
  var showResults = false.obs;

  @override
  void onInit() {
    super.onInit();
    passages.value = DummyUtil.passages;
    resetQuiz();
  }

  void nextPassage() {
    if (currentPassageIndex.value < passages.length - 1) {
      currentPassageIndex.value++;
      resetQuiz();
    }
  }

  void prevPassage() {
    if (currentPassageIndex.value > 0) {
      currentPassageIndex.value--;
      resetQuiz();
    }
  }

  void selectAnswer(int questionIndex, int optionIndex) {
    selectedAnswers[questionIndex] = optionIndex;
  }

  void submitQuiz() {
    int tempScore = 0;
    final currentPassage = passages[currentPassageIndex.value];
    for (int i = 0; i < currentPassage.questions.length; i++) {
      if (selectedAnswers[i] == currentPassage.questions[i].correctOptionIndex) {
        tempScore++;
      }
    }
    score.value = tempScore;
    isQuizCompleted.value = true;
    showResults.value = true;
  }

  void resetQuiz() {
    selectedAnswers.clear();
    score.value = 0;
    isQuizCompleted.value = false;
    showResults.value = false;
  }

// Sau này: void fetchPassagesFromAPI() { ... } // Gọi API và update passages
}