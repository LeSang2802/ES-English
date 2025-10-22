import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:es_english/cores/constants/colors.dart';
import 'package:es_english/cores/constants/text_styles.dart';
import 'package:es_english/cores/widgets/base_app_bar.dart';
import 'package:es_english/cores/widgets/base_bottom_nav.dart';
import 'package:es_english/cores/widgets/base_page.dart';
import 'package:es_english/cores/widgets/refresh_loadmore_grid_widget.dart';
import 'package:es_english/models/skill/skill_response_model.dart';
import 'skill_controller.dart';

class SkillPage extends GetView<SkillController> {
  const SkillPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BasePage(
      isLoading: controller.isLoading,
      isNestedScroll: false,
      appBar: BaseAppBar(title: 'Skills', showBackButton: false),
      bottomNavigationBar: BaseBottomNav(
        currentIndex: 1,
        onTap: (index) {
          switch (index) {
            case 0:
              Get.offAllNamed('/home');
              break;
            case 1:
              break;
            case 2:
              Get.offAllNamed('/progress');
              break;
            case 3:
              Get.offAllNamed('/account');
              break;
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.bottom,
        elevation: 3,
        shape: const CircleBorder(),
        onPressed: () => Get.toNamed('/search'),
        child: const Icon(Icons.search, color: AppColors.primary, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Obx(() {
        final items = controller.skills;

        if (items.isEmpty && !controller.isLoading.value) {
          return const Center(child: Text('No skills found'));
        }

        return RefreshLoadMoreGridWidget<SkillResponseModel>(
          items: items,
          onRefresh: controller.loadSkills,
          isLoadingMore: false,
          physics: const AlwaysScrollableScrollPhysics(),
          itemBuilder: (context, index, skill) =>
              _buildSkillCard(context, skill, index, controller),
          onTapItem: (_, skill) => controller.onSelectSkill(skill),
        );
      }),
    );
  }

  Widget _buildSkillCard(BuildContext context, SkillResponseModel skill, int index, SkillController controller) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE8F0FE),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(controller.getIconByIndex(index), size: 48, color: AppColors.primary),
          const SizedBox(height: 8),
          Text(skill.name ?? "Unknown", style: TextStyles.mediumBold),
        ],
      ),
    );
  }
}

