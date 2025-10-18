import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../cores/constants/colors.dart';
import '../../cores/constants/dimens.dart';
import '../../cores/constants/text_styles.dart';
import '../../cores/widgets/base_app_bar.dart';
import '../../cores/widgets/base_bottom_nav.dart';
import '../../cores/widgets/base_page.dart';
import '../../models/progress/progress_model.dart';
import 'progress_controller.dart';

class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(ProgressController());

    return BasePage(
      isLoading: false.obs,
      isNestedScroll: false,
      appBar:  BaseAppBar(title: 'progress'.tr, showBackButton: false),
      bottomNavigationBar: BaseBottomNav(
        currentIndex: 2,
        onTap: (index) {
          switch (index) {
            case 0: Get.offAllNamed('/home'); break;
            case 1: Get.offAllNamed('/skill'); break;
            case 2: break;
            case 3: Get.offAllNamed('/account'); break;
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
        final items = c.filtered;

        return SingleChildScrollView(
          padding: EdgeInsets.only(
            left: MarginDimens.large,
            right: MarginDimens.large,
            bottom: MarginDimens.large + 80,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Padding(
              //   padding: EdgeInsets.only(top: MarginDimens.large),
              //   child: Text('Progress', style: TextStyles.largeBold),
              // ),
              // SizedBox(height: MarginDimens.large),

              _LevelChips(selected: c.selectedLevel.value, onChanged: c.pickLevel),
              SizedBox(height: MarginDimens.large),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 0.95,
                ),
                itemBuilder: (_, i) =>
                    _ProgressCard(item: items[i], onTap: () => c.onTapContinue(items[i])),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _LevelChips extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;

  const _LevelChips({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final levels = const [
      ['beginner', 'Beginner'],
      ['intermediate', 'Intermediate'],
      ['advanced', 'Advanced'],
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: levels.map((lv) {
        final value = lv[0]!;
        final label = lv[1]!;
        final isActive = selected == value;

        return ChoiceChip(
          label: Text(label, style: TextStyle(
            color: isActive ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
          )),
          selected: isActive,
          onSelected: (_) => onChanged(value),
          selectedColor: AppColors.primary,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(color: isActive ? AppColors.primary : Colors.grey.shade300),
          ),
        );
      }).toList(),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  final SkillProgress item;
  final VoidCallback onTap;

  const _ProgressCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.skill, style: TextStyles.mediumBold),
            const SizedBox(height: 8),

            Row(
              children: [
                SizedBox(
                  width: 42,
                  height: 42,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: (item.percent / 100),
                        strokeWidth: 5,
                        color: AppColors.primary,
                        backgroundColor: AppColors.primary.withOpacity(0.15),
                      ),
                      Text('${item.percent}%', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_disp(item.level), style: TextStyles.smallBold),
                      Text('${item.completed}/${item.total} ${"lesson".tr}',
                          style: TextStyles.small.copyWith(color: Colors.grey[600])),
                    ],
                  ),
                ),
              ],
            ),

            const Spacer(),

            Center(
              child: ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                ),
                child: Text('continue'.tr, style: TextStyles.smallBold.copyWith(color: TextColors.appBar)),
              ),
            ),

          ],
        ),
      ),
    );
  }

  static String _disp(String lv) {
    switch (lv) {
      case 'beginner': return 'Beginner';
      case 'intermediate': return 'Intermediate';
      case 'advanced': return 'Advanced';
      default: return lv;
    }
  }
}
