import 'package:es_english/pages/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

import '../../cores/constants/colors.dart';
import '../../cores/constants/text_styles.dart';
import '../../cores/constants/dimens.dart';
import '../../cores/widgets/base_app_bar.dart';
import '../../cores/widgets/base_bottom_nav.dart';
import '../../cores/widgets/base_page.dart';
import 'package:flutter_svg/flutter_svg.dart';


class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BasePage(
      isLoading: false.obs,
      isNestedScroll: false,
      appBar: _buildHomeAppBar(context),
      bottomNavigationBar: BaseBottomNav(
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0:
              // Get.offAllNamed('/home');
              break;
            case 1:
              Get.offAllNamed('/skill');
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
      body: Obx(() => SingleChildScrollView(
            padding: EdgeInsets.only(
              left: MarginDimens.large,
              right: MarginDimens.large,
              bottom: MarginDimens.large + 80,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _learnedTodayCard(context, controller),
                SizedBox(height: MarginDimens.large),
                _slider(controller),
                SizedBox(height: MarginDimens.large),
                Text('home_question'.tr, style: TextStyles.largeBold),
                SizedBox(height: MarginDimens.large),
                _dailyChallenge(controller),
                SizedBox(height: MarginDimens.large),
                if (controller.flashcard.value != null)
                  _flashcardTile(controller),
                SizedBox(height: MarginDimens.large),
                _chatbotTile(controller),
              ],
            ),
          )),
    );
  }

  PreferredSizeWidget _buildHomeAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(80),
      child: Container(
        padding:
            const EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 16),
        decoration: BoxDecoration(
          color: BgColors.appBar,
          // borderRadius: const BorderRadius.only(
          //   bottomLeft: Radius.circular(25),
          //   bottomRight: Radius.circular(25),
          // ),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 6,
                offset: const Offset(0, 3))
          ],
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('homepage_greetings'.tr,
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                    Text(", ${DummyUser.name}",
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                  ],
                ),
                const SizedBox(height: 4),
                Text('words_start_learning'.tr,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white.withOpacity(0.9),
                    )),
              ],
            ),
            const Spacer(),
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white.withOpacity(0.2),
              child: const Icon(Icons.person, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _learnedTodayCard(BuildContext context, HomeController c) {
    return Container(
      padding: EdgeInsets.all(MarginDimens.large),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(RadiusDimens.large),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('learned_today'.tr,
                  style: TextStyles.small.copyWith(color: Colors.grey[600])),
              // Text('My courses', style: TextStyles.smallBold.copyWith(color: AppColors.primary)),
            ],
          ),
          SizedBox(height: 6),
          Row(
            children: [
              Text('${c.learnedTodayMin.value}min',
                  style: TextStyles.largeBold),
              const SizedBox(width: 6),
              Text('/ ${c.targetMin.value}min',
                  style: TextStyles.small.copyWith(color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: c.progressToday,
              minHeight: 6,
              color: AppColors.primary,
              backgroundColor: AppColors.primary.withOpacity(0.15),
            ),
          ),
        ],
      ),
    );
  }

  Widget _slider(HomeController c) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(RadiusDimens.normal),
      child: ImageSlideshow(
        width: double.infinity,
        height: 160,
        indicatorBottomPadding: 10,
        indicatorRadius: 3,
        indicatorColor: AppColors.primary,
        indicatorBackgroundColor: Colors.grey.shade400,
        autoPlayInterval: 4000,
        isLoop: true,
        children: c.sliderImages.map((p) {
          return Container(
            color: Colors.blue.shade50,
            child: Image.asset(p, fit: BoxFit.cover),
          );
        }).toList(),
      ),
    );
  }

  Widget _chatbotTile(HomeController c) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(RadiusDimens.normal),
      elevation: 2,
      child: InkWell(
        onTap: c.onTapChatbot,
        borderRadius: BorderRadius.circular(RadiusDimens.normal),
        child: Padding(
          padding: EdgeInsets.all(MarginDimens.large),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.primary.withOpacity(.1),
                child: SvgPicture.asset(
                  "assets/icons/chatbot.svg",
                  width: 35,
                  height: 35,
                  color: IconColors.primary, // nếu muốn đổi màu
                ),
              ),
              SizedBox(width: MarginDimens.large),
              Expanded(
                child: Text('introducing_chatbot'.tr,
                    style: TextStyles.mediumBold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dailyChallenge(HomeController c) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(RadiusDimens.normal),
      elevation: 2,
      child: InkWell(
        onTap: c.onTapDailyChallenge,
        borderRadius: BorderRadius.circular(RadiusDimens.normal),
        child: Padding(
          padding: EdgeInsets.all(MarginDimens.large),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.primary.withOpacity(.1),
                child: SvgPicture.asset(
                  "assets/icons/challenge.svg",
                  width: 45,
                  height: 45,
                  color: IconColors.primary,
                ),
              ),
              SizedBox(width: MarginDimens.large),
              // Expanded(
              //   child: Text('daily_challenge'.tr, style: TextStyles.mediumBold),
              // ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('daily_challenge'.tr, style: TextStyles.mediumBold),
                    SizedBox(height: 4),
                    Text('start_now'.tr,
                        style:
                            TextStyles.small.copyWith(color: Colors.grey[600])),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _flashcardTile(HomeController c) {
    final f = c.flashcard.value!;
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(RadiusDimens.normal),
      elevation: 2,
      child: InkWell(
        onTap: c.onTapFlashcard,
        borderRadius: BorderRadius.circular(RadiusDimens.normal),
        child: Padding(
          padding: EdgeInsets.all(MarginDimens.large),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.primary.withOpacity(.1),
                child: SvgPicture.asset(
                  "assets/icons/flashcard.svg",
                  width: 30,
                  height: 30,
                  color: IconColors.primary, // nếu muốn đổi màu
                ),
              ),
              SizedBox(width: MarginDimens.large),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('title_flashcard_homepage'.tr,
                        style: TextStyles.mediumBold),
                    SizedBox(height: 4),
                    Text('suggestion_flashcard_homepage'.tr,
                        style:
                            TextStyles.small.copyWith(color: Colors.grey[600])),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

/// Giả lập hiển thị tên user ở AppBar (bạn có thể thay bằng profile thực)
class DummyUser {
  static const name = 'Long';
}
