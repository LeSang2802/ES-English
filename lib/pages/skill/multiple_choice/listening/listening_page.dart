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
          // Text(
          //   "🎧 ${item.title ?? ''}",
          //   style: TextStyles.mediumBold.copyWith(color: AppColors.textDark),
          // ),
          SizedBox(height: MarginDimens.reading),
          _buildProgress(controller),
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
            if (item?.media_image_url != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(item!.media_image_url!),
              ),
            if (item?.media_image_url != null) SizedBox(height: MarginDimens.large),
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
            if (item?.media_image_url != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(item!.media_image_url!),
              ),
            if (item?.media_image_url != null) SizedBox(height: MarginDimens.large),
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

      case 'BEGINNER':
      default:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header,
            if (item?.media_image_url != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(item!.media_image_url!),
              ),
            if (item?.media_image_url != null) SizedBox(height: MarginDimens.large),
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
    }
  }

  Widget _buildProgress(ListeningController controller) {
    if (controller.contentList.isEmpty) return SizedBox.shrink();
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${'question'.tr} ${controller.currentContentIndex.value + 1} / ${controller.contentList.length}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade900,
            ),
          ),
          Text(
            '${((controller.currentContentIndex.value + 1) / controller.contentList.length * 100).toStringAsFixed(0)}%',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade700,
            ),
          ),
        ],
      ),
    );
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