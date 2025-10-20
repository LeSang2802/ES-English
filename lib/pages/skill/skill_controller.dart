import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:es_english/models/skill/skill_response_model.dart';
import 'package:es_english/pages/skill/skill_repository.dart';

class SkillController extends GetxController {
  final SkillRepository repo = SkillRepository();

  var skills = <SkillResponseModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadSkills();
  }

  Future<void> loadSkills() async {
    isLoading.value = true;
    try {
      skills.value = await repo.getSkills();
    } catch (e) {
      print("Error load skills: $e");
    } finally {
      isLoading.value = false;
    }
  }
  IconData getIconByIndex(int index) {
    switch (index) {
      case 0:
        return Icons.hearing_rounded; // Listening
      case 1:
        return Icons.record_voice_over_rounded; // Speaking
      case 2:
        return Icons.menu_book_rounded; // Reading
      case 3:
        return Icons.edit_note_rounded; // Writing
      default:
        return Icons.school_rounded;
    }
  }

  void onSelectSkill(SkillResponseModel skill) {
    Get.toNamed(
      '/level',
      arguments: skill,
    );
  }
}
