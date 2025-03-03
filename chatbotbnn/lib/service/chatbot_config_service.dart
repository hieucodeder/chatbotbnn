import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:chatbotbnn/service/app_config.dart';
import 'package:chatbotbnn/model/chatbot_config.dart';

Future<List<DataConfig>> fetchChatbotConfig(String chatbotCode) async {
  try {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrlBasic}chatbot-config/get-chatbot-config'),
      headers: await ApiConfig.getHeaders(),
      body: jsonEncode({'chatbot_code': chatbotCode}),
    );

    if (response.statusCode == 200) {
      String responseBody = response.body.trim(); // Xóa khoảng trắng đầu/cuối
      debugPrint("📥 JSON từ API: ${responseBody.length} ký tự");

      // Kiểm tra nếu dữ liệu phản hồi bị rỗng hoặc là HTML lỗi từ server
      if (responseBody.isEmpty ||
          responseBody.startsWith('<!DOCTYPE') ||
          responseBody.startsWith('<html')) {
        throw Exception('❌ Phản hồi không hợp lệ hoặc lỗi từ server.');
      }

      // Kiểm tra JSON có dấu kết thúc hợp lệ
      if (!(responseBody.startsWith('{') || responseBody.startsWith('['))) {
        throw Exception('❌ Dữ liệu không phải JSON hợp lệ.');
      }

      try {
        final decodedJson = jsonDecode(responseBody);

        if (decodedJson is! Map<String, dynamic>) {
          throw Exception('❌ JSON không đúng cấu trúc mong đợi.');
        }

        final chatbotConfig = ChatbotConfig.fromJson(decodedJson);
        final result = chatbotConfig.data ?? [];

        return result;
      } on FormatException catch (jsonError) {
        debugPrint("❌ JSON không hợp lệ: $jsonError");
        debugPrint("📄 Nội dung JSON lỗi: $responseBody");
        throw Exception('❌ Lỗi giải mã JSON.');
      }
    } else {
      throw Exception(
          '❌ Lỗi HTTP ${response.statusCode}: ${response.reasonPhrase}');
    }
  } catch (e) {
    debugPrint("❌ Lỗi xử lý: $e");
    return [];
  }
}
