class Passage {
  final String id;
  final String title;  // Tiêu đề đoạn văn (optional)
  final String content;  // Nội dung đoạn văn
  final List<Question> questions;  // List 2-3 câu hỏi

  Passage({
    required this.id,
    required this.title,
    required this.content,
    required this.questions,
  });
}

class Question {
  final String id;
  final String text;  // Nội dung câu hỏi
  final List<Option> options;  // 4 đáp án
  final int correctOptionIndex;  // Index của đáp án đúng (0-3)

  Question({
    required this.id,
    required this.text,
    required this.options,
    required this.correctOptionIndex,
  });
}

class Option {
  final String text;
  final bool isCorrect;

  Option({required this.text, required this.isCorrect});
}