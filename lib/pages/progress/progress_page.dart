import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../cores/constants/colors.dart';
import '../../cores/constants/dimens.dart';
import '../../cores/constants/text_styles.dart';
import '../../cores/widgets/base_app_bar.dart';
import '../../cores/widgets/base_bottom_nav.dart';
import '../../cores/widgets/base_page.dart';
import '../../models/progress/progress_response_model.dart';
import 'progress_controller.dart';

class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(ProgressController());

    return BasePage(
      isLoading: c.isLoading,
      isNestedScroll: false,
      appBar: BaseAppBar(title: 'progress'.tr, showBackButton: false),
      bottomNavigationBar: BaseBottomNav(
        currentIndex: 2,
        onTap: (index) {
          switch (index) {
            case 0:
              Get.offAllNamed('/home');
              break;
            case 1:
              Get.offAllNamed('/skill');
              break;
            case 2:
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
        if (!c.hasData) {
          return Center(child: Text('no_progress'.tr));
        }

        return RefreshIndicator(
          onRefresh: c.refreshAllData,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.only(
              left: MarginDimens.large,
              right: MarginDimens.large,
              bottom: MarginDimens.large + 80,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MarginDimens.large),

                // Pie Chart
                if (c.skillsSummary.isNotEmpty) ...[
                  _SkillsPieChart(controller: c),
                  SizedBox(height: MarginDimens.large),
                ],

                // Stats
                if (c.progressData.value != null) ...[
                  _ProgressStats(controller: c),
                  SizedBox(height: MarginDimens.large),
                ],

                // AI Suggestion Button
                if (c.progressData.value != null) ...[
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        c.getAISuggestion();
                        _showAISuggestionDialog(context, c);
                      },
                      icon: Icon(Icons.auto_awesome, color: Colors.white),
                      label: Text(
                        'suggestions_from_AI'.tr,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  SizedBox(height: MarginDimens.large),
                ],

                // Learning Progress Section
                _ExpandableSection(
                  title: 'learning_progress'.tr,
                  isExpanded: c.isProgressItemsExpanded,
                  isLoading: c.isLoadingProgressItems,
                  onToggle: c.loadProgressItems,
                  child: Obx(() {
                    if (!c.isProgressItemsExpanded.value) return SizedBox.shrink();

                    if (c.isLoadingProgressItems.value) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    if (c.progressItems.isEmpty) {
                      return Padding(
                        padding: EdgeInsets.all(20),
                        child: Center(
                          child: Text(
                            'no_learning_progress'.tr,
                            style: TextStyles.medium.copyWith(color: Colors.grey),
                          ),
                        ),
                      );
                    }

                    return Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: c.displayedProgressItems.length,
                          itemBuilder: (_, index) => _ProgressListItem(
                            item: c.displayedProgressItems[index],
                            onTap: () => c.onTapContinue(c.displayedProgressItems[index]),
                          ),
                        ),

                        // Toggle button
                        if (c.hiddenProgressItemsCount > 0) ...[
                          SizedBox(height: 12),
                          InkWell(
                            onTap: c.toggleShowAllProgress,
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    c.showAllProgress.value
                                        ? 'collapse'.tr
                                        : '${'see_more'.tr} (${c.hiddenProgressItemsCount})',
                                    style: TextStyles.medium.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(
                                    c.showAllProgress.value
                                        ? Icons.keyboard_arrow_up
                                        : Icons.keyboard_arrow_down,
                                    color: AppColors.primary,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    );
                  }),
                ),

                SizedBox(height: MarginDimens.large),

                // Mock Tests History Section
                _ExpandableSection(
                  title: 'mock_test_history'.tr,
                  isExpanded: c.isMockTestsExpanded,
                  isLoading: c.isLoadingMockTests,
                  onToggle: c.loadMockTests,
                  child: Obx(() {
                    if (!c.isMockTestsExpanded.value) return SizedBox.shrink();

                    if (c.isLoadingMockTests.value) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    if (c.mockTests.isEmpty) {
                      return Padding(
                        padding: EdgeInsets.all(20),
                        child: Center(
                          child: Text(
                            'no_mock_tests'.tr,
                            style: TextStyles.medium.copyWith(color: Colors.grey),
                          ),
                        ),
                      );
                    }

                    return Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: c.displayedMockTests.length,
                          itemBuilder: (_, index) => _MockTestItem(
                            mockTest: c.displayedMockTests[index],
                            controller: c,
                          ),
                        ),

                        // Toggle button
                        if (c.hiddenMockTestsCount > 0) ...[
                          SizedBox(height: 12),
                          InkWell(
                            onTap: c.toggleShowAllMockTests,
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    c.showAllMockTests.value
                                        ? 'collapse'.tr
                                        : '${'see_more'.tr} (${c.hiddenMockTestsCount})',
                                    style: TextStyles.medium.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(
                                    c.showAllMockTests.value
                                        ? Icons.keyboard_arrow_up
                                        : Icons.keyboard_arrow_down,
                                    color: AppColors.primary,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    );
                  }),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  void _showAISuggestionDialog(BuildContext context, ProgressController c) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          constraints: BoxConstraints(maxWidth: 500, maxHeight: 600),
          padding: EdgeInsets.all(24),
          child: Obx(() {
            if (c.isLoadingSuggestion.value) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: Colors.deepPurple),
                  SizedBox(height: 16),
                  Text(
                    'AI_is_analyzing_your_progress'.tr,
                    style: TextStyles.medium,
                    textAlign: TextAlign.center,
                  ),
                ],
              );
            }

            if (c.aiSuggestion.value.isEmpty) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.orange),
                  SizedBox(height: 16),
                  Text('no_suggestions_yet'.tr, style: TextStyles.largeBold),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('close'.tr),
                  ),
                ],
              );
            }

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.auto_awesome, color: Colors.deepPurple, size: 28),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'suggested_learning_path'.tr,
                        style: TextStyles.largeBold.copyWith(color: Colors.deepPurple),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Divider(),
                SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Text(
                        c.aiSuggestion.value,
                        style: TextStyles.medium.copyWith(height: 1.6),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      'understood'.tr,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

// Expandable Section Widget
class _ExpandableSection extends StatelessWidget {
  final String title;
  final RxBool isExpanded;
  final RxBool isLoading;
  final VoidCallback onToggle;
  final Widget child;

  const _ExpandableSection({
    required this.title,
    required this.isExpanded,
    required this.isLoading,
    required this.onToggle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(16),
              bottom: Radius.circular(isExpanded.value ? 0 : 16),
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyles.largeBold,
                    ),
                  ),
                  Obx(() {
                    if (isLoading.value) {
                      return SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      );
                    }

                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            isExpanded.value ? 'hide'.tr : 'view'.tr,
                            style: TextStyles.medium.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            isExpanded.value
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_right,
                            color: AppColors.primary,
                            size: 20,
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

// Pie Chart Widget
class _SkillsPieChart extends StatelessWidget {
  final ProgressController controller;

  const _SkillsPieChart({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text('skills_overview'.tr, style: TextStyles.largeBold),
          SizedBox(height: 20),

          SizedBox(
            height: 220,
            child: PieChart(
              PieChartData(
                sectionsSpace: 3,
                centerSpaceRadius: 60,
                sections: controller.skillsSummary.asMap().entries.map((entry) {
                  final index = entry.key;
                  final skill = entry.value;
                  final percent = controller.getSkillPercentage(skill);

                  return PieChartSectionData(
                    color: controller.pieChartColors[index % controller.pieChartColors.length],
                    value: percent > 0 ? percent.toDouble() : 1,
                    title: '$percent%',
                    radius: 65,
                    titleStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          SizedBox(height: 20),

          Wrap(
            spacing: 20,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: controller.skillsSummary.asMap().entries.map((entry) {
              final index = entry.key;
              final skill = entry.value;
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: controller.pieChartColors[index % controller.pieChartColors.length],
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    controller.getSkillDisplayName(skill.skill ?? ''),
                    style: TextStyles.small.copyWith(fontWeight: FontWeight.w600),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// Stats Widget
class _ProgressStats extends StatelessWidget {
  final ProgressController controller;

  const _ProgressStats({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _StatItem(
              icon: Icons.assignment_turned_in,
              label: 'attempts'.tr,
              value: '${controller.totalAttempts}',
              color: Colors.blue,
            ),
          ),
          Container(width: 1, height: 40, color: Colors.grey[300]),
          Expanded(
            child: _StatItem(
              icon: Icons.stars,
              label: 'score'.tr,
              value: '${controller.totalScore}',
              color: Colors.orange,
            ),
          ),
          Container(width: 1, height: 40, color: Colors.grey[300]),
          Expanded(
            child: _StatItem(
              icon: Icons.timer,
              label: 'study_time'.tr,
              value: '${controller.studyTimeInMinutes.toStringAsFixed(0)}',
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        SizedBox(height: 8),
        Text(value, style: TextStyles.mediumBold),
        Text(label, style: TextStyles.small.copyWith(color: Colors.grey[600])),
      ],
    );
  }
}

// Progress List Item
class _ProgressListItem extends StatelessWidget {
  final ProgressItem item;
  final VoidCallback onTap;

  const _ProgressListItem({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final percent = item.progressPercent ?? 0;

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 50,
            height: 50,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: percent / 100,
                  strokeWidth: 5,
                  color: AppColors.primary,
                  backgroundColor: AppColors.primary.withOpacity(0.15),
                ),
                Text(
                  '$percent%',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.skillName ?? 'Unknown',
                  style: TextStyles.mediumBold,
                ),
                SizedBox(height: 4),
                Text(
                  item.topicDetails?.title ?? '',
                  style: TextStyles.small.copyWith(color: Colors.grey[600]),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        item.level ?? '',
                        style: TextStyles.small.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      '${item.totalAttempts?.toStringAsFixed(0) ?? 0} ${'attempts'.tr}',
                      style: TextStyles.small.copyWith(color: Colors.grey[600]),
                    ),
                    Spacer(),
                    Text(
                      '${item.point ?? 0} ${'score'.tr}',
                      style: TextStyles.small.copyWith(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Mock Test Item
class _MockTestItem extends StatelessWidget {
  final MockTest mockTest;
  final ProgressController controller;

  const _MockTestItem({
    required this.mockTest,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final correctPercent = controller.getMockTestCorrectPercent(mockTest);
    final formattedDate = controller.formatMockTestDate(mockTest.submittedAt);

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mockTest.testTitle ?? 'Unknown Test',
                      style: TextStyles.mediumBold,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      formattedDate,
                      style: TextStyles.small.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Text(
                      '${mockTest.testScore ?? 0}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    Text(
                      'score'.tr,
                      style: TextStyles.small.copyWith(color: Colors.orange),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 12),
          Divider(height: 1),
          SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _MockTestStat(
                  icon: Icons.check_circle,
                  label: 'correct'.tr,
                  value: '${mockTest.testCorrect ?? 0}',
                  color: Colors.green,
                ),
              ),
              Container(width: 1, height: 40, color: Colors.grey[300]),
              Expanded(
                child: _MockTestStat(
                  icon: Icons.cancel,
                  label: 'wrong'.tr,
                  value: '${mockTest.testIncorrect ?? 0}',
                  color: Colors.red,
                ),
              ),
              Container(width: 1, height: 40, color: Colors.grey[300]),
              Expanded(
                child: _MockTestStat(
                  icon: Icons.percent,
                  label: 'exactly'.tr,
                  value: '$correctPercent%',
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MockTestStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _MockTestStat({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        SizedBox(height: 4),
        Text(value, style: TextStyles.mediumBold),
        Text(
          label,
          style: TextStyles.small.copyWith(color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}