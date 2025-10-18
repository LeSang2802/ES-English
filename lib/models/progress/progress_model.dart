class SkillProgress {
  final String skill;        // Listening, Reading...
  final String level;        // beginner / intermediate / advanced
  final int completed;       // bài đã xong
  final int total;           // tổng bài
  final int percent;         // % tiến độ

  SkillProgress({
    required this.skill,
    required this.level,
    required this.completed,
    required this.total,
    required this.percent,
  });
}
