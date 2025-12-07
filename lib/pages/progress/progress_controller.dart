import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/progress/progress_response_model.dart';
import 'progress_repository.dart';

class ProgressController extends GetxController {
  final ProgressRepository _repository = ProgressRepository();

  final RxBool isLoading = false.obs;
  final RxBool isLoadingSuggestion = false.obs;
  final RxBool isLoadingProgressItems = false.obs; // Loading riêng cho progress items
  final RxBool isLoadingMockTests = false.obs; // Loading riêng cho mock tests

  final Rx<ProgressResponseModel?> progressData = Rx<ProgressResponseModel?>(null);
  final RxString aiSuggestion = ''.obs;
  final RxBool showAllMockTests = false.obs;
  final RxBool showAllProgress = false.obs;

  // Trạng thái hiển thị sections
  final RxBool isProgressItemsExpanded = false.obs;
  final RxBool isMockTestsExpanded = false.obs;

  // Cached computed values
  final RxList<SkillSummary> _cachedSkillsSummary = <SkillSummary>[].obs;
  final RxList<ProgressItem> _cachedProgressItems = <ProgressItem>[].obs;
  final RxList<MockTest> _cachedMockTests = <MockTest>[].obs;
  final RxInt _cachedTotalAttempts = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadInitialProgress();
  }

  // Getters cho cached data
  List<SkillSummary> get skillsSummary => _cachedSkillsSummary;
  List<ProgressItem> get progressItems => _cachedProgressItems;
  List<MockTest> get mockTests => _cachedMockTests;
  int get totalAttempts => _cachedTotalAttempts.value;

  // Computed values
  int get totalScore => progressData.value?.totalUserScore ?? 0;
  double get studyTimeInMinutes => (progressData.value?.studyTime?.total7Days ?? 0) / 60;
  bool get hasData => _cachedSkillsSummary.isNotEmpty;
  bool get hasMockTests => _cachedMockTests.isNotEmpty;
  bool get hasProgressItems => _cachedProgressItems.isNotEmpty;

  // Mock tests hiển thị
  List<MockTest> get displayedMockTests {
    if (showAllMockTests.value || _cachedMockTests.length <= 3) {
      return _cachedMockTests;
    }
    return _cachedMockTests.take(3).toList();
  }

  int get hiddenMockTestsCount =>
      _cachedMockTests.length > 3 ? _cachedMockTests.length - 3 : 0;

  // Progress items hiển thị
  List<ProgressItem> get displayedProgressItems {
    if (showAllProgress.value || _cachedProgressItems.length <= 4) {
      return _cachedProgressItems;
    }
    return _cachedProgressItems.take(4).toList();
  }

  int get hiddenProgressItemsCount =>
      _cachedProgressItems.length > 4 ? _cachedProgressItems.length - 4 : 0;

  void toggleShowAllMockTests() {
    showAllMockTests.value = !showAllMockTests.value;
  }

  void toggleShowAllProgress() {
    showAllProgress.value = !showAllProgress.value;
  }

  // Load dữ liệu ban đầu (chỉ summary data)
  Future<void> loadInitialProgress() async {
    isLoading.value = true;
    try {
      final data = await _repository.getMyProgress();
      progressData.value = data;

      // Cache chỉ skills summary và stats
      _cacheInitialData();
    } catch (e) {
      print("❌ Error loading initial progress: $e");
      Get.snackbar(
        'Error',
        'Failed to load progress data',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Cache dữ liệu ban đầu (không bao gồm progress items và mock tests)
  // void _cacheInitialData() {
  //   final data = progressData.value;
  //   if (data == null) {
  //     _cachedSkillsSummary.clear();
  //     return;
  //   }
  //
  //   // Chỉ cache skills summary cho pie chart và stats
  //   _cachedSkillsSummary.value = data.skillsSummary ?? [];
  // }
  void _cacheInitialData() {
    final data = progressData.value;
    if (data == null) {
      _cachedSkillsSummary.clear();
      return;
    }

    _cachedSkillsSummary.value = data.skillsSummary ?? [];

    // ✔ Tính tổng attempts cho stats ngay khi load trang
    if (data.progress != null) {
      _cachedTotalAttempts.value = data.progress!.fold<int>(
        0,
            (sum, item) => sum + (item.totalAttempts?.toInt() ?? 0),
      );
    }
  }

  // Load progress items khi người dùng bấm "Xem"
  Future<void> loadProgressItems() async {
    if (isProgressItemsExpanded.value) {
      // Nếu đã mở rồi thì đóng lại
      isProgressItemsExpanded.value = false;
      return;
    }

    if (_cachedProgressItems.isNotEmpty) {
      // Nếu đã có data rồi thì chỉ cần toggle
      isProgressItemsExpanded.value = true;
      return;
    }

    isLoadingProgressItems.value = true;
    try {
      final data = progressData.value;
      if (data != null) {
        _cachedProgressItems.value = data.progress ?? [];

        // Cache total attempts
        _cachedTotalAttempts.value = _cachedProgressItems.fold<int>(
          0,
              (sum, item) => sum + (item.totalAttempts?.toInt() ?? 0),
        );

        isProgressItemsExpanded.value = true;
      }
    } catch (e) {
      print("❌ Error loading progress items: $e");
      Get.snackbar(
        'Error',
        'Failed to load learning progress',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoadingProgressItems.value = false;
    }
  }

  // Load mock tests khi người dùng bấm "Xem"
  Future<void> loadMockTests() async {
    if (isMockTestsExpanded.value) {
      // Nếu đã mở rồi thì đóng lại
      isMockTestsExpanded.value = false;
      return;
    }

    if (_cachedMockTests.isNotEmpty) {
      // Nếu đã có data rồi thì chỉ cần toggle
      isMockTestsExpanded.value = true;
      return;
    }

    isLoadingMockTests.value = true;
    try {
      final data = progressData.value;
      if (data != null) {
        _cachedMockTests.value = data.mockTests ?? [];
        isMockTestsExpanded.value = true;
      }
    } catch (e) {
      print("❌ Error loading mock tests: $e");
      Get.snackbar(
        'Error',
        'Failed to load mock test history',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoadingMockTests.value = false;
    }
  }

  // Refresh toàn bộ data
  Future<void> refreshAllData() async {
    isLoading.value = true;
    try {
      final data = await _repository.getMyProgress();
      progressData.value = data;

      // Clear và reload tất cả cache
      _cachedSkillsSummary.value = data.skillsSummary ?? [];

      if (isProgressItemsExpanded.value) {
        _cachedProgressItems.value = data.progress ?? [];
        _cachedTotalAttempts.value = _cachedProgressItems.fold<int>(
          0,
              (sum, item) => sum + (item.totalAttempts?.toInt() ?? 0),
        );
      }

      if (isMockTestsExpanded.value) {
        _cachedMockTests.value = data.mockTests ?? [];
      }
    } catch (e) {
      print("❌ Error refreshing progress: $e");
      Get.snackbar(
        'Error',
        'Failed to refresh progress data',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Pie chart colors
  final List<Color> pieChartColors = const [
    Color(0xFF4285F4), // Blue - Listening
    Color(0xFF34A853), // Green - Reading
    Color(0xFFFBBC04), // Yellow - Speaking
    Color(0xFFEA4335), // Red - Writing
  ];

  // Tính total score cho pie chart
  int get pieChartTotalScore {
    return _cachedSkillsSummary.fold<int>(
      0,
          (sum, skill) => sum + (skill.totalPoint ?? 0),
    );
  }

  // Get skill percentage cho pie chart
  int getSkillPercentage(SkillSummary skill) {
    final total = pieChartTotalScore;
    if (total == 0) return 0;
    return ((skill.totalPoint ?? 0) / total * 100).round();
  }

  // Get skill display name
  String getSkillDisplayName(String code) {
    switch (code.toUpperCase()) {
      case 'LISTENING':
        return 'Listening';
      case 'READING':
        return 'Reading';
      case 'SPEAKING':
        return 'Speaking';
      case 'WRITING':
        return 'Writing';
      default:
        return code;
    }
  }

  // Get skill name in Vietnamese
  String getSkillNameVi(String code) {
    switch (code.toUpperCase()) {
      case 'LISTENING':
        return 'Nghe';
      case 'READING':
        return 'Đọc';
      case 'SPEAKING':
        return 'Nói';
      case 'WRITING':
        return 'Viết';
      default:
        return code;
    }
  }

  // Format date cho mock test
  String formatMockTestDate(String? dateString) {
    if (dateString == null) return 'Unknown date';

    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateString;
    }
  }

  // Calculate mock test correct percentage
  int getMockTestCorrectPercent(MockTest mockTest) {
    if (mockTest.totalQuestionsTest == null || mockTest.totalQuestionsTest! == 0) {
      return 0;
    }
    return ((mockTest.testCorrect ?? 0) / mockTest.totalQuestionsTest! * 100).round();
  }

  void onTapContinue(ProgressItem item) {
    Get.snackbar(
      'Continue',
      'Continuing ${item.skillName} - ${item.topicDetails?.title}',
      snackPosition: SnackPosition.BOTTOM,
    );
    // TODO: Navigate to lesson detail
  }

  Future<void> getAISuggestion() async {
    if (progressData.value == null) {
      Get.snackbar(
        'Lỗi',
        'Không có dữ liệu tiến độ',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoadingSuggestion.value = true;
    aiSuggestion.value = '';

    const apiKey = "yourAPIKey";
    final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-lite:generateContent?key=$apiKey');

    final data = progressData.value!;

    // Tạo summary với cached data
    String progressSummary = _buildProgressSummary(data);

    String prompt = '''
Bạn là chuyên gia tư vấn học tiếng Anh. Dựa vào tiến độ học tập sau, hãy đưa ra gợi ý lộ trình học ngắn gọn (3-5 điểm chính):

$progressSummary

Yêu cầu:
1. Phân tích điểm mạnh/yếu dựa trên avg_progress_percent và số câu đã hoàn thành (1-2 câu)
2. Đề xuất kỹ năng cần ưu tiên (kỹ năng có progress thấp nhất hoặc số câu chưa làm nhiều nhất) (1-2 câu)
3. Gợi ý hành động cụ thể dựa trên dữ liệu thực tế (2-3 điểm)
4. Động viên ngắn gọn (1 câu)

Trả về bằng tiếng Việt, văn phong thân thiện, súc tích.
KHÔNG sử dụng bất kỳ định dạng markdown nào (** , ## , * , - , số thứ tự, v.v.). Chỉ dùng văn bản thuần túy và xuống dòng bình thường.
''';

    final body = {
      "contents": [
        {
          "parts": [
            {"text": prompt}
          ]
        }
      ],
      "generationConfig": {
        "temperature": 0.7,
        "topK": 40,
        "topP": 0.95,
        "maxOutputTokens": 512,
      }
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      print("AI Suggestion API Status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final text = responseData['candidates']?[0]?['content']?['parts']?[0]?['text'] ?? '';

        if (text.isNotEmpty) {
          aiSuggestion.value = text.trim();
        } else {
          aiSuggestion.value = 'AI không thể tạo gợi ý lúc này. Vui lòng thử lại sau.';
        }
      } else {
        throw Exception("API Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error getting AI suggestion: $e");
      aiSuggestion.value = 'Không thể kết nối với AI. Vui lòng thử lại sau.';
      Get.snackbar(
        "Lỗi",
        "Không thể lấy gợi ý từ AI: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
      );
    } finally {
      isLoadingSuggestion.value = false;
    }
  }

  String _buildProgressSummary(ProgressResponseModel data) {
    // Load progress items nếu chưa có để tạo summary cho AI
    if (_cachedProgressItems.isEmpty && data.progress != null) {
      _cachedProgressItems.value = data.progress!;
    }

    // Load mock tests nếu chưa có
    if (_cachedMockTests.isEmpty && data.mockTests != null) {
      _cachedMockTests.value = data.mockTests!;
    }

    return '''
=== TỔNG QUAN ===
- Tổng số câu hỏi: ${data.totalUserQuestions ?? 0}
- Tổng điểm: ${data.totalUserScore ?? 0}
- Thời gian học (7 ngày): ${studyTimeInMinutes.toStringAsFixed(0)} phút

=== KỸ NĂNG ===
${_cachedSkillsSummary.map((s) {
      final avgProgress = (s.avgProgressPercent ?? 0).toStringAsFixed(1);
      return '- ${getSkillNameVi(s.skill ?? '')}: ${s.totalDone}/${s.totalQuestionsSkillAllTopics} câu (${s.totalPoint} điểm) - Tiến độ: $avgProgress%';
    }).join('\n')}

=== CHI TIẾT HỌC TẬP (Top 5 chủ đề gần nhất) ===
${_cachedProgressItems.take(5).map((p) {
      final topicTitle = p.topicDetails?.title ?? 'Unknown';
      return '- ${p.skillName} (${p.level}): $topicTitle\n  + Hoàn thành: ${p.correctCount}/${p.totalQuestionsTopic} câu (${p.progressPercent}%)\n  + Điểm: ${p.point}';
    }).join('\n')}

=== MOCK TESTS ===
${_cachedMockTests.take(3).map((m) => '- ${m.testTitle}: ${m.testCorrect}/${m.totalQuestionsTest} đúng (${m.testScore} điểm)').join('\n')}
''';
  }
}