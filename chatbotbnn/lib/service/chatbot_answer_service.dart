// import 'dart:convert';
// import 'package:chatbotbnn/model/body_chatbot_answer.dart';
// import 'package:chatbotbnn/model/chatbot_answer_model.dart';
// import 'package:chatbotbnn/service/app_config.dart';
// import 'package:http/http.dart' as http;

// Future<ChatbotAnswerModel?> fetchApiResponse(
//     BodyChatbotAnswer chatbotRequest) async {
//   final String apiUrl = '${ApiConfig.baseUrl}chatbot-statistic-answer';

//   try {
//     final requestBody = json.encode(chatbotRequest.toJson());
//     final Map<String, String> headers = await ApiConfig.getHeaders();

//     final response = await http.post(
//       Uri.parse(apiUrl),
//       headers: headers,
//       body: requestBody,
//     );
//     print(response.body);

//     if (response.statusCode == 200) {
//       final Map<String, dynamic> jsonResponse = json.decode(response.body);

//       // Kiểm tra nếu JSON có chứa `suggestions`
//       if (jsonResponse.containsKey('data') &&
//           jsonResponse['data'].containsKey('suggestions')) {}

//       return ChatbotAnswerModel.fromJson(jsonResponse);
//     } else {
//       final Map<String, dynamic> errorResponse = json.decode(response.body);
//       if (errorResponse['message'] == 'Chatbot Code not found') {
//         print("Chatbot Code not found");
//       }
//       return null;
//     }
//   } catch (e) {
//     print('Error: $e');
//     return null;
//   }
// }
