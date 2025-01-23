import 'dart:convert';
import 'package:chatbotbnn/service/app_config.dart';
import 'package:http/http.dart' as http;

import 'package:chatbotbnn/model/body_history.dart';
import 'package:chatbotbnn/model/history_model.dart';

Future<HistoryModel> fetchChatHistory(String historyId) async {
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
    return HistoryModel.fromJson(
        responseData); // Map the response to HistoryModel
  } else {
    // If the server returns an error, throw an exception
    throw Exception('Failed to load chat history');
  }
}
