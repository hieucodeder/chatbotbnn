import 'dart:convert';

import 'package:chatbotbnn/model/get_historyid.dart';
import 'package:chatbotbnn/service/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<GetHistoryid?> fetchGetHistory() async {
  final prefs = await SharedPreferences.getInstance();
  final int? savedId = prefs.getInt('id');
  print('id: $savedId');
  if (savedId == null) {
    return null;
  }

  final String apiUrl =
      '${ApiConfig.baseUrlBasic}chatbot-message/get-by-id/$savedId';

  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      return GetHistoryid.fromJson(jsonData);
    } else {
      print("Failed to load data: ${response.statusCode}");
    }
  } catch (e) {
    print(" Error: $e");
  }
  return null;
}
