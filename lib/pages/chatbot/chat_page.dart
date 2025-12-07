import 'package:es_english/cores/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'dart:convert';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatUser user = ChatUser(id: "user", firstName: "You");
  final ChatUser bot = ChatUser(id: "bot", firstName: "ES-GPT");

  List<ChatMessage> messages = [];
  bool isTyping = false;

  /// Hàm loại bỏ các ký tự đặc biệt markdown từ text
  String _cleanMarkdown(String text) {
    String cleaned = text;

    // Loại bỏ bold markdown (**text** hoặc __text__)
    cleaned = cleaned.replaceAll(RegExp(r'\*\*(.+?)\*\*'), r'$1');
    cleaned = cleaned.replaceAll(RegExp(r'__(.+?)__'), r'$1');

    // Loại bỏ italic markdown (*text* hoặc _text_)
    cleaned = cleaned.replaceAll(RegExp(r'\*(.+?)\*'), r'$1');
    cleaned = cleaned.replaceAll(RegExp(r'_(.+?)_'), r'$1');

    // Loại bỏ heading markdown (# ## ###)
    cleaned = cleaned.replaceAll(RegExp(r'^#{1,6}\s+', multiLine: true), '');

    // Loại bỏ code block backticks (```code```)
    cleaned = cleaned.replaceAll(RegExp(r'```[\s\S]*?```'), '');
    cleaned = cleaned.replaceAll(RegExp(r'`(.+?)`'), r'$1');

    // Loại bỏ bullet points markdown (- * +)
    cleaned = cleaned.replaceAll(RegExp(r'^[\*\-\+]\s+', multiLine: true), '• ');

    // Loại bỏ link markdown [text](url)
    cleaned = cleaned.replaceAll(RegExp(r'\[(.+?)\]\(.+?\)'), r'$1');

    // Loại bỏ các ký tự đặc biệt còn lại
    cleaned = cleaned.replaceAll(RegExp(r'[~`]'), '');

    return cleaned.trim();
  }

  Future<void> _handleSend(ChatMessage message) async {
    setState(() {
      messages.insert(0, message);
      isTyping = true;
    });

    final reply = await _callGeminiAPI(message.text);

    // Clean markdown trước khi hiển thị
    final cleanedReply = _cleanMarkdown(reply);

    final botMessage = ChatMessage(
      user: bot,
      createdAt: DateTime.now(),
      text: cleanedReply,
    );

    setState(() {
      messages.insert(0, botMessage);
      isTyping = false;
    });
  }

  Future<String> _callGeminiAPI(String prompt) async {
    const apiKey = "yourAPIKey";
    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-lite:generateContent?key=$apiKey',
    );

    // Biến đổi toàn bộ hội thoại thành định dạng Gemini hiểu
    final contents = messages.reversed.map((msg) {
      return {
        "role": msg.user.id == "user" ? "user" : "model",
        "parts": [
          {"text": msg.text}
        ]
      };
    }).toList();

    // Thêm câu hỏi mới vào cuối
    contents.add({
      "role": "user",
      "parts": [
        {"text": prompt}
      ]
    });

    final body = {"contents": contents};

    try {
      final res = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      final data = jsonDecode(res.body);
      return data['candidates']?[0]?['content']?['parts']?[0]?['text']
          ?? "Bot không hiểu được câu này.";
    } catch (e) {
      return "Lỗi: $e";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ES-GPT", style: TextStyle(color: TextColors.appBar)),
        backgroundColor: BgColors.appBar,
      ),
      body: DashChat(
        currentUser: user,
        messages: messages,
        onSend: _handleSend,
        typingUsers: isTyping ? [bot] : [],
        messageOptions: const MessageOptions(
          currentUserContainerColor: Colors.blueAccent,
          currentUserTextColor: Colors.white,
          containerColor: Color(0xFFE3EDF3),
        ),
        inputOptions: InputOptions(
          alwaysShowSend: true,
          inputDecoration: InputDecoration(
            hintText: "enter_message".tr,
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(10),
          ),
        ),
      ),
    );
  }
}