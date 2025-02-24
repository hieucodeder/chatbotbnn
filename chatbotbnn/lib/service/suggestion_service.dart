import 'dart:convert';
import 'package:chatbotbnn/model/body_suggestion.dart';
import 'package:chatbotbnn/model/suggestion_respone_model.dart';
import 'package:chatbotbnn/service/app_config.dart';
import 'package:http/http.dart' as http;

Future<List<String>?> fetchSuggestions(BodySuggestion body) async {
  final String apiUrl = '${ApiConfig.baseUrl}get-suggest-questions';

  try {
    final String requestBody = jsonEncode(body.toJson()); // Encode đúng dữ liệu
    final Map<String, String> headers = await ApiConfig.getHeaders();

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: requestBody,
    );

    print(response.body);

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      SuggestionResponeModel suggestionResponse =
          SuggestionResponeModel.fromJson(responseData);

      return suggestionResponse.data?.suggestions
          ?.map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();
    } else {
      print("Lỗi API: \${response.statusCode} - \${response.body}");
      return null;
    }
  } catch (e) {
    print("Lỗi kết nối API: \$e");
    return null;
  }
}
