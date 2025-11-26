// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:fl_chart/fl_chart.dart';
// import '../../cores/constants/colors.dart';
// import '../../cores/constants/dimens.dart';
// import '../../cores/constants/text_styles.dart';
// import '../../cores/widgets/base_app_bar.dart';
// import '../../cores/widgets/base_bottom_nav.dart';
// import '../../cores/widgets/base_page.dart';
// import '../../models/progress/progress_response_model.dart';
// import 'progress_controller.dart';
//
// class ProgressPage extends StatelessWidget {
//   const ProgressPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final c = Get.put(ProgressController());
//
//     return BasePage(
//       isLoading: c.isLoading,
//       isNestedScroll: false,
//       appBar: BaseAppBar(title: 'progress'.tr, showBackButton: false),
//       bottomNavigationBar: BaseBottomNav(
//         currentIndex: 2,
//         onTap: (index) {
//           switch (index) {
//             case 0:
//               Get.offAllNamed('/home');
//               break;
//             case 1:
//               Get.offAllNamed('/skill');
//               break;
//             case 2:
//               break;
//             case 3:
//               Get.offAllNamed('/account');
//               break;
//           }
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: AppColors.bottom,
//         elevation: 3,
//         shape: const CircleBorder(),
//         onPressed: () => Get.toNamed('/search'),
//         child: const Icon(Icons.search, color: AppColors.primary, size: 28),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       body: Obx(() {
//         final skillsSummary = c.skillsSummary;
//         final progressItems = c.progressData.value?.progress ?? [];
//
//         // Empty state đơn giản
//         if (skillsSummary.isEmpty && progressItems.isEmpty) {
//           return Center(child: Text('no_progress'.tr));
//         }
//
//         return RefreshIndicator(
//           onRefresh: c.loadProgress,
//           child: SingleChildScrollView(
//             physics: AlwaysScrollableScrollPhysics(),
//             padding: EdgeInsets.only(
//               left: MarginDimens.large,
//               right: MarginDimens.large,
//               bottom: MarginDimens.large + 80,
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(height: MarginDimens.large),
//
//                 // Pie Chart
//                 if (skillsSummary.isNotEmpty) ...[
//                   _SkillsPieChart(skills: skillsSummary),
//                   SizedBox(height: MarginDimens.large),
//                 ],
//
//                 // Thống kê
//                 if (c.progressData.value != null) ...[
//                   _ProgressStats(data: c.progressData.value!),
//                   SizedBox(height: MarginDimens.large),
//                 ],
//
//                 // Danh sách progress
//                 if (progressItems.isNotEmpty) ...[
//                   Text('learning_progress'.tr, style: TextStyles.largeBold),
//                   SizedBox(height: MarginDimens.normal),
//                   ListView.builder(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     itemCount: progressItems.length,
//                     itemBuilder: (_, index) => _ProgressListItem(
//                       item: progressItems[index],
//                       onTap: () => c.onTapContinue(progressItems[index]),
//                     ),
//                   ),
//                 ],
//               ],
//             ),
//           ),
//         );
//       }),
//     );
//   }
// }
//
// // Pie Chart Widget
// class _SkillsPieChart extends StatelessWidget {
//   final List<SkillSummary> skills;
//
//   const _SkillsPieChart({required this.skills});
//
//   @override
//   Widget build(BuildContext context) {
//     final colors = [
//       Color(0xFF4285F4), // Blue - Listening
//       Color(0xFF34A853), // Green - Reading
//       Color(0xFFFBBC04), // Yellow - Speaking
//       Color(0xFFEA4335), // Red - Writing
//     ];
//
//     // Tính tổng điểm của tất cả kỹ năng
//     final totalScore = skills.fold<int>(0, (sum, skill) => sum + (skill.totalScore ?? 0));
//
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Text('skills_overview'.tr, style: TextStyles.largeBold),
//           SizedBox(height: 20),
//
//           SizedBox(
//             height: 220,
//             child: PieChart(
//               PieChartData(
//                 sectionsSpace: 3,
//                 centerSpaceRadius: 60,
//                 sections: skills.asMap().entries.map((entry) {
//                   final index = entry.key;
//                   final skill = entry.value;
//                   // Tính phần trăm = (total_score của skill / tổng điểm) x 100
//                   final percent = totalScore > 0
//                       ? ((skill.totalScore ?? 0) / totalScore * 100).round()
//                       : 0;
//
//                   return PieChartSectionData(
//                     color: colors[index % colors.length],
//                     value: percent > 0 ? percent.toDouble() : 1,
//                     title: '$percent%',
//                     radius: 65,
//                     titleStyle: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   );
//                 }).toList(),
//               ),
//             ),
//           ),
//
//           SizedBox(height: 20),
//
//           // Legend
//           Wrap(
//             spacing: 20,
//             runSpacing: 12,
//             alignment: WrapAlignment.center,
//             children: skills.asMap().entries.map((entry) {
//               final index = entry.key;
//               final skill = entry.value;
//               return Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Container(
//                     width: 16,
//                     height: 16,
//                     decoration: BoxDecoration(
//                       color: colors[index % colors.length],
//                       shape: BoxShape.circle,
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   Text(
//                     _getSkillDisplayName(skill.skill ?? ''),
//                     style: TextStyles.small.copyWith(fontWeight: FontWeight.w600),
//                   ),
//                 ],
//               );
//             }).toList(),
//           ),
//         ],
//       ),
//     );
//   }
//
//   String _getSkillDisplayName(String code) {
//     switch (code.toUpperCase()) {
//       case 'LISTENING':
//         return 'Listening';
//       case 'READING':
//         return 'Reading';
//       case 'SPEAKING':
//         return 'Speaking';
//       case 'WRITING':
//         return 'Writing';
//       default:
//         return code;
//     }
//   }
// }
//
// // Thống kê tổng quan
// class _ProgressStats extends StatelessWidget {
//   final ProgressResponseModel data;
//
//   const _ProgressStats({required this.data});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: _StatItem(
//               icon: Icons.assignment_turned_in,
//               label: 'attempts'.tr,
//               value: '${data.totalUserAttempts ?? 0}',
//               color: Colors.blue,
//             ),
//           ),
//           Container(width: 1, height: 40, color: Colors.grey[300]),
//           Expanded(
//             child: _StatItem(
//               icon: Icons.stars,
//               label: 'score'.tr,
//               value: '${data.totalUserScore ?? 0}',
//               color: Colors.orange,
//             ),
//           ),
//           Container(width: 1, height: 40, color: Colors.grey[300]),
//           Expanded(
//             child: _StatItem(
//               icon: Icons.timer,
//               label: 'study_time'.tr,
//               value: '${((data.studyTime?.total7Days ?? 0) / 60).toStringAsFixed(0)}',
//               color: Colors.green,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _StatItem extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final String value;
//   final Color color;
//
//   const _StatItem({
//     required this.icon,
//     required this.label,
//     required this.value,
//     required this.color,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Icon(icon, color: color, size: 28),
//         SizedBox(height: 8),
//         Text(value, style: TextStyles.mediumBold),
//         Text(label, style: TextStyles.small.copyWith(color: Colors.grey[600])),
//       ],
//     );
//   }
// }
//
// // Progress List Item
// class _ProgressListItem extends StatelessWidget {
//   final ProgressItem item;
//   final VoidCallback onTap;
//
//   const _ProgressListItem({required this.item, required this.onTap});
//
//   @override
//   Widget build(BuildContext context) {
//     final percent = item.progressPercent ?? 0;
//
//     return Container(
//       margin: EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.03),
//             blurRadius: 4,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           // Progress Circle
//           SizedBox(
//             width: 50,
//             height: 50,
//             child: Stack(
//               alignment: Alignment.center,
//               children: [
//                 CircularProgressIndicator(
//                   value: percent / 100,
//                   strokeWidth: 5,
//                   color: AppColors.primary,
//                   backgroundColor: AppColors.primary.withOpacity(0.15),
//                 ),
//                 Text(
//                   '$percent%',
//                   style: const TextStyle(
//                     fontSize: 12,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           SizedBox(width: 16),
//
//           // Content
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   item.skillName ?? 'Unknown',
//                   style: TextStyles.mediumBold,
//                 ),
//                 SizedBox(height: 4),
//                 Text(
//                   item.topicTitle ?? '',
//                   style: TextStyles.small.copyWith(color: Colors.grey[600]),
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 SizedBox(height: 4),
//                 Row(
//                   children: [
//                     Container(
//                       padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                       decoration: BoxDecoration(
//                         color: AppColors.primary.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(4),
//                       ),
//                       child: Text(
//                         item.level ?? '',
//                         style: TextStyles.small.copyWith(
//                           color: AppColors.primary,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: 8),
//                     Text(
//                       '${item.totalQuestions}/${item.totalLessons} ${"lesson".tr}',
//                       style: TextStyles.small.copyWith(color: Colors.grey[600]),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//
//           // Continue Button
//           IconButton(
//             onPressed: onTap,
//             icon: Icon(Icons.arrow_forward_ios, size: 18),
//             color: AppColors.primary,
//           ),
//         ],
//       ),
//     );
//   }
// }

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
        final skillsSummary = c.skillsSummary;
        final progressItems = c.progressData.value?.progress ?? [];

        // Empty state đơn giản
        if (skillsSummary.isEmpty && progressItems.isEmpty) {
          return Center(child: Text('no_progress'.tr));
        }

        return RefreshIndicator(
          onRefresh: c.loadProgress,
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
                if (skillsSummary.isNotEmpty) ...[
                  _SkillsPieChart(skills: skillsSummary),
                  SizedBox(height: MarginDimens.large),
                ],

                // Thống kê
                if (c.progressData.value != null) ...[
                  _ProgressStats(data: c.progressData.value!),
                  SizedBox(height: MarginDimens.large),
                ],

                // ============================================
                // NÚT GỢI Ý LỘ TRÌNH TỪ AI - THÊM MỚI
                // ============================================
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
                        'Gợi ý lộ trình từ AI',
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

                // Danh sách progress
                if (progressItems.isNotEmpty) ...[
                  Text('learning_progress'.tr, style: TextStyles.largeBold),
                  SizedBox(height: MarginDimens.normal),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: progressItems.length,
                    itemBuilder: (_, index) => _ProgressListItem(
                      item: progressItems[index],
                      onTap: () => c.onTapContinue(progressItems[index]),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      }),
    );
  }

  // ============================================
  // HÀM HIỂN THỊ DIALOG GỢI Ý AI - THÊM MỚI
  // ============================================
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
            // Loading state
            if (c.isLoadingSuggestion.value) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: Colors.deepPurple),
                  SizedBox(height: 16),
                  Text(
                    'AI đang phân tích tiến độ của bạn...',
                    style: TextStyles.medium,
                    textAlign: TextAlign.center,
                  ),
                ],
              );
            }

            // Empty state
            if (c.aiSuggestion.value.isEmpty) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.orange),
                  SizedBox(height: 16),
                  Text('Chưa có gợi ý', style: TextStyles.largeBold),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Đóng'),
                  ),
                ],
              );
            }

            // Success state - hiển thị gợi ý
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
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
                        'Gợi ý lộ trình học',
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

                // Content
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

                // Button
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
                      'Đã hiểu',
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

