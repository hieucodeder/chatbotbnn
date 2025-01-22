import 'dart:convert';
import 'package:chatbotbnn/model/body_chatbot_answer.dart';
import 'package:chatbotbnn/model/chatbot_answer_model.dart';
import 'package:chatbotbnn/service/app_config.dart';
import 'package:http/http.dart' as http;

Future<ChatbotAnswerModel?> fetchApiResponse(
    BodyChatbotAnswer chatbotRequest) async {
  // Corrected API URL (missing closing curly bracket in the URL string)
  final String apiUrl = '${ApiConfig.baseUrl}chatbot-answer';

  try {
    // Encode the request body using the toJson() method from BodyChatbotAnswer
    final requestBody = json.encode(chatbotRequest.toJson());

    // Log the request body for debugging
    print('Request Body: $requestBody');

    // Get headers from the ApiConfig
    final Map<String, String> headers = await ApiConfig.getHeaders();

    // Sending the POST request
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: requestBody,
    );

    // Check the response status
    if (response.statusCode == 200) {
      // Decode and log the response body for debugging
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      // Parse and return the response model
      return ChatbotAnswerModel.fromJson(jsonResponse);
    } else {
      final Map<String, dynamic> errorResponse = json.decode(response.body);

      // Handle specific error response
      if (errorResponse['message'] == 'Chatbot Code not found') {
        // You can handle specific logic here if needed
      }
      return null;
    }
  } catch (e) {
    print('Error: $e');
    return null;
  }
}
