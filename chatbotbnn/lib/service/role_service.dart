import 'dart:convert';
import 'package:chatbotbnn/model/body_role.dart';
import 'package:chatbotbnn/model/role_model.dart';
import 'package:chatbotbnn/service/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<RoleModel?> fetchRoles(BodyRole bodyRole) async {
  final String apiUrl = '${ApiConfig.baseUrl}search-by-role';
  try {
    final String body = jsonEncode(bodyRole.toJson());

    final Map<String, String> headers = await ApiConfig.getHeaders();

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      RoleModel roleModel = RoleModel.fromJson(responseData);

      final prefs = await SharedPreferences.getInstance();

      // Check if the data list is not empty and set the chatbotName from the first item
      if (roleModel.data != null && roleModel.data!.isNotEmpty) {
        String chatbotName =
            roleModel.data!.first.chatbotName ?? 'Default Chatbot Name';
        await prefs.setString('chatbot_name', chatbotName);
      } else {
        // Handle cases where the data list is null or empty
        await prefs.setString('chatbot_name', 'Default Chatbot Name');
      }

      return roleModel;
    } else {
      return null;
    }
  } catch (e) {
    // Handle any exceptions and return null
    return null;
  }
}
