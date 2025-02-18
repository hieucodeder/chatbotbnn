import 'dart:convert';
import 'package:chatbotbnn/model/body_chatbot_answer.dart';
import 'package:chatbotbnn/model/answer_model_pq.dart'; // Đổi import sang AnswerModelPq
import 'package:chatbotbnn/service/app_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<AnswerModelPq?> fetchApiResponsePq(
    BodyChatbotAnswer chatbotRequest) async {
  final String apiUrl = '${ApiConfig.baseUrl}chatbot-answer';

  try {
    final requestBody = json.encode(chatbotRequest.toJson());
    final Map<String, String> headers = await ApiConfig.getHeaders();

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: requestBody,
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      // Kiểm tra nếu JSON có chứa `data`
      if (jsonResponse.containsKey('data')) {
        AnswerModelPq result = AnswerModelPq.fromJson(jsonResponse);
        debugPrint(result.data!.history?[0].answer);
        return AnswerModelPq.fromJson(jsonResponse);
      }
    } else {
      final Map<String, dynamic> errorResponse = json.decode(response.body);
      if (errorResponse['message'] == 'Chatbot Code not found') {
        print("Chatbot Code not found");
      }
    }
  } catch (e) {
    print('Error: $e');
  }
  return null;
}
