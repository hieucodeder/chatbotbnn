import 'package:chatbotbnn/provider/chatbot_provider.dart';
import 'package:chatbotbnn/provider/chatbotcolors_provider.dart';
import 'package:chatbotbnn/service/chatbot_service.dart';
import 'package:chatbotbnn/service/role_service.dart';
import 'package:flutter/material.dart';
import 'package:chatbotbnn/model/body_role.dart';
import 'package:chatbotbnn/model/role_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ChatbotPage extends StatefulWidget {
  final Function(int) onSelected;
  const ChatbotPage({super.key, required this.onSelected});

  @override
  _ChatbotPageState createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  List<Data> chatbotList = [];
  bool isLoading = true;
  int? selectedIndex; // This will store the index of the selected item

  @override
  void initState() {
    super.initState();
    _loadChatbots();
  }

  Future<void> _loadChatbots() async {
    BodyRole bodyRole = BodyRole(
      pageIndex: 1,
      pageSize: '1000000000',
      role: 'user',
      searchText: '',
    );

    RoleModel? roleModel = await fetchRoles(bodyRole);
    if (roleModel != null && roleModel.data != null) {
      setState(() {
        chatbotList = roleModel.data!;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchAndNavigate() async {
    final chatbotCode =
        Provider.of<ChatbotProvider>(context, listen: false).currentChatbotCode;

    if (chatbotCode != null) {
      setState(() {
        isLoading = true;
      });

      try {
        final result = await fetchGetCodeModel(chatbotCode);
        widget.onSelected(0);

        if (result != null) {
        } else {}
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return chatbotList.isEmpty
        ? const Center(
            child: Text('No chatbots found.'),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: chatbotList.length,
            itemBuilder: (context, index) {
              final chatbot = chatbotList[index];
              return GestureDetector(
                onTap: () {
                  Provider.of<ChatbotcolorsProvider>(context, listen: false)
                      .setSelectedIndex(index);

                  setState(() {
                    selectedIndex = index;
                  });

                  if (chatbot.chatbotCode != null) {
                    Provider.of<ChatbotProvider>(context, listen: false)
                        .setChatbotCode(chatbot.chatbotCode!);

                    _fetchAndNavigate();
                  }
                },
                child: Consumer<ChatbotcolorsProvider>(
                  builder: (context, chatbotcolorsProvider, child) {
                    bool isSelected =
                        chatbotcolorsProvider.selectedIndex == index;

                    return Card(
                      color: isSelected
                          ? Colors.blueAccent.withOpacity(0.3)
                          : Colors.white,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: chatbot.picture != null &&
                                      chatbot.picture!.isNotEmpty
                                  ? NetworkImage(chatbot.picture!)
                                  : const AssetImage('resources/logo_smart.png')
                                      as ImageProvider,
                              radius: 35,
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  chatbot.chatbotName ?? 'No Name',
                                  style: GoogleFonts.robotoCondensed(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  width: 250,
                                  child: Text(
                                    chatbot.attributes ??
                                        'Chatbot sử dụng trí tuệ nhân tạo (AI) hoặc các quy tắc lập trình để xử lý và phản hồi lại các câu hỏi hoặc yêu cầu từ người dùng.',
                                    maxLines: 3,
                                    style: GoogleFonts.robotoCondensed(
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
  }
}
