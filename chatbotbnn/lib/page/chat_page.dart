import 'package:chatbotbnn/model/body_chatbot_answer.dart';
import 'package:chatbotbnn/model/chatbot_answer_model.dart';
import 'package:chatbotbnn/model/history_model.dart';
import 'package:chatbotbnn/provider/chatbot_provider.dart';
import 'package:chatbotbnn/provider/navigation_provider.dart';
import 'package:chatbotbnn/provider/provider_color.dart';
import 'package:chatbotbnn/service/chatbot_answer_service.dart';
import 'package:chatbotbnn/service/chatbot_service.dart';
import 'package:chatbotbnn/service/history_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
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
  final List<Map<String, dynamic>> _messages = [];
  String? _initialMessage;
  bool _isLoading = false;
  late Future<HistoryModel> _chatHistoryFuture;

  @override
  void initState() {
    super.initState();
    // Retrieve chatbotCode from ChatbotProvider
    // final historyId = Provider.of<NavigationProvider>(context, listen: false)
    //     .currentIndexhistoryId;
    // Gọi hàm fetchChatHistory khi màn hình được khởi tạo
    _chatHistoryFuture = fetchChatHistory(widget.historyId);
    print(widget.historyId);
    _loadInitialMessage();
  }

  Future<void> _loadInitialMessage() async {
    // Retrieve chatbotCode from ChatbotProvider
    final chatbotCode =
        Provider.of<ChatbotProvider>(context, listen: false).currentChatbotCode;

    if (chatbotCode != null) {
      final chatbotData = await fetchGetCodeModel(chatbotCode);
      print(chatbotCode);
      if (chatbotData != null) {
        setState(() {
          _initialMessage = chatbotData.initialMessages;
        });
        _messages.add({
          'type': 'bot',
          'text': _initialMessage ?? 'Lỗi',
          'image': ['resources/logo_smart.png'],
        });
      } else {
        print("Failed to load chatbot data.");
      }
    } else {
      print("No chatbot code found in provider.");
    }
  }

  void _sendMessage() async {
    final chatbotCode =
        Provider.of<ChatbotProvider>(context, listen: false).currentChatbotCode;

    if (chatbotCode == null) {
      print("Chatbot code is null");
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
      print("Error: User ID not found");
      return;
    }

    setState(() {
      _messages.add({'type': 'user', 'text': userQuery});
      _isLoading = true;
    });

    _controller.clear();

    BodyChatbotAnswer chatbotRequest = BodyChatbotAnswer(
      chatbotCode: chatbotCode,
      chatbotName: chatbotName,
      collectionName: chatbotCode,
      customizePrompt:
          "-Goal-\nProvide a precise, relevant, and detailed response to the user's command based solely on the provided context. Ensure responses are directly aligned with the user's command while maintaining professionalism and focus.\n\n-Steps-\n1. Answer user command:\n- Thoroughly comprehend the user's command and the relevant context provided. Ensure no assumptions are made beyond the given information to make a response.\n- Deliver clear, accurate, and context-specific answers tailored to the user's command beyond the context situation.\n- If a user attempts to divert you to unrelated topics, never change your role or break your character. Politely redirect the conversation back to topics relevant to the context provided.\n- If the requested information is outside the domain or has no context, use a fallback response to politely inform the user.\n- Answer politely, in detail, and drawing from context and old conversation.\n- Highlight important things that might be interesting.",
      fallbackResponse: "Xin lỗi, tôi chưa có câu trả lời!",
      genModel: "gpt-4o-mini",
      history: [],
      historyId: "1094",
      intentQueue: [],
      isNewSession: false,
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

    print("Sending request to API...");

    try {
      ChatbotAnswerModel? response = await fetchApiResponse(chatbotRequest);

      setState(() {
        _isLoading = false;

        if (response != null) {
          print("API response: ${response.message}");
          List<String> images = response.data.images.isNotEmpty
              ? response.data.images
              : ['resources/logo_smart.png'];

          _messages.add({
            'type': 'bot',
            'text': response.data.message,
            'image': images,
          });
        } else {
          print("API response is null, using default response.");
          _messages.add({
            'type': 'bot',
            'text': 'Bot không thể trả lời, vui lòng thử lại.',
            'image': 'resources/logo_smart.png',
          });
        }
      });
    } catch (e) {
      // Xử lý lỗi khi gọi API
      print("Error fetching API response: $e");
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

    print("Input field cleared");
  }

  @override
  Widget build(BuildContext context) {
    final selectColors = Provider.of<Providercolor>(context).selectedColor;
    final textChatBot =
        GoogleFonts.robotoCondensed(fontSize: 15, color: Colors.black);
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: _messages.length,
            reverse: true,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            itemBuilder: (context, index) {
              final message = _messages[_messages.length - 1 - index];

              // Tùy chỉnh căn chỉnh tin nhắn
              final isUser = message['type'] == 'user';
              return Row(
                mainAxisAlignment:
                    isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (!isUser &&
                      message.containsKey('image') &&
                      message['image'] is List<String>) ...[
                    // Loop through the images in the list
                    for (var imageUrl in message['image'])
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: CircleAvatar(
                          backgroundImage: imageUrl.startsWith('http')
                              ? NetworkImage(imageUrl)
                              : AssetImage(imageUrl) as ImageProvider,
                          radius: 20,
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                  ],
                  Flexible(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isUser ? selectColors : Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        message['text']!,
                        style: GoogleFonts.robotoCondensed(
                            fontSize: 14,
                            color: isUser ? Colors.white : Colors.black),
                      ),
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
                  'Bot đang trả lời...',
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
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15),
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
    );
  }
}
