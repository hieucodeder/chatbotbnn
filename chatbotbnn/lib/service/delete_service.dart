import 'dart:convert';
import 'package:chatbotbnn/service/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:chatbotbnn/model/body_history.dart';
import 'package:chatbotbnn/model/delete_model.dart';

Future<DeleteModel> fetchChatHistoryDelete(String historyId) async {
  final String apiUrl = '${ApiConfig.baseUrlHistory}delete-chatbot-history';

  // Create a BodyHistory object with the dynamic historyId value
  final bodyHistory = BodyHistory(history: historyId);

  // Convert BodyHistory object to JSON format
  final body = jsonEncode(bodyHistory.toJson());

  // Get headers for the request
  final Map<String, String> headers = await ApiConfig.getHeaders();

  try {
    // Send the HTTP POST request to the server
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: body, // Pass the BodyHistory as the request body
    );

    // Handle the response based on status code
    if (response.statusCode == 200) {
      // If the request is successful, parse the response
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      print(response.body); // For debugging purposes
      return DeleteModel.fromJson(responseData); // Return the parsed DeleteModel
    } else {
      // If the status code is not 200, throw an exception with the error
      throw Exception('Failed to delete chat history. Status code: ${response.statusCode}');
    }
  } catch (e) {
    // Handle any errors that might occur during the HTTP request
    throw Exception('Error occurred while deleting chat history: $e');
  }
}
