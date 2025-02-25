import 'dart:convert';
import 'package:chatbotbnn/model/body_forget_password.dart';
import 'package:chatbotbnn/model/respone_forgetpassword.dart';
import 'package:chatbotbnn/service/app_config.dart';
import 'package:http/http.dart' as http;

Future<ResponeForgetpassword> forgetPassword(BodyForgetPassword body) async {
  final String apiUrl = '${ApiConfig.baseUrlBasic}users/change-password';
  final Map<String, String> headers = await ApiConfig.getHeaders();

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: jsonEncode(body.toJson()), // Chuyển object thành JSON
    );

    if (response.statusCode == 200) {
      return ResponeForgetpassword.fromJson(jsonDecode(response.body));
    } else {
      return ResponeForgetpassword(
        message: "Lỗi: ${response.statusCode}",
        results: false,
      );
    }
  } catch (error) {
    return ResponeForgetpassword(
      message: "Lỗi kết nối: $error",
      results: false,
    );
  }
}
