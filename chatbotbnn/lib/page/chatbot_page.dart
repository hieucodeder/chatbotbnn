import 'package:chatbotbnn/model/get_code_model.dart';
import 'package:chatbotbnn/provider/chatbot_provider.dart';
import 'package:chatbotbnn/provider/chatbotcolors_provider.dart';
import 'package:chatbotbnn/service/chatbot_service.dart';
import 'package:chatbotbnn/service/role_service.dart';
import 'package:flutter/material.dart';
import 'package:chatbotbnn/model/body_role.dart';
import 'package:chatbotbnn/model/role_model.dart';
import 'package:provider/provider.dart';

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

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
    // Lấy chatbotCode từ provider
    final chatbotCode =
        Provider.of<ChatbotProvider>(context, listen: false).currentChatbotCode;

    if (chatbotCode != null) {
      setState(() {
        isLoading = true; // Set loading state to true
      });

      // Gọi API với chatbotCode
      try {
        // Giả sử gọi API với chatbotCode
        final result = await fetchGetCodeModel(chatbotCode);

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
        : GridView.builder(
            padding: const EdgeInsets.all(8.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1,
            ),
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
                  } else {}
                },
                child: Consumer<ChatbotcolorsProvider>(
                  builder: (context, chatbotcolorsProvider, child) {
                    // Retrieve the selected index from the provider
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundImage: chatbot.picture != null &&
                                    chatbot.picture!.isNotEmpty
                                ? NetworkImage(chatbot.picture!)
                                : const AssetImage('resources/logo_smart.png')
                                    as ImageProvider,
                            radius: 35,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            chatbot.chatbotName ?? 'No Name',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          );
  }
}
