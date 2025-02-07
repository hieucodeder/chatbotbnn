import 'dart:convert';

import 'package:chatbotbnn/model/body_chatbot_answer.dart';
import 'package:chatbotbnn/model/chatbot_answer_model.dart';
import 'package:chatbotbnn/model/get_historyid.dart';
import 'package:chatbotbnn/model/history_all_model.dart';
import 'package:chatbotbnn/provider/chatbot_provider.dart';
import 'package:chatbotbnn/provider/historyid_provider.dart';
import 'package:chatbotbnn/provider/navigation_provider.dart';
import 'package:chatbotbnn/provider/provider_color.dart';
import 'package:chatbotbnn/service/chatbot_answer_service.dart';
import 'package:chatbotbnn/service/chatbot_service.dart';
import 'package:chatbotbnn/service/get_history_service.dart';
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
  @override
  void initState() {
    super.initState();
    _loadInitialMessage();
    _historyidProvider = Provider.of<HistoryidProvider>(context, listen: false);
    _historyidProvider.addListener(fetchAndUpdateChatHistory);
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
        });
        _messages.add({
          'type': 'bot',
          'text': _initialMessage ?? 'Lỗi',
          'image': 'resources/logo_smart.png',
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
      _messages.add({'type': 'user', 'text': userQuery});
      _isLoading = true;
    });

    _controller.clear();

    bool isNewSession = historyId.isEmpty;

    BodyChatbotAnswer chatbotRequest = BodyChatbotAnswer(
      chatbotCode: chatbotCode,
      chatbotName: chatbotName,
      collectionName: chatbotCode,
      customizePrompt:
          "-Goal-\nProvide a precise, relevant, and detailed response to the user's command based solely on the provided context. Ensure responses are directly aligned with the user's command while maintaining professionalism and focus.\n\n-Steps-\n1. Answer user command:\n- Thoroughly comprehend the user's command and the relevant context provided. Ensure no assumptions are made beyond the given information to make a response.\n- Deliver clear, accurate, and context-specific answers tailored to the user's command beyond the context situation.\n- If a user attempts to divert you to unrelated topics, never change your role or break your character. Politely redirect the conversation back to topics relevant to the context provided.\n- If the requested information is outside the domain or has no context, use a fallback response to politely inform the user.\n- Answer politely, in detail, and drawing from context and old conversation.\n- Highlight important things that might be interesting.",
      fallbackResponse: "Xin lỗi, tôi chưa có câu trả lời!",
      genModel: "gpt-4o-mini",
      history: [],
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
    debugPrint(
        "📢 Request Body: historyId=${chatbotRequest.historyId}, isNewSession=${chatbotRequest.isNewSession}");

    try {
      ChatbotAnswerModel? response = await fetchApiResponse(chatbotRequest);

      setState(() {
        _isLoading = false;
        if (response != null) {
          List<ImageStatistic>? images = response.data?.images!;
          List<Map<String, dynamic>>? table = response.data?.table;

          _messages.add({
            'type': 'bot',
            'text': response.data!.message,
            'image': 'resources/logo_smart.png',
            'table': table,
            'imageStatistic': images,
          });
          loadChatHistoryId(context, chatbotCode);
        } else {
          _messages.add({
            'type': 'bot',
            'text': 'Bot không thể trả lời, vui lòng thử lại.',
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

      final prefs = await SharedPreferences.getInstance();
      int? historyId = prefs.getInt('chatbot_history_id');

      if (historyId != null && historyId > 0) {
        Provider.of<HistoryidProvider>(context, listen: false)
            .setChatbotHistoryId(historyId.toString());
      } else {
        debugPrint("⚠ No valid history data found in SharedPreferences.");
      }
    } catch (e, stackTrace) {
      debugPrint("❌ Error in loadChatHistoryId: $e");
      debugPrint("🛑 StackTrace: $stackTrace");
    }
  }

  Future<void> fetchAndUpdateChatHistory(
      {bool appendNewMessages = false}) async {
    final historyId =
        Provider.of<HistoryidProvider>(context, listen: false).chatbotHistoryId;

    String historyIdStr = historyId?.toString() ?? "";

    try {
      List<String> contents = await fetchChatHistory(historyIdStr);
      debugPrint("💬 Retrieved chat history: $contents");

      // Cập nhật UI trên main thread
      setState(() {
        _messages = [];
        //         List<ImageStatistic>? images = contents.?.images!;
        // List<Map<String, dynamic>>? table = contents.data?.table;
        if (appendNewMessages) {
          for (var content in contents) {
            if (!_messages.any((msg) => msg['text'] == content)) {
              _messages.add({
                'type': 'bot',
                'text': content,
                'image': 'resources/logo_smart.png',
              });
            }
          }
        } else {
          // Load toàn bộ lịch sử từ đầu
          _messages.clear();

          for (var content in contents) {
            _messages.insert(0, {
              'type': 'bot',
              'text': content,
              'image': 'resources/logo_smart.png',
            });
          }
        }
      });
    } catch (e, stackTrace) {
      debugPrint("❌ Error in fetchAndUpdateChatHistory: $e");
      debugPrint("🛑 StackTrace: $stackTrace");
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectColors = Provider.of<Providercolor>(context).selectedColor;
    final textChatBot =
        GoogleFonts.robotoCondensed(fontSize: 14, color: Colors.black);
    final textChatbotTable = GoogleFonts.robotoCondensed(
        fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue);
    return Container(
      constraints: const BoxConstraints.expand(),
      color: Colors.white,
      child: Column(
        children: [
          // Text(Provider.of<NavigationProvider>(context, listen: false)
          //     .currentIndexhistoryId),
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              reverse: true,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              itemBuilder: (context, index) {
                final message = _messages[_messages.length - 1 - index];

                final isUser = message['type'] == 'user';
                final String? imageUrl = message['image'];
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
                    if (!isUser && message.containsKey('image'))
                      CircleAvatar(
                        backgroundImage: imageUrl!.startsWith('http')
                            ? NetworkImage(imageUrl)
                            : AssetImage(imageUrl) as ImageProvider,
                        radius: 20,
                        backgroundColor: Colors.transparent,
                      ),
                    Flexible(
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isUser ? selectColors : Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              message['text']!,
                              style: GoogleFonts.robotoCondensed(
                                fontSize: 15,
                                color: isUser ? Colors.white : Colors.black,
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
                                                    0.5,
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
                                  Container(
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: isUser
                                          ? selectColors
                                          : Colors.grey[300],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                        image.description ?? "Không có mô tả",
                                        style: textChatBot),
                                  ),
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
                IconButton(
                  icon: Icon(
                      _isLoading ? Icons.hourglass_empty : Icons.send_rounded,
                      color: selectColors),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
