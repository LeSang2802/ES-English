import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:get/get.dart';
import '../constants/colors.dart';

/// Thanh điều hướng dưới dùng chung toàn app.
/// Hiển thị icon + text, có notch ở giữa để FloatingActionButton của BasePage lọt vào.
class BaseBottomNav extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BaseBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<BaseBottomNav> createState() => _BaseBottomNavState();
}

class _BaseBottomNavState extends State<BaseBottomNav>
    with TickerProviderStateMixin {
  late AnimationController _borderRadiusController;
  late Animation<double> _borderRadiusAnimation;

  final iconList = <IconData>[
    Icons.home_rounded,
    Icons.menu_book_rounded,
    Icons.stacked_bar_chart_rounded,
    Icons.person_outline_rounded,
  ];

  @override
  void initState() {
    super.initState();
    _borderRadiusController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _borderRadiusAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _borderRadiusController,
        curve: Curves.fastOutSlowIn,
      ),
    );
    _borderRadiusController.forward();
  }

  @override
  void dispose() {
    _borderRadiusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final labels = ['home'.tr, 'skill'.tr, 'progress'.tr, 'account'.tr];

    return AnimatedBottomNavigationBar.builder(
      itemCount: iconList.length,
      tabBuilder: (int index, bool isActive) {
        final color = isActive ? AppColors.primary : Colors.grey.shade400;

        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(iconList[index], color: color, size: 26),
            const SizedBox(height: 4),
            Text(
              labels[index],
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        );
      },
      backgroundColor: Colors.white,
      activeIndex: widget.currentIndex,
      splashColor: AppColors.primary.withOpacity(0.1),
      notchAndCornersAnimation: _borderRadiusAnimation,
      splashSpeedInMilliseconds: 300,
      notchSmoothness: NotchSmoothness.softEdge,
      gapLocation: GapLocation.center,
      leftCornerRadius: 16,
      rightCornerRadius: 16,
      onTap: widget.onTap,
      shadow: const BoxShadow(
        offset: Offset(0, -1),
        blurRadius: 8,
        color: Colors.black12,
      ),
    );
  }
}
