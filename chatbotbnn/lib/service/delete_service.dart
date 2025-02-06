import 'dart:convert';
import 'package:chatbotbnn/model/body_history_delete.dart';
import 'package:chatbotbnn/service/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:chatbotbnn/model/delete_model.dart';

Future<DeleteModel> fetchChatHistoryDelete(int historyId) async {
  final String apiUrl = '${ApiConfig.baseUrlHistory}delete-chatbot-history';

  final bodyHistory = BodyHistoryDelete(history: historyId);
  final body = jsonEncode(bodyHistory.toJson());

  // Lấy token từ ApiConfig
  final Map<String, String> headers = await ApiConfig.getHeaders();

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      print(response.body); // In ra phản hồi JSON
      return DeleteModel.fromJson(responseData); // Trả về DeleteModel
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized: Please check your authentication token.');
    } else {
      throw Exception(
          'Failed to delete chat history. Status code: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error occurred while deleting chat history: $e');
  }
}
