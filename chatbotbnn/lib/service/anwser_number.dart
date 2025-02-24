import 'dart:convert';
import 'package:chatbotbnn/model/answer_model_pqnew.dart';
import 'package:chatbotbnn/model/body_chatbot_answer.dart';
import 'package:chatbotbnn/service/app_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<String?> fetchApiResponseNumber(
  BodyChatbotAnswer chatbotRequest,
  void Function(void Function()) setState,
  List<Map<String, dynamic>> messages,
  Function? onExtraDataReceived,
) async {
  final String apiUrl = '${ApiConfig.baseUrl}chatbot-statistic-answer';

  try {
    final requestBody = json.encode(chatbotRequest.toJson());
    final Map<String, String> headers = await ApiConfig.getHeaders();

    var client = http.Client();
    var request = http.Request('POST', Uri.parse(apiUrl))
      ..headers.addAll(headers)
      ..body = requestBody;

    var streamedResponse = await client.send(request);
    StringBuffer fullContent = StringBuffer();
    StringBuffer buffer = StringBuffer();
    bool tableflag = false;
    bool suggestionFlag = false;
    await for (var data in streamedResponse.stream.transform(utf8.decoder)) {
      buffer.write(data);
      List<String> parts = buffer.toString().split('\n');
      buffer.clear();

      for (var part in parts) {
        if (part.startsWith('event: table')) {
          tableflag = true;
          continue;
        }
        if (part.startsWith('event: suggestion')) {
          suggestionFlag = true;
          continue;
        }

        if (part.startsWith('data:')) {
          String strData = part.replaceFirst('data:', '').trim();
          if (strData.isEmpty || strData == "[DONE]") continue;

          try {
            var decodedData = json.decode(strData);
            print("📥 Raw API Data: $strData"); // Kiểm tra dữ liệu thô từ API

            print('Dữ liệu API trả về: $decodedData');

            if (tableflag) {
              try {
                Map<String, dynamic> parsedJson;

                if (decodedData is Map<String, dynamic>) {
                  parsedJson = decodedData;
                } else if (decodedData is List &&
                    decodedData.isNotEmpty &&
                    decodedData.first is Map<String, dynamic>) {
                  // Nếu là danh sách chứa ít nhất một Map, giả định nó là bảng
                  parsedJson = {'table': decodedData};
                } else {
                  throw Exception('Dữ liệu không hợp lệ: $decodedData');
                }

                var answerModel = AnswerModelPqnew.fromJson(parsedJson);

                // Xử lý bảng (table)
                if (answerModel.table != null &&
                    answerModel.table!.isNotEmpty) {
                  print('📊 Đây là dữ liệu API bảng: ${answerModel.table}');

                  setState(() {
                    messages.insert(
                        0, {'type': 'table', 'data': answerModel.table});
                  });

                  onExtraDataReceived?.call({'table': answerModel.table});
                }
              } catch (e, stacktrace) {
                print('🚨 Lỗi khi parse dữ liệu API: $e');
                print(stacktrace);
              } finally {
                tableflag = false; // Đảm bảo đặt lại flag
              }
            }

            if (suggestionFlag) {
              Map<String, dynamic> parsedJson =
                  decodedData is Map<String, dynamic>
                      ? decodedData
                      : {'suggestion': decodedData};
              var answerModel = AnswerModelPqnew.fromJson(parsedJson);
              // Xử lý gợi ý (suggestion)
              if (answerModel.suggestions != null &&
                  answerModel.suggestions!.isNotEmpty) {
                print('Đây là dữ liệu Api gợi ý: ${answerModel.suggestions}');
                setState(() {
                  messages.insert(0,
                      {'type': 'suggestion', 'data': answerModel.suggestions});
                });
                onExtraDataReceived
                    ?.call({'suggestion': answerModel.suggestions});
              }
              suggestionFlag = false;
            }
            // if (decodedData.containsKey('choices')) {
            //   for (var choice in decodedData['choices']) {
            //     if (choice is Map<String, dynamic> &&
            //         choice.containsKey('delta')) {
            //       String? content = choice['delta']['content'];
            //       if (content != null && content.isNotEmpty) {
            //         fullContent.write(content);

            //         setState(() {
            //           // Kiểm tra nếu nội dung có chứa Markdown ảnh
            //           RegExp regex = RegExp(r"!\[(.*?)\]\((.*?)\)");
            //           var match = regex.firstMatch(content);

            //           if (match != null) {
            //             String imageType =
            //                 match.group(1)!; // Lấy loại ảnh (pie, bar,...)
            //             String imageUrl = match.group(2)!; // Lấy URL ảnh

            //             // Kiểm tra nếu ảnh là dạng thống kê (pie chart, bar chart, etc.)
            //             if (["pie", "bar", "line"]
            //                 .contains(imageType.toLowerCase())) {
            //               messages.insert(
            //                   0, {'type': 'imageStatistic', 'url': imageUrl});
            //             } else {
            //               messages.insert(
            //                   0, {'type': 'imageStatistic', 'url': imageUrl});
            //             }
            //           }
            //         });
            //       }
            //     }
            //   }
            // }

            // Xử lý nội dung chatbot (choices)
            if (decodedData is Map<String, dynamic> &&
                decodedData.containsKey('choices')) {
              for (var choice in decodedData['choices']) {
                if (choice is Map<String, dynamic> &&
                    choice.containsKey('delta') &&
                    choice['delta'] is Map<String, dynamic>) {
                  String? content = choice['delta']['content'];

                  if (content != null && content.isNotEmpty) {
                    fullContent.write(content);

                    setState(() {
                      // Kiểm tra nếu có ảnh trong nội dung
                      RegExp regex = RegExp(r"!\[(.*?)\]\((.*?)\)");
                      Iterable<RegExpMatch> matches = regex.allMatches(content);

                      List<String> imageUrls = [];
                      String textContent = content; // Giữ lại phần văn bản

                      for (var match in matches) {
                        String imageUrl = match.group(2)!;
                        imageUrls.add(imageUrl);

                        // Xóa Markdown ảnh khỏi văn bản
                        textContent =
                            textContent.replaceAll(match.group(0)!, '');
                      }

                      if (imageUrls.isNotEmpty) {
                        messages.insert(0, {
                          'type': 'imageStatistic',
                          'imageStatistic': imageUrls,
                        });
                      }

                      if (textContent.trim().isNotEmpty) {
                        if (messages.isEmpty || messages[0]['type'] != 'bot') {
                          messages
                              .insert(0, {'type': 'bot', 'text': textContent});
                        }
                        messages[0]['text'] =
                            fullContent.toString(); // 🔹 Cập nhật nội dung
                      }
                    });
                  }
                }
              }
            }
          } catch (e) {
            debugPrint('🚨 JSON Parse Error: $e\nData received: $strData');
          }
        }
      }
    }

    return fullContent.toString().isNotEmpty ? fullContent.toString() : null;
  } catch (e) {
    debugPrint('❌ Error: $e');
    return null;
  }
}
