import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import '../../../cores/utils/dummy_util.dart';
import '../../../models/vocabulary/flash_card/flash_card_model.dart';
import 'package:audioplayers/audioplayers.dart';

class FlashCardController extends GetxController {
  final player = AudioPlayer();
  var vocabularies = <FlashCardModel>[].obs;
  var currentIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    vocabularies.value = DummyUtil.flashCards;
  }

  void nextCard() {
    if (currentIndex.value < vocabularies.length - 1) {
      currentIndex.value++;
    }
  }

  void prevCard() {
    if (currentIndex.value > 0) {
      currentIndex.value--;
    }
  }
  Future<void> playAudio(String url) async {
    if (url.isNotEmpty) {
      await player.play(AssetSource(url.replaceFirst("assets/", "")));
    }
  }
  // Future<void> playAudio(String? url) async {
  //   if (url != null && url.isNotEmpty) {
  //     try {
  //       await player.stop();                // Dừng nếu đang phát
  //       await player.play(UrlSource(url));  // Phát link online
  //     } catch (e) {
  //       print("Audio error: $e");
  //     }
  //   }
  // }

}

