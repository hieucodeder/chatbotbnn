import 'dart:convert';
import 'package:chatbotbnn/model/body_chatbot_answer.dart';
import 'package:chatbotbnn/model/body_suggestion.dart';
import 'package:chatbotbnn/service/app_config.dart';
import 'package:chatbotbnn/service/suggestion_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<String?> fetchApiResponsePqNew(
  BodyChatbotAnswer chatbotRequest,
  void Function(void Function()) setState,
  List<Map<String, dynamic>> messages,
  Function? onExtraDataReceived,
) async {
  final String apiUrl = '${ApiConfig.baseUrl}chatbot-answer';

  try {
    final requestBody = json.encode(chatbotRequest.toJson());
    final Map<String, String> headers = await ApiConfig.getHeaders();

    var client = http.Client();
    var request = http.Request('POST', Uri.parse(apiUrl))
      ..headers.addAll(headers)
      ..body = requestBody;

    var streamedResponse = await client.send(request);
    StringBuffer fullContent = StringBuffer();
    // String fullContent = '';
    StringBuffer buffer = StringBuffer();

    await for (var data in streamedResponse.stream.transform(utf8.decoder)) {
      debugPrint('Raw response data: $data');

      buffer.write(data);
      List<String> parts = buffer.toString().split('\n');
      StringBuffer fullContent =
          StringBuffer(); // 🔹 Thay đổi từ String -> StringBuffer

      for (var part in parts) {
        if (part.startsWith('event: info')) {
          continue; // Bỏ qua event label, chỉ xử lý `data:`
        }

        if (part.startsWith('data:')) {
          String strData = part.replaceFirst('data:', '').trim();

          if (!strData.contains("extraData") && !strData.contains("DONE")) {
            try {
              var jsonData = json.decode(strData);

              // Map<String, dynamic> jsonData = json.decode(strData);
              if (jsonData is Map<String, dynamic> &&
                  jsonData.containsKey('choices')) {
                for (var choice in jsonData['choices']) {
                  if (choice is Map<String, dynamic> &&
                      choice.containsKey('delta')) {
                    String? content = choice['delta']['content'];
                    if (content != null && content.isNotEmpty) {
                      fullContent.write(content);

                      setState(() {
                        if (messages.isEmpty || messages[0]['type'] != 'bot') {
                          messages.insert(0, {'type': 'bot', 'text': ''});
                        }
                        messages[0]['text'] =
                            fullContent.toString(); // 🔹 Cập nhật nội dung
                      });
                    }
                  }
                }
              }
            } catch (e) {
              debugPrint('Lỗi xử lý JSON: $e');
            }
          }
        }
      }
    }
    // // Gọi hàm fetchSuggestions sau khi phản hồi chatbot hoàn thành
    // if (fullContent.isNotEmpty) {
    //   BodySuggestion bodySuggestion = BodySuggestion(
    //     query: chatbotRequest.query,
    //     prompt: "Sinh gợi ý dựa trên phản hồi chatbot",
    //     genmodel: "gpt-4o-mini",
    //   );

    //   List<String>? suggestions = await fetchSuggestions(bodySuggestion);
    //   if (suggestions != null && suggestions.isNotEmpty) {
    //     setState(() {
    //       messages.add({'type': 'suggestion', 'text': suggestions.join("\n")});
    //     });
    //   }
    // }

    return fullContent.toString().isNotEmpty ? fullContent.toString() : null;
  } catch (e) {
    debugPrint('Error: $e');
    return null;
  }
}
