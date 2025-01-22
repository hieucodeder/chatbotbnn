import 'dart:convert';
import 'package:chatbotbnn/model/body_login.dart';
import 'package:chatbotbnn/model/login_model.dart';
import 'package:chatbotbnn/service/app_config.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

class LoginService {
  Future<Map<String, dynamic>?> login(BodyLogin loginData) async {
    final url = Uri.parse('${ApiConfig.baseUrlBasic}users/login');

    final Map<String, String> headers = await ApiConfig.getHeaders();

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode(loginData.toJson()),
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        LoginModel account = LoginModel.fromJson(jsonResponse);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userid', account.userId!);
        await prefs.setString('username', account.username!);
        await prefs.setString('email', account.email!);
        await prefs.setString('token', account.token!);

        return {
          'account': account,
          'token': account.token,
        };
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  // getAccountFullNameAndUsername function
  Future<Map<String, String>?> getAccountFullNameAndUsername() async {
    final prefs = await SharedPreferences.getInstance();

    final userId = prefs.getString('userid');
    final userName = prefs.getString('username');
    final email = prefs.getString('email');

    if (userId == null || userName == null && email == null) {
      return null;
    }

    return {
      'username': userName ?? '', // Return default text if null
      'email': email ?? 'Không có email', // Return default text if null
    };
  }
}
