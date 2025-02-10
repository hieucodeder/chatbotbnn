import 'dart:convert';
import 'package:chatbotbnn/model/chatbot_answer_model.dart';
import 'package:chatbotbnn/service/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:chatbotbnn/model/body_history.dart';
import 'package:chatbotbnn/model/history_model.dart';

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

    return historyModel.data?.map((e) {
          if (e.messageType == 'answer') {
            final contentJson = jsonDecode(e.content ?? '{}');
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
  } else {
    throw Exception('Failed to load chat history');
  }
}
