import 'dart:convert';
import 'package:chatbotbnn/model/body_chatbot_answer.dart';
import 'package:chatbotbnn/model/body_suggestion.dart';
import 'package:chatbotbnn/service/app_config.dart';
import 'package:chatbotbnn/service/suggestion_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

String? temporaryData;
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
    bool isInstructionSaved = false; // 🔹 Biến trạng thái, ban đầu là false

    StringBuffer fullContent = StringBuffer();
    // String fullContent = '';
    StringBuffer buffer = StringBuffer();
    StringBuffer temporaryStorage = StringBuffer(); // Lưu hướng dẫn tạm thời

    await for (var data in streamedResponse.stream.transform(utf8.decoder)) {
      debugPrint('Raw response data: $data');

      buffer.write(data);
      List<String> parts = buffer.toString().split('\n');
      StringBuffer fullContent = StringBuffer();

      for (var part in parts) {
        if (part.startsWith('event:')) {
          continue;
        }

        if (part.startsWith('data:')) {
          String strData = part.replaceFirst('data:', '').trim();
          // 🔹 Lưu hướng dẫn vào bộ nhớ tạm thay vì bỏ qua

          if (!isInstructionSaved &&
              (strData.contains("-Goal-") ||
                  strData.contains("-Step-") ||
                  strData.contains("-Input-"))) {
            temporaryStorage.write(strData + "\n"); // 🔹 Lưu lại hướng dẫn
            debugPrint(
                '📌 Hướng dẫn được lưu:\n${temporaryStorage.toString()}'); // 🔥 In nội dung đã lưu

            isInstructionSaved = true; // 🔹 Đánh dấu đã lưu, không lưu lại nữa
          }

          if (!strData.contains("extraData") && !strData.contains("DONE")) {
            if (strData.startsWith('')) {
              // Chỉ decode nếu là JSON

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
                          if (messages.isEmpty ||
                              messages[0]['type'] != 'bot') {
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
    }
    // 🔹 Trả về cả nội dung và hướng dẫn đã lưu
    temporaryData = temporaryStorage.toString();
    return fullContent.toString().isNotEmpty ? fullContent.toString() : null;
  } catch (e) {
    debugPrint('Error: $e');
    return null;
  }
}
