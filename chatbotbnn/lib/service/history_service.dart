import 'dart:convert';
import 'package:chatbotbnn/model/chatbot_answer_model.dart';
import 'package:chatbotbnn/service/app_config.dart';
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

            // Trích xuất history từ content nếu có
            List<dynamic>? historyList = contentJson['history'];
            if (historyList != null) {
              tempHistory = historyList.map((item) {
                return {
                  'turn': item['turn'],
                  'query': item['query'],
                  'answer': item['answer'],
                  'intents': item['intents']
                };
              }).toList();
            }

            return {
              'text': contentJson['message'] ?? '',
              'table': (contentJson['table'] as List?)
                  ?.map((item) => (item as Map<String, dynamic>))
                  .toList(),
              'imageStatistic': (contentJson['images'] as List?)
                  ?.map((img) => ImageStatistic.fromJson(img))
                  .toList(),
            };
          } else {
            return {
              'text': e.content ?? '',
              'table': null,
              'imageStatistic': null,
            };
          }
        }).toList() ??
        [];

    print("Lịch sử hội thoại: $tempHistory"); // Debug dữ liệu lưu lại

    return result;
  } else {
    throw Exception('Failed to load chat history');
  }
}
