import 'package:get/get.dart';
import 'package:es_english/models/level/level_response_model.dart';
import 'package:es_english/pages/level/level_repository.dart';
import 'package:es_english/models/skill/skill_response_model.dart';

class LevelController extends GetxController {
  final LevelRepository repo = LevelRepository();

  var levels = <LevelResponseModel>[].obs;
  var isLoading = false.obs;

  late final String skillId;
  late final String skillName;


  @override
  void onInit() {
    final arg = Get.arguments;
    skillId = arg?.id ?? arg['skill_id'] ?? '';
    skillName = arg?.name ?? arg['skill_name'] ?? '';
    super.onInit();
    loadLevels();
  }

  Future<void> loadLevels() async {
    isLoading.value = true;
    try {
      levels.value = await repo.getLevels(); // backend đã sort theo sort_order
    } catch (e) {
      print('Error load levels: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshData() async {
    await loadLevels();
  }

  void onSelectLevel(LevelResponseModel level) {
    Get.toNamed('/topic', arguments: {
      'skill_id': skillId,
      'skill_name': skillName,
      'level_id': level.id,
      'level_name': level.name,
    });
  }
}
