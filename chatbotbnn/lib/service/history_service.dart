import 'dart:convert';
import 'package:chatbotbnn/model/chatbot_answer_model.dart';
import 'package:chatbotbnn/service/app_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:chatbotbnn/model/body_history.dart';
import 'package:chatbotbnn/model/history_model.dart';

List<Map<String, dynamic>> tempHistory = []; // Mảng toàn cục lưu history

Future<List<Map<String, dynamic>>> fetchChatHistory(String historyId) async {
  final String apiUrl = '${ApiConfig.baseUrlHistory}get-chatbot-messages';

  final bodyHistory = BodyHistory(history: historyId);
  final body = jsonEncode(bodyHistory.toJson());
  final Map<String, String> headers = await ApiConfig.getHeaders();

  final response = await http.post(
    Uri.parse(apiUrl),
    headers: headers,
    body: body,
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    final historyModel = HistoryModel.fromJson(responseData);

    tempHistory.clear();

    final List<Map<String, dynamic>> result = historyModel.data?.map((e) {
          if (e.messageType == 'answer') {
            final contentJson = jsonDecode(e.content ?? '{}');

            // Trích xuất danh sách ảnh nếu có
            List<String> imageUrls = [];
            if (contentJson.containsKey('images') &&
                contentJson['images'] is List) {
              imageUrls = List<String>.from(contentJson['images']);
            }

            return {
              'text': contentJson['message'] ?? '',
              'table': (contentJson['table'] as List?)
                  ?.map((item) => (item as Map<String, dynamic>))
                  .toList(),
              'imageStatistic': imageUrls, // Đảm bảo danh sách ảnh được trả về
            };
          } else {
            return {
              'text': e.content ?? '',
              'table': null,
              'imageStatistic': [],
            };
          }
        }).toList() ??
        [];

    debugPrint("✅ Lịch sử trò chuyện: ${jsonEncode(result)}");

    return result;
  } else {
    throw Exception('Failed to load chat history');
  }
}
