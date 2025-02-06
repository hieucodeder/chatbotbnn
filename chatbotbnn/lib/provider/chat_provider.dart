import 'package:chatbotbnn/provider/chatbot_provider.dart';
import 'package:chatbotbnn/service/chatbot_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatProvider with ChangeNotifier {
  List<Map<String, String>> _messages = [];
  String? _initialMessage;

  Future<void> loadInitialMessage(BuildContext context) async {
    final chatbotCode =
        Provider.of<ChatbotProvider>(context, listen: false).currentChatbotCode;

    if (chatbotCode != null) {
      final chatbotData = await fetchGetCodeModel(chatbotCode);
      if (chatbotData != null) {
        _initialMessage = chatbotData.initialMessages;
        _messages.add({
          'type': 'bot',
          'text': _initialMessage ?? 'Lỗi',
          'image': 'resources/logo_smart.png',
        });
        notifyListeners(); // Cập nhật UI
      }
    }
  }
}
