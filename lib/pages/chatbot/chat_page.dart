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

  Future<void> _handleSend(ChatMessage message) async {
    setState(() {
      messages.insert(0, message);
      isTyping = true;
    });

    final reply = await _callGeminiAPI(message.text);

    final botMessage = ChatMessage(
      user: bot,
      createdAt: DateTime.now(),
      text: reply,
      // id: Uuid().v4(),
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

    // 🔹 Biến đổi toàn bộ hội thoại thành định dạng Gemini hiểu
    final contents = messages.reversed.map((msg) {
      return {
        "role": msg.user.id == "user" ? "user" : "model",
        "parts": [
          {"text": msg.text}
        ]
      };
    }).toList();

    // 🔹 Thêm câu hỏi mới vào cuối
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
        title: Text("ES-GPT", style: TextStyle(color : TextColors.appBar)),
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
        inputOptions:  InputOptions(
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

