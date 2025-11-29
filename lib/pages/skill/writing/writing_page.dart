import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../cores/widgets/base_app_bar.dart';
import '../../../cores/widgets/base_page.dart';
import 'writing_controller.dart';

class WritingPage extends StatelessWidget {
  const WritingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final WritingController controller = Get.find();

    return BasePage(
      isLoading: controller.isLoadingQuestion,
      appBar: BaseAppBar(title: 'Writing Exercise'),
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

              // Title
              Text(question.title ?? 'No Title',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)),
              SizedBox(height: 16),

              // Image
              if (question.media_image_url != null && question.media_image_url!.isNotEmpty)
                _buildImage(question.media_image_url!),
              if (question.media_image_url != null && question.media_image_url!.isNotEmpty) SizedBox(height: 16),

              // Body Text
              _buildBodyText(question.body_text),
              SizedBox(height: 16),

              // Question Text
              if (question.question_text != null && question.question_text!.isNotEmpty)
                _buildQuestionText(question.question_text!),
              if (question.question_text != null && question.question_text!.isNotEmpty) SizedBox(height: 24),

              // Your Answer
              _buildAnswerInput(controller),
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

  Widget _buildProgress(WritingController controller) {
    if (controller.contentIds.isEmpty) return SizedBox.shrink();
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Question ${controller.currentIndex + 1} of ${controller.contentIds.length}',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue.shade900)),
          Text('${((controller.currentIndex + 1) / controller.contentIds.length * 100).toStringAsFixed(0)}%',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue.shade700)),
        ],
      ),
    );
  }

  Widget _buildSingleQuestionNote() {
    return Center(
      child: Text("Chỉ có 1 câu hỏi trong chủ đề này.",
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

  Widget _buildBodyText(String? text) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300)),
      child: Text(text ?? 'No body text provided.',
          style: TextStyle(fontSize: 16, height: 1.5, color: Colors.black87)),
    );
  }

  Widget _buildQuestionText(String text) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blue.shade200, width: 1.5)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: Colors.blue.shade700, size: 24),
          SizedBox(width: 12),
          Expanded(
            child: Text(text,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.blue.shade900, height: 1.4)),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerInput(WritingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Icon(Icons.edit_note, color: Colors.blue),
          SizedBox(width: 8),
          Text('Your Answer:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue.shade900)),
        ]),
        SizedBox(height: 12),
        TextField(
          controller: controller.textEditingController,
          onChanged: (v) => controller.userAnswer = v,
          enabled: !controller.hasAnsweredCurrent.value,
          decoration: InputDecoration(
            hintText: "Enter your answer here...",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.blue, width: 2)),
            filled: true,
            fillColor: controller.hasAnsweredCurrent.value ? Colors.grey.shade100 : Colors.white,
            contentPadding: EdgeInsets.all(16),
          ),
          maxLines: 6,
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  // Trong _buildActionButtons, thay đổi phần cuối:

  Widget _buildActionButtons(WritingController controller) {
    return Obx(() {
      final hasScore = controller.score.value != null;
      final isLast = controller.currentIndex == controller.contentIds.length - 1;
      final canNext = controller.currentIndex < controller.contentIds.length - 1;

      if (!hasScore) {
        return SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: controller.isCheckingAnswer.value || controller.hasAnsweredCurrent.value
                ? null
                : () => controller.checkAnswer(controller.userAnswer),
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: controller.isCheckingAnswer.value
                ? SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.check_circle_outline),
              SizedBox(width: 8),
              Text("Check Answer", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ]),
          ),
        );
      } else {
        return Column(children: [
          if (canNext)
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: controller.isLoadingQuestion.value ? null : controller.nextQuestion,
                icon: Icon(Icons.arrow_forward),
                label: Text("Next Question"),
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
                onPressed: controller.finishTopic, // THAY ĐỔI TÊN HÀM
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle),
                    SizedBox(width: 8),
                    Text("Finish Topic", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), // THAY ĐỔI TEXT
                  ],
                ),
              ),
            ),
        ]);
      }
    });
  }

  Widget _buildFeedback(WritingController controller) {
    return Obx(() {
      if (controller.score.value == null) return SizedBox.shrink();
      return Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.blue.shade50, Colors.blue.shade100], begin: Alignment.topLeft, end: Alignment.bottomRight),
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
              Text('Your Score', style: TextStyle(fontSize: 14, color: Colors.grey.shade700)),
              Text('${controller.score.value}/10', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.blue.shade900)),
            ]),
          ]),
          SizedBox(height: 20),
          Divider(color: Colors.blue.shade300),
          SizedBox(height: 16),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(Icons.comment, color: Colors.blue.shade700),
            SizedBox(width: 8),
            Text('Feedback:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue.shade900)),
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