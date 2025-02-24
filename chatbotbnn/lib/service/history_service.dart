import 'dart:convert';
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
            String message = contentJson['message'] ?? '';

            // Loại bỏ chuỗi "!pie!bar" khỏi text
            message = message.replaceAll('!pie!bar', '').trim();

            List<dynamic> imageUrls = [];

            if (contentJson.containsKey('images') &&
                contentJson['images'] is List) {
              imageUrls = List<String>.from(contentJson['images']);
            }

            final RegExp imageRegex = RegExp(r'!\[.*?\]\((.*?)\)');
            final matches = imageRegex.allMatches(message);

            for (var match in matches) {
              if (match.group(1) != null) {
                imageUrls.add(match.group(1)!);
                message = message.replaceAll(match.group(0)!, '');
              }
            }

            return {
              'text': message,
              'table': (contentJson['table'] as List?)
                  ?.map((item) => (item as Map<String, dynamic>))
                  .toList(),
              'imageStatistic': imageUrls.toSet().toList(),
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
