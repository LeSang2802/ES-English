class HomeContinue {
  final String skillId;      // ex: reading
  final String skillName;    // ex: Reading
  final String levelId;      // ex: beginner
  final String levelName;    // ex: Beginner
  final int percent;         // 0..100

  HomeContinue({
    required this.skillId,
    required this.skillName,
    required this.levelId,
    required this.levelName,
    required this.percent,
  });
}
