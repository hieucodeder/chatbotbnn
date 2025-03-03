import 'package:chatbotbnn/provider/chatbot_provider.dart';
import 'package:chatbotbnn/provider/historyid_provider.dart'; // Import HistoryidProvider
import 'package:chatbotbnn/service/chatbot_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatProvider with ChangeNotifier {
  List<Map<String, dynamic>> _messages = [];
  String? _initialMessage;

  List<Map<String, dynamic>> messages() {
    return _messages;
  }

  Future<void> loadInitialMessage(BuildContext context) async {
    final chatbotCode =
        Provider.of<ChatbotProvider>(context, listen: false).currentChatbotCode;
    final historyProvider =
        Provider.of<HistoryidProvider>(context, listen: false);

    if (chatbotCode != null) {
      final chatbotData = await fetchGetCodeModel(chatbotCode);
      _messages = [];
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

    // Đặt lại history_id thành ""
    historyProvider.resetHistoryId();
  }
}
