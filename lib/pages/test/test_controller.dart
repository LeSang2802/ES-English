import 'dart:async';
import 'package:get/get.dart';
import 'package:es_english/models/test/test_response_model.dart';
import 'package:es_english/pages/test/test_repository.dart';

class TestController extends GetxController {
  final TestRepository repo = TestRepository();

  var tests = <TestResponseModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadTests();
  }

  Future<void> loadTests() async {
    isLoading.value = true;
    try {
      tests.value = await repo.getTests();
    } catch (e) {
      print('Error load tests: $e');
      Get.snackbar('Lỗi', 'Không thể tải danh sách bài thi');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshData() async {
    await loadTests();
  }

  void onSelectTest(TestResponseModel test) {
    Get.toNamed('/testDetail', arguments: {
      'test_id': test.id,
      'test_title': test.title,
      'duration_minutes': test.durationMinutes,
    });
  }
}