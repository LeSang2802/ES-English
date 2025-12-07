import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../../cores/widgets/base_app_bar.dart';
import '../../../cores/widgets/base_page.dart';
import 'speaking_controller.dart';

class SpeakingPage extends StatefulWidget {
  const SpeakingPage({super.key});

  @override
  State<SpeakingPage> createState() => _SpeakingPageState();
}

class _SpeakingPageState extends State<SpeakingPage> with TickerProviderStateMixin {
  final AudioPlayer _audioPlayer = AudioPlayer();
  var isPlayingAudio = false.obs;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _audioPlayer.onPlayerStateChanged.listen((state) {
      isPlayingAudio.value = state == PlayerState.playing;
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _playAudio(String url) async {
    if (isPlayingAudio.value) {
      await _audioPlayer.stop();
    } else {
      await _audioPlayer.play(UrlSource(url));
    }
  }

  @override
  Widget build(BuildContext context) {
    final SpeakingController controller = Get.find();

    return BasePage(
      isLoading: controller.isLoadingQuestion,
      appBar: BaseAppBar(title: 'Speaking Exercise'),
      body: Obx(() {
        if (controller.isLoadingQuestion.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final question = controller.question.value;
        if (question == null) {
          return _buildNoQuestion();
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProgress(controller),
              SizedBox(height: 12),
              if (controller.contentIds.length == 1) _buildSingleQuestionNote(),
              SizedBox(height: 20),

              // Title - Hiển thị body_text
              Text(question.body_text ?? 'No instruction provided.',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)),
              SizedBox(height: 16),

              // Image
              if (question.media_image_url != null && question.media_image_url!.isNotEmpty)
                _buildImage(question.media_image_url!),
              if (question.media_image_url != null && question.media_image_url!.isNotEmpty)
                SizedBox(height: 16),

              // Body Text - Hiển thị question_text
              _buildQuestionText(controller),
              SizedBox(height: 16),

              // Audio Player (if available)
              if (question.media_audio_url != null && question.media_audio_url!.isNotEmpty)
                _buildAudioPlayer(question.media_audio_url!),
              if (question.media_audio_url != null && question.media_audio_url!.isNotEmpty)
                SizedBox(height: 24),

              // Recording Section
              _buildRecordingSection(controller),
              SizedBox(height: 24),

              // Action Buttons
              _buildActionButtons(controller),
              SizedBox(height: 24),

              // Feedback
              _buildFeedback(controller),
              SizedBox(height: 20),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildNoQuestion() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.warning_amber_rounded, size: 64, color: Colors.orange),
          SizedBox(height: 16),
          Text('No question available.', style: TextStyle(fontSize: 16)),
          SizedBox(height: 16),
          ElevatedButton(onPressed: () => Get.back(), child: Text('Go Back')),
        ],
      ),
    );
  }

  Widget _buildProgress(SpeakingController controller) {
    if (controller.contentIds.isEmpty) return SizedBox.shrink();
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('${'question'.tr} ${controller.currentIndex + 1} / ${controller.contentIds.length}',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue.shade900)),
          Text('${((controller.currentIndex + 1) / controller.contentIds.length * 100).toStringAsFixed(0)}%',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue.shade700)),
        ],
      ),
    );
  }

  Widget _buildSingleQuestionNote() {
    return Center(
      child: Text('only_1_question'.tr,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 13, fontStyle: FontStyle.italic)),
    );
  }

  Widget _buildImage(String url) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        url,
        fit: BoxFit.cover,
        height: 200,
        width: double.infinity,
        errorBuilder: (_, __, ___) => Container(
          height: 200,
          color: Colors.grey.shade200,
          child: Center(child: Icon(Icons.broken_image, size: 48, color: Colors.grey)),
        ),
        loadingBuilder: (_, child, progress) => progress == null
            ? child
            : Container(
          height: 200,
          color: Colors.grey.shade200,
          child: Center(child: CircularProgressIndicator(value: progress.expectedTotalBytes != null
              ? progress.cumulativeBytesLoaded / progress.expectedTotalBytes!
              : null)),
        ),
      ),
    );
  }

  // Hiển thị question_text
  Widget _buildQuestionText(SpeakingController controller) {
    final question = controller.question.value;

    // Lấy question_text từ danh sách questions
    String displayText = question?.questions.isNotEmpty == true
        ? (question!.questions.first.question_text ?? 'No question text provided.')
        : 'No question text provided.';

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300)),
      child: Text(
        displayText,
        style: TextStyle(fontSize: 16, height: 1.5, color: Colors.black87),
      ),
    );
  }

  Widget _buildAudioPlayer(String audioUrl) {
    return Obx(() => Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple.shade50, Colors.purple.shade100],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.purple.shade300, width: 2),
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.purple,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(
                isPlayingAudio.value ? Icons.stop : Icons.play_arrow,
                color: Colors.white,
                size: 32,
              ),
              onPressed: () => _playAudio(audioUrl),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'audio_sample'.tr,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple.shade900,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  isPlayingAudio.value ? 'playing'.tr : 'tap_to_play'.tr,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.purple.shade700,
                  ),
                ),
              ],
            ),
          ),
          if (isPlayingAudio.value)
            Icon(Icons.graphic_eq, color: Colors.purple, size: 32),
        ],
      ),
    ));
  }

  Widget _buildRecordingSection(SpeakingController controller) {
    return Obx(() {
      final isRecording = controller.isRecording.value;
      final hasAnswered = controller.hasAnsweredCurrent.value;
      final isChecking = controller.isCheckingAnswer.value;

      return Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red.shade50, Colors.red.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.red.shade300, width: 2),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.mic, color: Colors.red.shade700, size: 28),
                SizedBox(width: 12),
                Text(
                  'your_speaking_answer'.tr,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red.shade900,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            if (isChecking)
              Column(
                children: [
                  CircularProgressIndicator(color: Colors.red),
                  SizedBox(height: 12),
                  Text(
                    'scoring'.tr,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.red.shade700,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              )
            else if (!hasAnswered)
              GestureDetector(
                onTap: isRecording ? controller.stopRecording : controller.startRecording,
                child: AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    return Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isRecording ? Colors.red : Colors.red.shade300,
                        boxShadow: isRecording
                            ? [
                          BoxShadow(
                            color: Colors.red.withOpacity(0.3 + _pulseController.value * 0.4),
                            blurRadius: 20 + _pulseController.value * 20,
                            spreadRadius: 5 + _pulseController.value * 10,
                          ),
                        ]
                            : [],
                      ),
                      child: Icon(
                        isRecording ? Icons.stop : Icons.mic,
                        size: 60,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              )
            else
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green, width: 2),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 32),
                    SizedBox(width: 12),
                    Text(
                      'completed'.tr,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade900,
                      ),
                    ),
                  ],
                ),
              ),

            if (!hasAnswered && !isChecking) ...[
              SizedBox(height: 16),
              Text(
                isRecording
                    ? 'press_to_stop'.tr
                    : 'click_on_the_microphone'.tr,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.red.shade700,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      );
    });
  }

  Widget _buildActionButtons(SpeakingController controller) {
    return Obx(() {
      final hasScore = controller.score.value != null;
      final canNext = controller.currentIndex < controller.contentIds.length - 1;

      if (!hasScore) {
        return SizedBox.shrink();
      } else {
        return Column(children: [
          if (canNext)
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: controller.isLoadingQuestion.value ? null : controller.nextQuestion,
                icon: Icon(Icons.arrow_forward),
                label: Text('next_question'.tr),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              ),
            ),
          if (!canNext)
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: controller.finishTopic,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle),
                    SizedBox(width: 8),
                    Text('finish_topic'.tr, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
        ]);
      }
    });
  }

  Widget _buildFeedback(SpeakingController controller) {
    return Obx(() {
      if (controller.score.value == null) return SizedBox.shrink();
      return Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.blue.shade50, Colors.blue.shade100],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.blue.shade300, width: 2),
          boxShadow: [BoxShadow(color: Colors.blue.shade100.withOpacity(0.5), blurRadius: 10, offset: Offset(0, 4))],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(color: _getScoreColor(controller.score.value!), shape: BoxShape.circle),
              child: Icon(_getScoreIcon(controller.score.value!), color: Colors.white, size: 32),
            ),
            SizedBox(width: 16),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('your_score'.tr, style: TextStyle(fontSize: 14, color: Colors.grey.shade700)),
              Text('${controller.score.value}/10',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.blue.shade900)),
            ]),
          ]),
          SizedBox(height: 20),
          Divider(color: Colors.blue.shade300),
          SizedBox(height: 16),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(Icons.comment, color: Colors.blue.shade700),
            SizedBox(width: 8),
            Text('feedback'.tr, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue.shade900)),
          ]),
          SizedBox(height: 8),
          Text(controller.comment.value ?? '', style: TextStyle(fontSize: 15, height: 1.6, color: Colors.black87)),
        ]),
      );
    });
  }

  Color _getScoreColor(int score) => score >= 8 ? Colors.green : score >= 5 ? Colors.orange : Colors.red;
  IconData _getScoreIcon(int score) => score >= 8 ? Icons.star : score >= 5 ? Icons.thumb_up : Icons.error_outline;
}