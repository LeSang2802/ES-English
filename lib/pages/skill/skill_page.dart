import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../cores/constants/colors.dart';
import '../../../cores/constants/text_styles.dart';
import '../../../cores/widgets/base_app_bar.dart';
import '../../../cores/widgets/base_bottom_nav.dart';
import '../../../cores/widgets/base_page.dart';
import '../../../cores/widgets/refresh_loadmore_grid_widget.dart';
import '../../../models/skill/skill_model.dart';
import 'skill_controller.dart';

class SkillPage extends StatelessWidget {
  const SkillPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SkillController());

    return BasePage(
      isLoading: controller.isLoading,
      isNestedScroll: false,
      appBar: BaseAppBar(title: 'skill'.tr, showBackButton: false,),
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
      // body: Obx(() {
      //   if (controller.isLoading.value) {
      //     return const Center(child: CircularProgressIndicator());
      //   }
      //
      //   return RefreshLoadMoreGridWidget<Skill>(
      //     items: controller.skills,
      //     onRefresh: controller.loadSkills,
      //     isLoadingMore: false,
      //     itemBuilder: (context, index, skill) =>
      //         _buildSkillCard(context, skill),
      //     onTapItem: (_, skill) => controller.onSelectSkill(skill),
      //   );
      // }),
      body: Obx(() {
        final items = controller.skills;
        // if (controller.isLoading.value) {
        //   return const Center(child: CircularProgressIndicator());
        // }
        if (items.isEmpty) {
          return const Center(child: Text('Không có kỹ năng'));
        }

        // Bọc Grid trong Expanded hoặc cho phép scroll
        return RefreshLoadMoreGridWidget<Skill>(
          items: items,
          onRefresh: controller.loadSkills,
          isLoadingMore: false,
          physics: const AlwaysScrollableScrollPhysics(),
          itemBuilder: (context, index, skill) =>
              _buildSkillCard(context, skill),
          onTapItem: (_, skill) => controller.onSelectSkill(skill),
        );
      }),
    );
  }

  Widget _buildSkillCard(BuildContext context, Skill skill) {
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
          Icon(_getSkillIcon(skill.icon), size: 48, color: AppColors.primary),
          const SizedBox(height: 8),
          Text(skill.name, style: TextStyles.mediumBold),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: skill.progress,
              minHeight: 5,
              backgroundColor: Colors.white,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getSkillIcon(String iconName) {
    switch (iconName) {
      case 'ear':
        return Icons.hearing_rounded;
      case 'mic':
        return Icons.record_voice_over_rounded;
      case 'book':
        return Icons.menu_book_rounded;
      case 'pencil':
        return Icons.edit_note_rounded;
      case 'cards':
        return Icons.style_rounded;
      case 'clipboard':
        return Icons.assignment_rounded;
      default:
        return Icons.circle_outlined;
    }
  }
}
