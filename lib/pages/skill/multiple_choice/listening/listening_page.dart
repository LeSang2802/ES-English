import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:es_english/cores/constants/colors.dart';
import 'package:es_english/cores/constants/text_styles.dart';
import 'package:es_english/cores/constants/dimens.dart';
import 'package:es_english/pages/skill/multiple_choice/shared/mcq_page.dart';
import 'package:get/get.dart';
import 'listening_controller.dart';

class ListeningPage extends McqPage<ListeningController> {
  const ListeningPage({super.key});

  @override
  Widget buildContent(BuildContext context, ListeningController controller) {
    final item = controller.currentData.value?.item;
    if (item == null) return const SizedBox();

    final level = controller.levelId.toUpperCase();

    final header = Padding(
      padding: EdgeInsets.symmetric(horizontal: MarginDimens.large),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "🎧 ${item.title ?? ''}",
            style: TextStyles.mediumBold.copyWith(color: AppColors.primary),
          ),
          SizedBox(height: MarginDimens.reading),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: controller.totalProgress,
              color: AppColors.primary,
              backgroundColor: Colors.grey.shade300,
              minHeight: 8,
            ),
          ),
          SizedBox(height: MarginDimens.large),
        ],
      ),
    );

    // xử lý theo cấp độ
    switch (level) {
      case 'INTERMEDIATE':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header,
            if (item.media_image_url != null)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: MarginDimens.large),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(item.media_image_url!),
                ),
              ),
            SizedBox(height: MarginDimens.listening),
            if (item.media_audio_url != null)
              _AudioCard(url: item.media_audio_url!),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: MarginDimens.large),
              child: Text(
                item.body_text ?? '',
                style: TextStyles.normal.copyWith(height: 1.5),
              ),
            ),
          ],
        );

      case 'ADVANCED':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header,
            if (item.media_audio_url != null)
              _AudioCard(url: item.media_audio_url!),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: MarginDimens.large),
              child: Text(item.body_text ?? '',
                  style: TextStyles.normal.copyWith(height: 1.5)),
            ),
          ],
        );

      case 'BEGINNER':
      default:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header,
            if (item.media_audio_url != null)
              _AudioCard(url: item.media_audio_url!),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: MarginDimens.large),
              child: Text(item.body_text ?? '',
                  style: TextStyles.normal.copyWith(height: 1.5)),
            ),
          ],
        );
    }
  }
}

//Nút phát audio
class _AudioCard extends StatefulWidget {
  final String url;
  const _AudioCard({required this.url});

  @override
  State<_AudioCard> createState() => _AudioCardState();
}

class _AudioCardState extends State<_AudioCard> {
  final player = AudioPlayer();
  bool playing = false;

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: MarginDimens.large),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        child: ListTile(
          leading: Icon(
            playing ? Icons.stop_circle : Icons.play_circle_fill,
            color: AppColors.primary,
            size: 36,
          ),
          title: Text('play_audio'.tr, style: TextStyle(fontSize: 15)),
          onTap: () async {
            if (playing) {
              await player.stop();
              setState(() => playing = false);
            } else {
              setState(() => playing = true);
              await player.play(UrlSource(widget.url));
              await player.onPlayerComplete.first;
              if (mounted) setState(() => playing = false);
            }
          },
        ),
      ),
    );
  }
}

