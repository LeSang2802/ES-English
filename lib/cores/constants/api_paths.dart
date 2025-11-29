class ApiPaths {
  /// Auth
  static const String login = "/api/auth/login";
  static const String register = "/api/auth/register";
  static const String sendCode = "/api/auth/send-code";
  static const String verifyCode = "/api/auth/verify";
  static const String profile = "/api/users/profile";
  static const String resetPassword = "/api/auth/change-password";

  /// skill / level / topic
  static const String skill = "/api/admin/catalog/Skills";
  static const String level = "/api/admin/catalog/Levels";
  static const String topic = "/api/admin/catalog/topics";

  /// Vocabulary / Flashcard / SaveWord
  static const String flashcard = "/api/vocab/flashcards";
  static const String saveWord = "/api/vocab/saved-words";
  static const String savedWordToggle = "/api/vocab/saved-words/toggle";

  /// Lấy nội dung bài học
  static const String content = "/api/admin/content";

  /// Các API Attempt, Result
  static const String attemptStart = "/api/attempts/start";
  static const String attemptAnswer = "/api/attempts/answer";
  static const String attemptSubmit = "/api/attempts/submit";
  static const String reciveResult = "/api/results";

  /// Lấy tiến độ
  static const String progress = "/api/attempts/me/progress";

  /// Study time
  static const String studyTime = "/api/time";

  /// Test / Mock Test
  static const String test = "/api/admin/tests";
  static const String testAnswerMulti = "/api/admin/tests/answer-multi";
  static const String testSubmit = "/api/admin/tests/submit";

}
