import 'package:chatbotbnn/model/chatbot_config.dart';
import 'package:chatbotbnn/service/chatbot_config_service.dart';
import 'package:flutter/material.dart';

class ConfigChatProvider extends ChangeNotifier {
  DataConfig? _chatbotConfig;
  bool _isLoading = false;

  DataConfig? get chatbotConfig => _chatbotConfig;
  bool get isLoading => _isLoading;

  Future<void> loadChatbotConfig(String chatbotCode) async {
    _isLoading = true;
    notifyListeners();

    try {
      List<DataConfig> chatbotConfigList = await fetchChatbotConfig(chatbotCode);

      if (chatbotConfigList.isEmpty) {
        throw Exception('❌ Không tìm thấy cấu hình chatbot.');
      }

      _chatbotConfig = chatbotConfigList.first;
    } catch (error) {
      debugPrint("❌ Lỗi khi tải cấu hình chatbot: $error");
      _chatbotConfig = null;
    }

    _isLoading = false;
    notifyListeners();
  }
}
