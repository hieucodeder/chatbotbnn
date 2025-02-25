import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:chatbotbnn/service/app_config.dart';
import 'package:chatbotbnn/model/chatbot_config.dart';

Future<List<DataConfig>> fetchChatbotConfig(String chatbotCode) async {
  final response = await http.post(
    Uri.parse('${ApiConfig.baseUrlBasic}chatbot-config/get-chatbot-config'),
    headers: await ApiConfig.getHeaders(),
    body: jsonEncode({'chatbot_code': chatbotCode}),
  );

  if (response.statusCode == 200) {
    final chatbotConfig = ChatbotConfig.fromJson(jsonDecode(response.body));
    final result = chatbotConfig.data ?? [];

    debugPrint(
        "✅ Cấu hình chatbot: ${jsonEncode(result.map((e) => e.toJson()).toList())}");
    return result;
  } else {
    throw Exception('❌ Lỗi khi tải cấu hình chatbot');
  }
}
