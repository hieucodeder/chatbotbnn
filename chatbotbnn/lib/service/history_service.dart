import 'dart:convert';
import 'package:chatbotbnn/service/app_config.dart';
import 'package:http/http.dart' as http;

import 'package:chatbotbnn/model/body_history.dart';
import 'package:chatbotbnn/model/history_model.dart';

Future<List<String>> fetchChatHistory(String historyId) async {
  final String apiUrl =
      '${ApiConfig.baseUrlBasic}chatbot-history/get-chatbot-messages';

  // Tạo BodyHistory với giá trị dynamic cho history
  final bodyHistory = BodyHistory(history: historyId);

  // Convert BodyHistory object to JSON format
  final body = jsonEncode(bodyHistory.toJson());
  final Map<String, String> headers = await ApiConfig.getHeaders();

  final response = await http.post(
    Uri.parse(apiUrl),
    headers: headers,
    body: body, // Pass the BodyHistory as the request body
  );

  if (response.statusCode == 200) {
    // If server returns a 200 OK response, parse the JSON
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    final historyModel = HistoryModel.fromJson(responseData);

    // Process each message in data and return a List<String>
    return historyModel.data
            ?.map((e) {
              if (e.messageType == 'answer') {
                // If the message type is 'answer', parse the JSON content
                final contentJson = jsonDecode(e.content ?? '{}');
                return contentJson['message'] ?? '';
              } else {
                // If it's a 'question', return the content directly
                return e.content ?? '';
              }
            })
            .toList()
            .cast<String>() ??
        []; // Cast to List<String>
  } else {
    // If the server returns an error, throw an exception
    throw Exception('Failed to load chat history');
  }
}
