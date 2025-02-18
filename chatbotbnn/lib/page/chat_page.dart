import 'package:chatbotbnn/model/answer_model_pq.dart';
import 'package:chatbotbnn/model/body_chatbot_answer.dart';
import 'package:chatbotbnn/model/chatbot_answer_model.dart';
import 'package:chatbotbnn/model/history_all_model.dart';
import 'package:chatbotbnn/model/history_model.dart';
import 'package:chatbotbnn/provider/chat_provider.dart';
import 'package:chatbotbnn/provider/chatbot_provider.dart';
import 'package:chatbotbnn/provider/historyid_provider.dart';
import 'package:chatbotbnn/provider/provider_color.dart';
import 'package:chatbotbnn/service/answer_pq_service.dart';
import 'package:chatbotbnn/service/chatbot_answer_service.dart';
import 'package:chatbotbnn/service/chatbot_service.dart';
import 'package:chatbotbnn/service/history_all_service.dart';
import 'package:chatbotbnn/service/history_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatPage extends StatefulWidget {
  final String historyId;

  const ChatPage({
    super.key,
    required this.historyId,
  });

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> _messages = [];
  String? _initialMessage;
  bool _isLoading = false;
  late HistoryidProvider _historyidProvider;
  ChatProvider? _chatProvider;
  List<String> _suggestions = [];

  @override
  void initState() {
    super.initState();
    // _loadInitialMessage();
    _historyidProvider = Provider.of<HistoryidProvider>(context, listen: false);
    _historyidProvider.addListener(fetchAndUpdateChatHistory);
    _chatProvider = Provider.of<ChatProvider>(context, listen: false);
    Provider.of<ChatProvider>(context, listen: false)
        .loadInitialMessage(context);
    // setState(() {
    //   _messages = Provider.of<ChatProvider>(context, listen: true).messages();
    // });
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _historyidProvider =
    //       Provider.of<HistoryidProvider>(context, listen: false);
    //   _historyidProvider.addListener(fetchAndUpdateChatHistory);

    //   _chatProvider = Provider.of<ChatProvider>(context, listen: false);
    // });
  }

  @override
  void dispose() {
    // stopPatrolling(context);
    _historyidProvider.removeListener(fetchAndUpdateChatHistory);
    super.dispose();
  }

  Future<void> _loadInitialMessage() async {
    final chatbotCode =
        Provider.of<ChatbotProvider>(context, listen: false).currentChatbotCode;

    if (chatbotCode != null) {
      final chatbotData = await fetchGetCodeModel(chatbotCode);
      if (chatbotData != null) {
        setState(() {
          _initialMessage = chatbotData.initialMessages;
          _messages = [];
          _messages.add({
            'type': 'bot',
            'text': _initialMessage ?? 'Lỗi',
            'image': 'resources/logo_smart.png',
          });
        });
      } else {}
    } else {}
  }

  void _sendMessage() async {
    final chatbotCode =
        Provider.of<ChatbotProvider>(context, listen: false).currentChatbotCode;
    final historyId =
        Provider.of<HistoryidProvider>(context, listen: false).chatbotHistoryId;
    if (chatbotCode == null) {
      return;
    }

    if (_controller.text.trim().isEmpty) {
      return;
    }

    String userQuery = _controller.text.trim();
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userid');
    String chatbotName =
        prefs.getString('chatbot_name') ?? 'Default Chatbot Name';

    if (userId == null) {
      return;
    }

    setState(() {
      _messages.insert(0, {'type': 'user', 'text': userQuery});
      _isLoading = true;
    });

    _controller.clear();

    bool isNewSession = historyId.isEmpty;
    String customizePrompt = "";
    String fallbackResponse = "";

    if (chatbotName.trim().toLowerCase() == "trợ lý ai thống kê số liệu") {
      customizePrompt =
          "-Goal-\nProvide necessary information about the legal base on some relevant context below. Because it is legal, it must be true and detailed.\n\n-Steps-\n1. Answer:\n- Understand and Address the User's Query with Precision\n\t+ If the query is a greeting or farewell, respond concisely and give them like that hỏi tôi về các thông tư, nghị định, nghị quyết, quyết định và báo cáo, tôi sẽ cung cấp thông tin chi tiết cho bạn bất cứ lúc nào!.\n    + Fully analyze the user's request without making assumptions beyond the provided context.\n\t+ If the query or context is insufficient for a complete answer, ask clarifying questions before proceeding.\n    + Utilize prior conversations for continuity.\n\t+ If process in query, show Image relevant to query in output.\n- Stay on Topic and Maintain Relevance\n\t+ If the requested information lacks sufficient context to answer accurately (strict adherence due to legal concerns), provide a fallback response to inform the user politely.\n- Communicate with Impact\n    + Create a compelling, well-structured, long-form response that captivates the analyst and enhances understanding.\n- References:\n\t+ IMPORTANT: Each claim, legal basis, or cited regulation must be accompanied by a reference tag **[1], [2], [3]...** in output and References.\n\t+ At the end of the response, include a **\"Tham khảo\"** section listing references corresponding to each tag.\n\t+ References should be as **detailed as possible**, including number of official legal documents, government sources, or reputable legal research.";
      // fallbackResponse = "Xin lỗi, tôi chưa có câu trả lời!";
    }
    if (chatbotName.trim().toLowerCase() == "trợ lý ai văn bản pháp quy") {
      customizePrompt =
          "-Goal-\nProvide necessary about legal base on some relevant context below. Because it is legal, so must true and detail.\n\n-Steps-\n1. Answer user command:\n- If the query is a greeting or farewell, respond concisely.\n- Thoroughly comprehend the user's command and the relevant context provided. Ensure no assumptions are made beyond the given information to make a response.\n- If the requested information has no context to answer user question (very strict because it's legal problem), use a fallback response to politely inform the user.\n- Answer politely, in detail, and drawing from context and old conversation.\n- Pair has image or table, show this when match with user command.\n- At the end of your response, include a detailed reference section listing all relevant legal documents (such as decrees, circulars, decisions, resolutions, etc.). For each document, provide the full title, document number, chapter, article, and section (if applicable) that are directly related to the context of the output (DON'T MAKE FABRICATE).\n- May ask user for deeper information they should ask or you unknow about user command.\n- Highlight important things that might be interesting.\n- Show table with chatgpt format if output need it.";
      // fallbackResponse =
      //     "Tôi chưa có câu trả lời cho câu hỏi $userQuery, hãy hỏi tôi về các thông tư, nghị định, quyết định và nghị quyết, tôi sẽ cung cấp thông tin chi tiết cho bạn bạn bất cứ lúc nào!";
    } else if (chatbotName.trim().toLowerCase() ==
        "trợ lý ai kinh tế hợp tác") {
      customizePrompt =
          "-Goal-\nProvide necessary information about the legal base on some relevant context below. Because it is legal, it must be true and detailed.\n\n-Steps-\n1. Answer:\n- Understand and Address the User's Query with Precision\n\t+ If the query is a greeting or farewell, respond concisely and give them like that hỏi tôi về các thông tư, nghị định, nghị quyết, quyết định và báo cáo, tôi sẽ cung cấp thông tin chi tiết cho bạn bất cứ lúc nào!.\n    + Fully analyze the user's request without making assumptions beyond the provided context.\n\t+ If the query or context is insufficient for a complete answer, ask clarifying questions before proceeding.\n    + Utilize prior conversations for continuity.\n\t+ If process in query, show Image relevant to query in output.\n- Stay on Topic and Maintain Relevance\n\t+ If the requested information lacks sufficient context to answer accurately (strict adherence due to legal concerns), provide a fallback response to inform the user politely.\n- Communicate with Impact\n    + Create a compelling, well-structured, long-form response that captivates the analyst and enhances understanding.\n- References:\n\t+ IMPORTANT: Each claim, legal basis, or cited regulation must be accompanied by a reference tag **[1], [2], [3]...** in output and References.\n\t+ At the end of the response, include a **\"Tham khảo\"** section listing references corresponding to each tag.\n\t+ References should be as **detailed as possible**, including number of official legal documents, government sources, or reputable legal research.";
      // fallbackResponse =
      //     "Tôi chưa có câu trả lời cho câu hỏi $userQuery, hãy hỏi tôi về các báo cáo, tôi sẽ cung cấp thông tin chi tiết cho bạn bạn bất cứ lúc nào!";
    }
    print("🔹 Lịch sử hội thoại trước khi gửi: $tempHistory");
    BodyChatbotAnswer chatbotRequest = BodyChatbotAnswer(
      chatbotCode: chatbotCode,
      chatbotName: chatbotName,
      collectionName: chatbotCode,
      customizePrompt: customizePrompt,
      fallbackResponse: fallbackResponse,
      genModel: "gpt-4o-mini",
      history: List.from(tempHistory),
      historyId: isNewSession ? "" : historyId,
      intentQueue: [],
      isNewSession: isNewSession,
      language: "Vietnamese",
      platform: "",
      query: userQuery,
      rerankModel: "gpt-4o-mini",
      rewriteModel: "gpt-4o-mini",
      slots: [],
      slotsConfig: [],
      systemPrompt:
          "You are a highly knowledgeable virtual assistant specializing in providing detailed and insightful answers to user questions across various fields. Your role is to interact with users in a friendly manner, ensure you understand their questions, and deliver the most relevant information.",
      temperature: 0,
      threadHold: 0.8,
      topCount: 3,
      type: "normal",
      userId: userId,
      userIndustry: "",
    );
    debugPrint("📢 Request Body: historyId=${chatbotRequest.toJson()}");

    try {
      ChatbotAnswerModel? response;
      AnswerModelPq? responsepq;

      if (chatbotName.trim().toLowerCase() == "trợ lý ai thống kê số liệu") {
        response = await fetchApiResponse(chatbotRequest);
      } else if ((chatbotName.trim().toLowerCase() ==
              "trợ lý ai văn bản pháp quy") ||
          chatbotName.trim().toLowerCase() == "trợ lý ai kinh tế hợp tác") {
        responsepq = await fetchApiResponsePq(chatbotRequest);
      }
      setState(() {
        _isLoading = false;
        if (response != null) {
          List<ImageStatistic>? images = response.data?.images;
          List<Map<String, dynamic>>? table = response.data?.table;

          _messages.insert(0, {
            'type': 'bot',
            'text': response.data!.message,
            'table': table,
            'imageStatistic': images,
          });

          var suggestions = response.data!.suggestions;
          _suggestions = suggestions ?? [];

          loadChatHistoryId(context, chatbotCode);
        } else if (responsepq != null) {
          _messages.insert(0, {
            'type': 'bot',
            'text': responsepq.data!.message,
          });
        } else {
          _messages.insert(0, {
            'type': 'bot',
            'text': 'Trợ lý AI không thể trả lời! ',
            'image': 'resources/logo_smart.png',
          });
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _messages.add({
          'type': 'bot',
          'text':
              'Đã xảy ra lỗi khi kết nối đến máy chủ. Vui lòng thử lại sau.',
          'image': 'resources/logo_smart.png',
        });
      });
    }
  }

  void loadChatHistoryId(BuildContext context, String chatbotCode) async {
    debugPrint("🔍 Starting loadChatHistoryId...");

    try {
      HistoryAllModel historyData =
          await fetchChatHistoryAll(chatbotCode, null, null);
      debugPrint("📥 Fetched history data: ${historyData.toJson()}");

      int? historyId = int.tryParse(
          Provider.of<HistoryidProvider>(context, listen: false)
              .chatbotHistoryId);

      if (historyId != null && historyId > 0) {
        Provider.of<HistoryidProvider>(context, listen: false)
            .setChatbotHistoryId(historyId.toString());
      } else {
        debugPrint("⚠ No valid history data found in Provider.");
      }
    } catch (e, stackTrace) {
      debugPrint("❌ Error in loadChatHistoryId: $e");
      debugPrint("🛑 StackTrace: $stackTrace");
    }
  }

  Future<void> fetchAndUpdateChatHistory() async {
    if (!mounted) return;

    // final historyId =
    //     Provider.of<HistoryidProvider>(context, listen: false).chatbotHistoryId;
    final historyId =
        Provider.of<HistoryidProvider>(context, listen: false).chatbotHistoryId;
    String historyIdStr = historyId?.toString() ?? "";

    try {
      List<Map<String, dynamic>> contents =
          await fetchChatHistory(historyIdStr);
      debugPrint("💬 Retrieved chat history: $historyId");

      if (!mounted) return;

      setState(() {
        _messages.clear();
        for (var content in contents) {
          _messages.insert(0, {
            'type': 'bot',
            'text': content['text'] ?? "",
            // 'image': 'resources/logo_smart.png',
            'table': content['table'] as List<Map<String, dynamic>>?,
            'imageStatistic':
                content['imageStatistic'] as List<ImageStatistic>?,
          });
        }
      });
    } catch (e, stackTrace) {
      debugPrint("❌ Error in fetchAndUpdateChatHistory: $e");
      debugPrint("🛑 StackTrace: $stackTrace");
    }
  }

// Helper function to parse the message
  List<TextSpan> _parseMessage(String message) {
    List<TextSpan> spans = [];
    RegExp regexBold = RegExp(r'\*\*(.*?)\*\*'); // In đậm thông thường
    RegExp regexItalic = RegExp(r'##(.*?)##'); // In nghiêng
    RegExp regexBoldLine =
        RegExp(r'###(.*?)###', multiLine: true); // In đậm cả dòng

    int lastIndex = 0;

    while (lastIndex < message.length) {
      // Kiểm tra in đậm cả dòng với ###
      var boldLineMatch =
          regexBoldLine.firstMatch(message.substring(lastIndex));
      if (boldLineMatch != null) {
        // Thêm phần trước nếu có
        if (boldLineMatch.start > 0) {
          spans.add(TextSpan(
              text: message.substring(
                  lastIndex, lastIndex + boldLineMatch.start)));
        }
        spans.add(TextSpan(
          text: boldLineMatch.group(1)! + "\n", // Thêm xuống dòng
          style: GoogleFonts.robotoCondensed(
              fontWeight: FontWeight.bold, fontSize: 18), // Kích thước lớn hơn
        ));
        lastIndex += boldLineMatch.end;
      } else {
        // Kiểm tra in nghiêng ##
        var italicMatch = regexItalic.firstMatch(message.substring(lastIndex));
        if (italicMatch != null) {
          if (italicMatch.start > 0) {
            spans.add(TextSpan(
                text: message.substring(
                    lastIndex, lastIndex + italicMatch.start)));
          }
          spans.add(TextSpan(
            text: italicMatch.group(1)!,
            style: GoogleFonts.robotoCondensed(fontStyle: FontStyle.italic),
          ));
          lastIndex += italicMatch.end;
        } else {
          // Kiểm tra in đậm **
          var boldMatch = regexBold.firstMatch(message.substring(lastIndex));
          if (boldMatch != null) {
            if (boldMatch.start > 0) {
              spans.add(TextSpan(
                  text: message.substring(
                      lastIndex, lastIndex + boldMatch.start)));
            }
            spans.add(TextSpan(
              text: boldMatch.group(1)!,
              style: GoogleFonts.robotoCondensed(fontWeight: FontWeight.bold),
            ));
            lastIndex += boldMatch.end;
          } else {
            // Nếu không có định dạng nào, thêm phần còn lại
            spans.add(TextSpan(text: message.substring(lastIndex)));
            break;
          }
        }
      }
    }
    return spans;
  }

  @override
  Widget build(BuildContext context) {
    final selectColors = Provider.of<Providercolor>(context).selectedColor;
    final textChatBot =
        GoogleFonts.robotoCondensed(fontSize: 14, color: Colors.black);
    final textChatbotTable = GoogleFonts.robotoCondensed(
        fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue);
    // _messages = _chatProvider!.messages();
    _messages = Provider.of<ChatProvider>(context).messages();
    return Container(
      constraints: const BoxConstraints.expand(),
      color: Colors.white,
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              reverse: false,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              itemBuilder: (context, index) {
                final message = _messages[_messages.length - 1 - index];

                final isUser = message['type'] == 'user';
                // final String? imageUrl = message['image'];
                List<Map<String, dynamic>>? table = message['table'];
                List<String> columns = [];
                if (table != null && table.isNotEmpty) {
                  columns = table.first.keys.toList();
                }

                return Row(
                  mainAxisAlignment:
                      isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // if (!isUser && message.containsKey('image'))r
                    //   CircleAvatar(
                    //     backgroundImage: imageUrl!.startsWith('http')
                    //         ? NetworkImage(imageUrl)
                    //         : AssetImage(imageUrl) as ImageProvider,
                    //     radius: 20,
                    //     backgroundColor: Colors.transparent,
                    //   ),
                    Flexible(
                      child: Column(
                        children: [
                          Visibility(
                            visible: message['text']?.isNotEmpty ?? false,
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: isUser ? selectColors : Colors.grey[300],
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(
                                      10), // Bo tròn góc trên trái
                                  bottomRight: Radius.circular(10),
                                ), // Bo tròn góc dưới phải
                              ),
                              child: Text.rich(
                                TextSpan(
                                  children: _parseMessage(message['text']!),
                                ),
                                style: GoogleFonts.robotoCondensed(
                                  fontSize: 15,
                                  color: isUser ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                          ),
                          if (table != null &&
                              table is List &&
                              (table as List<Map<String, dynamic>>).isNotEmpty)
                            SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  columns: [
                                    DataColumn(
                                      label: Text(
                                        "STT",
                                        style: textChatbotTable,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    ...columns.map((col) => DataColumn(
                                          label: Text(
                                            col,
                                            style: textChatbotTable,
                                            textAlign: TextAlign.center,
                                          ),
                                        ))
                                  ],
                                  rows: table!
                                      .asMap()
                                      .entries
                                      .map<DataRow>((entry) {
                                    int index = entry.key + 1; // Đánh số thứ tự
                                    Map<String, dynamic> row = entry.value;
                                    return DataRow(
                                      cells: [
                                        DataCell(
                                          SizedBox(
                                            width: 40,
                                            child: Center(
                                              child: Text(
                                                index.toString(),
                                                style: textChatBot,
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        ),
                                        ...columns.map((col) {
                                          var value = row[col];
                                          String displayValue;

                                          // Kiểm tra nếu giá trị là số thì làm tròn đến 2 chữ số thập phân
                                          if (value is double) {
                                            displayValue =
                                                value.toStringAsFixed(2);
                                          } else {
                                            displayValue = value.toString();
                                          }

                                          return DataCell(
                                            Center(
                                              child: Text(
                                                displayValue,
                                                style: textChatBot,
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          if (message['imageStatistic'] != null &&
                              (message['imageStatistic']
                                      as List<ImageStatistic>)
                                  .isNotEmpty)
                            ...(message['imageStatistic']
                                    as List<ImageStatistic>)
                                .map<Widget>((image) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (image.path != null)
                                    GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => Dialog(
                                            backgroundColor: Colors.transparent,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.9,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.7,
                                                child: PhotoView(
                                                  imageProvider:
                                                      NetworkImage(image.path!),
                                                  backgroundDecoration:
                                                      const BoxDecoration(
                                                          color: Colors.white),
                                                  minScale:
                                                      PhotoViewComputedScale
                                                          .contained,
                                                  maxScale:
                                                      PhotoViewComputedScale
                                                              .covered *
                                                          2.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: isUser
                                              ? selectColors
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              width: 2,
                                              color:
                                                  Colors.grey.withOpacity(0.3)),
                                        ),
                                        child: Image.network(image.path!),
                                      ),
                                    )
                                  else
                                    const Icon(Icons.image,
                                        size:
                                            50), // Icon thay thế nếu không có ảnh
                                  Visibility(
                                    visible:
                                        image.description?.isNotEmpty ?? false,
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: isUser
                                            ? selectColors
                                            : Colors.grey[300],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        image.description ?? '',
                                        style: textChatBot,
                                      ),
                                    ),
                                  )
                                ],
                              );
                            }).toList(),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          if (_isLoading) ...[
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RotationTransition(
                    turns: const AlwaysStoppedAnimation(45 / 360),
                    child: Icon(
                      FontAwesomeIcons.circleNotch,
                      color: selectColors,
                      size: 20.0,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Trợ lý AI đang trả lời...',
                    style: textChatBot,
                  ),
                ],
              ),
            ),
          ],
          if (_suggestions.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _suggestions.map((suggestion) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {
                          _controller.text = suggestion; // Đưa gợi ý vào ô nhập
                          // _sendMessage(); // Gửi tin nhắn tự độngfsd
                        },
                        child: Text(suggestion),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          Container(
            padding: const EdgeInsets.all(10),
            color: Colors.grey[200],
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Nhập tin nhắn...',
                      hintStyle: textChatBot,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 15),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Visibility(
                  visible: !_isLoading,
                  child: IconButton(
                    icon: Icon(
                        _isLoading ? Icons.hourglass_empty : Icons.send_rounded,
                        color: selectColors),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
