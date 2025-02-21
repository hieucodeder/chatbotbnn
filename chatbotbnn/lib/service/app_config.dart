import 'package:shared_preferences/shared_preferences.dart';

class ApiConfig {
  static const String domain = 'https://bnn.aiacademy.edu.vn';

  static const String _defaultDomain = 'https://bnn.aiacademy.edu.vn';

  static String get baseUrlBasic {
    return '$domain/api/';
  }

  static String get baseUrl {
    return '$domain/api/chatbot/';
  }

  static String get baseUrlHistory {
    return '$domain/api/chatbot-history/';
  }

  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<Map<String, String>> getHeaders() async {
    String? token = await getToken();
    return {
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
  }
}
