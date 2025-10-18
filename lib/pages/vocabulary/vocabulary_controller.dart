import 'package:get/get.dart';
import '../../../cores/utils/dummy_util.dart';
import '../../../models/vocabulary/vocabulary_model.dart';

class VocabularyController extends GetxController {
  final vocabularies = <Vocabulary>[].obs;
  final isLoading = false.obs;
  final selectedId = RxnString();

  @override
  void onInit() {
    super.onInit();
    loadVocabularies();
  }

  void loadVocabularies() {
    isLoading.value = true;
    Future.delayed(const Duration(milliseconds: 300), () {
      vocabularies.value = DummyUtil.vocabulariesList;
      isLoading.value = false;
    });
  }

  // void select(Vocabulary item) {
  //   selectedId.value = item.id;
  // }
  void select(Vocabulary item) {
    selectedId.value = item.id;
    Get.toNamed('/flashCard');
  }


  void goToSavedWords() {
    Get.toNamed('/savedWord');
  }
}
