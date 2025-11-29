import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/progress/progress_response_model.dart';
import 'progress_repository.dart';

class ProgressController extends GetxController {
  final ProgressRepository _repository = ProgressRepository();

  final RxBool isLoading = false.obs;
  final RxBool isLoadingSuggestion = false.obs; // ← THÊM
  final Rx<ProgressResponseModel?> progressData = Rx<ProgressResponseModel?>(null);
  final RxString aiSuggestion = ''.obs; // ← THÊM

  @override
  void onInit() {
    super.onInit();
    loadProgress();
  }

  /// Load progress data từ API
  Future<void> loadProgress() async {
    isLoading.value = true;
    try {
      final data = await _repository.getMyProgress();
      progressData.value = data;
    } catch (e) {
      print("❌ Error loading progress: $e");
      Get.snackbar(
        'Error',
        'Failed to load progress data',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Lấy skills summary cho pie chart
  List<SkillSummary> get skillsSummary {
    return progressData.value?.skillsSummary ?? [];
  }

  /// Xử lý khi tap vào item
  void onTapContinue(ProgressItem item) {
    Get.snackbar(
      'Continue',
      'Continuing ${item.skillName} - ${item.topicTitle}',
      snackPosition: SnackPosition.BOTTOM,
    );
    // TODO: Navigate to lesson detail
  }

  // ============================================
  // HÀM GỌI AI ĐỂ GỢI Ý LỘ TRÌNH HỌC
  // ============================================
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

    // Tạo tóm tắt tiến độ
    final data = progressData.value!;
    final skills = skillsSummary;
    final progress = data.progress ?? [];

    String progressSummary = '''
=== TỔNG QUAN ===
- Tổng số bài làm: ${data.totalUserAttempts ?? 0}
- Tổng điểm: ${data.totalUserScore ?? 0}
- Thời gian học (7 ngày): ${((data.studyTime?.total7Days ?? 0) / 60).toStringAsFixed(0)} phút

=== KỸ NĂNG ===
${skills.map((s) => '- ${_getSkillName(s.skill ?? '')}: Điểm ${s.totalScore}, Tiến độ ${s.progressPercent}%').join('\n')}

=== CHI TIẾT HỌC TẬP ===
${progress.take(5).map((p) => '- ${p.skillName} (${p.level}): ${p.topicTitle} - Hoàn thành ${p.progressPercent}%').join('\n')}
''';

    String prompt = '''
Bạn là chuyên gia tư vấn học tiếng Anh. Dựa vào tiến độ học tập sau, hãy đưa ra gợi ý lộ trình học ngắn gọn (3-5 điểm chính):

$progressSummary

Yêu cầu:
1. Phân tích điểm mạnh/yếu (1-2 câu)
2. Đề xuất kỹ năng cần ưu tiên (1-2 câu)
3. Gợi ý hành động cụ thể (2-3 điểm)
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

  String _getSkillName(String code) {
    switch (code.toUpperCase()) {
      case 'LISTENING': return 'Nghe';
      case 'READING': return 'Đọc';
      case 'SPEAKING': return 'Nói';
      case 'WRITING': return 'Viết';
      default: return code;
    }
  }
}