// ============================================
// GIỮ NGUYÊN CÁC WIDGET CŨ
// ============================================

// Pie Chart Widget
class _SkillsPieChart extends StatelessWidget {
  final List<SkillSummary> skills;

  const _SkillsPieChart({required this.skills});

  @override
  Widget build(BuildContext context) {
    final colors = [
      Color(0xFF4285F4), // Blue - Listening
      Color(0xFF34A853), // Green - Reading
      Color(0xFFFBBC04), // Yellow - Speaking
      Color(0xFFEA4335), // Red - Writing
    ];

    final totalScore = skills.fold<int>(0, (sum, skill) => sum + (skill.totalScore ?? 0));

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
                sections: skills.asMap().entries.map((entry) {
                  final index = entry.key;
                  final skill = entry.value;
                  final percent = totalScore > 0
                      ? ((skill.totalScore ?? 0) / totalScore * 100).round()
                      : 0;

                  return PieChartSectionData(
                    color: colors[index % colors.length],
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

          // Legend
          Wrap(
            spacing: 20,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: skills.asMap().entries.map((entry) {
              final index = entry.key;
              final skill = entry.value;
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: colors[index % colors.length],
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _getSkillDisplayName(skill.skill ?? ''),
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

  String _getSkillDisplayName(String code) {
    switch (code.toUpperCase()) {
      case 'LISTENING':
        return 'Listening';
      case 'READING':
        return 'Reading';
      case 'SPEAKING':
        return 'Speaking';
      case 'WRITING':
        return 'Writing';
      default:
        return code;
    }
  }
}

// Thống kê tổng quan
class _ProgressStats extends StatelessWidget {
  final ProgressResponseModel data;

  const _ProgressStats({required this.data});

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
              value: '${data.totalUserAttempts ?? 0}',
              color: Colors.blue,
            ),
          ),
          Container(width: 1, height: 40, color: Colors.grey[300]),
          Expanded(
            child: _StatItem(
              icon: Icons.stars,
              label: 'score'.tr,
              value: '${data.totalUserScore ?? 0}',
              color: Colors.orange,
            ),
          ),
          Container(width: 1, height: 40, color: Colors.grey[300]),
          Expanded(
            child: _StatItem(
              icon: Icons.timer,
              label: 'study_time'.tr,
              value: '${((data.studyTime?.total7Days ?? 0) / 60).toStringAsFixed(0)}',
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
          // Progress Circle
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

          // Content
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
                  item.topicTitle ?? '',
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
                      '${item.totalQuestions}/${item.totalLessons} ${"lesson".tr}',
                      style: TextStyles.small.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Continue Button
          IconButton(
            onPressed: onTap,
            icon: Icon(Icons.arrow_forward_ios, size: 18),
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }
}