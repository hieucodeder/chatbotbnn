import 'dart:convert';
import 'package:chatbotbnn/model/body_history_all.dart';
import 'package:chatbotbnn/model/history_all_model.dart';
import 'package:chatbotbnn/service/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<HistoryAllModel> fetchChatHistoryAll(
    String? chatbotCode, String? startDate, String? endDate) async {
  // Define the API URL
  final String apiUrl = '${ApiConfig.baseUrlHistory}/get-chatbot-history';

  try {
    // Retrieve the userId from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString('userid');

    if (userId == null || userId.isEmpty) {
      throw Exception('User ID is not available in SharedPreferences');
    }

    // Create BodyHistory object
    final bodyHistory = BodyHistoryAll(
      chatbotCode: chatbotCode,
      startDate: startDate,
      endDate: endDate,
      userId: userId,
    );

    // Serialize BodyHistory to JSON
    final String body = jsonEncode(bodyHistory.toJson());

    // Get request headers
    final Map<String, String> headers = await ApiConfig.getHeaders();

    // Make the POST request
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: body,
    );

    // Parse the response body to HistoryAllModel
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    HistoryAllModel historyAllModel = HistoryAllModel.fromJson(responseData);

    // Lưu chatbotHistoryId vào SharedPreferences ngay sau khi nhận phản hồi
    if (historyAllModel.data != null && historyAllModel.data!.isNotEmpty) {
      final chatbotHistoryId = historyAllModel.data![0].chatbotHistoryId ?? 0;
      await prefs.setInt('chatbot_history_id', chatbotHistoryId);
    }

    // Kiểm tra response thành công
    if (response.statusCode == 200) {
      return historyAllModel;
    } else {
      final String errorMessage = 'Failed to fetch chat history. '
          'Status code: ${response.statusCode}, Body: ${response.body}';
      throw Exception(errorMessage);
    }
  } catch (e) {
    throw Exception('An error occurred while fetching chat history: $e');
  }
}
