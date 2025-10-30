import 'package:confetti/confetti.dart';
import 'package:es_english/cores/constants/colors.dart';
import 'package:es_english/cores/constants/text_styles.dart';
import 'package:es_english/cores/widgets/base_app_bar.dart';
import 'package:es_english/cores/widgets/base_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../flash_card/flash_card_controller.dart';

class EndFlashCardPage extends StatefulWidget {
  const EndFlashCardPage({super.key});

  @override
  State<EndFlashCardPage> createState() => _EndFlashCardPageState();
}

class _EndFlashCardPageState extends State<EndFlashCardPage> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FlashCardController>();

    return BasePage(
      isLoading: controller.isLoading,
      isNestedScroll: false,
      backgroundColor: BgColors.main,
      appBar: BaseAppBar(
        title: controller.topicTitle,
        leadingWidget: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.offAllNamed('/vocabulary'),
        ),
      ),
      isPaddingDefault: false,
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      'assets/images/congra.png',
                      height: 200,
                    ),
                    ConfettiWidget(
                      confettiController: _confettiController,
                      blastDirectionality: BlastDirectionality.explosive,
                      emissionFrequency: 0.05,
                      numberOfParticles: 30,
                      gravity: 0.3,
                      shouldLoop: false,
                      maxBlastForce: 15,
                      minBlastForce: 8,
                      colors: const [
                        Colors.red,
                        Colors.blue,
                        Colors.green,
                        Colors.yellow,
                        Colors.purple,
                        Colors.orange,
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text('congratulation'.tr, style: TextStyles.largeBold),
                const SizedBox(height: 8),
                Text(
                  'reviewed_all_card'.tr,
                  style: TextStyles.medium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                TextButton.icon(
                  onPressed: () async {
                    await controller.loadFlashcards();
                    controller.currentIndex.value = 0;
                    Get.offNamed('/flashCard', arguments: {
                      'topic_id': controller.topicId,
                      'topic_title': controller.topicTitle,
                    });
                  },
                  icon: const Icon(Icons.refresh),
                  label: Text('back_to_first'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    textStyle: TextStyles.mediumBold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
