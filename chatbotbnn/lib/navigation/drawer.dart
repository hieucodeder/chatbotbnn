import 'package:chatbotbnn/model/body_history.dart';
import 'package:chatbotbnn/model/delete_model.dart';
import 'package:chatbotbnn/model/history_all_model.dart';
import 'package:chatbotbnn/provider/chatbot_provider.dart';
import 'package:chatbotbnn/provider/historyid_provider.dart';
import 'package:chatbotbnn/provider/provider_color.dart';
import 'package:chatbotbnn/service/delete_service.dart';
import 'package:chatbotbnn/service/history_all_service.dart';
import 'package:chatbotbnn/service/login_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerCustom extends StatefulWidget {
  final BodyHistory bodyHistory;
  final Function(int) onItemSelected;
  const DrawerCustom(
      {super.key, required this.onItemSelected, required this.bodyHistory});

  @override
  State<DrawerCustom> createState() => _DrawerCustomState();
}

class _DrawerCustomState extends State<DrawerCustom> {
  late Future<HistoryAllModel> _historyAllModel;
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchHistoryAllModel();
  }

  Future<String?> getChatbotName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('chatbot_name');
  }

  void _fetchHistoryAllModel() {
    final chatbotCode =
        Provider.of<ChatbotProvider>(context, listen: false).currentChatbotCode;
    setState(() {
      _historyAllModel = fetchChatHistoryAll(chatbotCode, startDate, endDate);
    });
  }

  Future<void> _loadChatHistoryAndNavigate(String? historyId) async {
    try {
      if (historyId != null) {
        Provider.of<HistoryidProvider>(context, listen: false)
            .setChatbotHistoryId(historyId);
      } else {}
    } catch (e) {}
  }

  void _deleteRest() {
    setState(() {
      _fetchHistoryAllModel();
      Navigator.pop(context);
    });
  }

  Future<void> deleteChatHistory(
      BuildContext context, String? historyId) async {
    try {
      // Nếu historyId null, lấy từ Provider
      String? historyIdString = historyId ??
          Provider.of<HistoryidProvider>(context, listen: false)
              .chatbotHistoryId;

      // Kiểm tra historyIdString có hợp lệ không
      if (historyIdString == null || historyIdString.isEmpty) {
        print('Lỗi: historyId không hợp lệ');
        return;
      }

      // Chuyển đổi `String` sang `int`
      int? historyIdInt = int.tryParse(historyIdString);
      if (historyIdInt == null || historyIdInt <= 0) {
        print('Lỗi: Không thể chuyển đổi historyId');
        return;
      }

      // Hiển thị hộp thoại xác nhận xóa
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Xác nhận xóa'),
          content:
              const Text('Bạn có chắc chắn muốn xóa lịch sử chat này không?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Đóng'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  // Gọi API xóa lịch sử chat
                  DeleteModel result =
                      await fetchChatHistoryDelete(historyIdInt);
                  print(result.message);
                  _deleteRest();

                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Thông báo'),
                      content: const Text('Xóa thành công'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                } catch (e) {
                  print('Error: $e');
                  Navigator.of(context).pop();

                  // Hiển thị thông báo lỗi
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Lỗi'),
                      content: const Text(
                          'Có lỗi xảy ra trong quá trình xóa lịch sử.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Đóng'),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: const Text('Xóa'),
            ),
          ],
        ),
      );
    } catch (e) {
      print('Error: $e');
    }
  }

  String? startDate;
  String? endDate;
  final TextEditingController _controller = TextEditingController();
  void _selectDateRange() async {
    try {
      // Chọn ngày bắt đầu
      final DateTime? startPicked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      );

      if (startPicked != null) {
        // Chọn ngày kết thúc
        final DateTime? endPicked = await showDatePicker(
          context: context,
          initialDate: startPicked.add(const Duration(days: 1)),
          firstDate: startPicked,
          lastDate: DateTime(2101),
        );

        if (endPicked != null) {
          // Gán giá trị đã chọn vào biến và cập nhật UI
          setState(() {
            startDate = DateFormat('yyyy-MM-dd').format(startPicked);
            endDate = DateFormat('yyyy-MM-dd').format(endPicked);
            _controller.text = '$startDate - $endDate';
          });

          await _updateDocumentsByDateRange();
        }
      }
    } catch (e) {
      print("Lỗi chọn ngày: $e");
    }
  }

  Future<void> _updateDocumentsByDateRange() async {
    if (startDate != null && endDate != null) {
      final chatbotCode = Provider.of<ChatbotProvider>(context, listen: false)
          .currentChatbotCode;

      setState(() {
        _historyAllModel =
            fetchChatHistoryAll(chatbotCode, startDate!, endDate!);
      });
    }
  }

  void _clearDateRange() {
    if (mounted) {
      final chatbotCode = Provider.of<ChatbotProvider>(context, listen: false)
          .currentChatbotCode;
      setState(() {
        _historyAllModel = fetchChatHistoryAll(chatbotCode, null, null);
        _controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedColor = Provider.of<Providercolor>(context).selectedColor;

    return Drawer(
      backgroundColor: selectedColor,
      child: SafeArea(
        minimum: const EdgeInsets.only(left: 10, top: 20, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            Container(
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: const Color(0xFF3B3B3B).withOpacity(0.5),
              ),
              child: Row(
                children: [
                  Image.asset(
                    'resources/logo_smart.png',
                    width: 30,
                    height: 25,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  FutureBuilder<String?>(
                    future: getChatbotName(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.hasError || !snapshot.hasData) {
                        return const Text('No Name');
                      }
                      return Text(
                        snapshot.data ?? 'No Name',
                        style: GoogleFonts.robotoCondensed(
                            fontSize: 15, color: Colors.white),
                      );
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: _buildListTile(
                        icon: Icons.chat,
                        title: 'Smart Chat',
                        onTap: () => widget.onItemSelected(0),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: _buildListTile(
                        icon: FontAwesomeIcons.message,
                        title: 'Danh sách Trợ lý AI',
                        onTap: () => widget.onItemSelected(1),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Divider(
                      color: Colors.white38,
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: _selectDateRange,
                          child: Container(
                            width: double.infinity,
                            height: 40,
                            margin: const EdgeInsets.only(top: 10),
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.black38),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextField(
                                      controller: _controller,
                                      readOnly: true,
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                        hintText:
                                            'Chọn ngày bắt đầu và kết thúc',
                                        hintStyle: GoogleFonts.robotoCondensed(
                                          fontSize: 14,
                                          color: Colors.black45,
                                        ),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ),
                                if (_controller.text.isNotEmpty)
                                  GestureDetector(
                                    onTap: _clearDateRange,
                                    child: const Icon(
                                      Icons.close_sharp,
                                      color: Colors.black54,
                                      size: 20,
                                    ),
                                  ),
                                const VerticalDivider(
                                  width: 20,
                                  thickness: 1,
                                  color: Colors.black38,
                                ),
                                GestureDetector(
                                  onTap: _selectDateRange,
                                  child: const Icon(Icons.calendar_today,
                                      color: Colors.black54),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const CircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.grey,
                            child: Icon(
                              Icons.history,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Lịch sử',
                            style: GoogleFonts.robotoCondensed(
                                fontSize: 16, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    FutureBuilder<HistoryAllModel>(
                      future: _historyAllModel,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData || snapshot.data == null) {
                          return const Center(child: Text('No data available'));
                        } else {
                          final List<Map<String, String>> contents =
                              (snapshot.data?.data ?? []).map((history) {
                            final chatbotHistoryId =
                                history.chatbotHistoryId?.toString() ??
                                    'Không có ID';

                            final userMessage = (history.messages?.isNotEmpty ??
                                    false)
                                ? history.messages!.lastWhere(
                                    (msg) => msg.messageType != 'bot',
                                    orElse: () =>
                                        Messages(content: 'Không có dữ liệu'),
                                  )
                                : Messages(content: 'Không có dữ liệu');

                            final content =
                                userMessage.content ?? 'Không có dữ liệu';

                            return {
                              'key': chatbotHistoryId,
                              'value': content,
                            };
                          }).toList();

                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: contents.length,
                            itemBuilder: (context, index) {
                              return Container(
                                width: double.infinity,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color:
                                      const Color(0xFF3B3B3B).withOpacity(0.5),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 1),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 0),
                                  tileColor: Colors.grey,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  title: Text(
                                    contents[index]['value'] ?? '',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.robotoCondensed(
                                      fontSize: 14.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  trailing: GestureDetector(
                                    onTap: () {
                                      deleteChatHistory(
                                          context, contents[index]['key']);
                                    },
                                    child: const Icon(
                                      Icons.more_horiz,
                                      color: Colors.white,
                                      size: 20.0,
                                    ),
                                  ),
                                  onTap: () {
                                    _loadChatHistoryAndNavigate(
                                        contents[index]['key']);
                                    Navigator.pop(context);
                                  },
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            _buildUserAccount(),
            // _buildColorSelector(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            iconSize: 23,
            onPressed: () => widget.onItemSelected(3),
          ),
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.drive_file_rename_outline_sharp,
                color: Colors.white,
              ))
        ],
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Colors.white),
      title: Text(title,
          style:
              GoogleFonts.robotoCondensed(fontSize: 15, color: Colors.white)),
      onTap: onTap,
    );
  }

  Widget _buildExpansionTile({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return ExpansionTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: GoogleFonts.robotoCondensed(fontSize: 15, color: Colors.white),
      ),
      childrenPadding: const EdgeInsets.only(left: 20.0),
      iconColor: Colors.white,
      collapsedIconColor: Colors.grey,
      children: children,
    );
  }

// _buildUserAccount widget
  Widget _buildUserAccount() {
    final loginService = LoginService();
    return FutureBuilder<Map<String, String>?>(
      future:
          loginService.getAccountFullNameAndUsername(), // Fetch the user data
      builder: (context, snapshot) {
        // Loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child:
                  const CircularProgressIndicator(), // Show loading indicator
            ),
            title: GestureDetector(
              onTap: () {
                widget.onItemSelected(2);
              },
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Loading...', // Placeholder text
                        style: GoogleFonts.robotoCondensed(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  Text(
                    'Loading...', // Placeholder text
                    style: GoogleFonts.robotoCondensed(
                        color: Colors.white,
                        fontSize: 16,
                        fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
          );
        }
        // Error state
        else if (snapshot.hasError) {
          return ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.asset(
                'resources/logo_smart.png',
                height: 30,
                width: 30,
                fit: BoxFit.cover,
              ),
            ),
            contentPadding: EdgeInsets.zero,
            title: GestureDetector(
              onTap: () {
                widget.onItemSelected(2);
              },
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Error loading user info', // Display error message
                        style: GoogleFonts.robotoCondensed(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
                  ),
                  Text(
                    '',
                    style: GoogleFonts.robotoCondensed(
                        color: Colors.white,
                        fontSize: 16,
                        fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
          );
        }
        // Data successfully fetched
        else if (snapshot.hasData && snapshot.data != null) {
          final userName = snapshot.data?['full_name'] ?? 'Không có tên';
          final email = snapshot.data?['email'] ?? 'Không có email';

          return ListTile(
            leading: CircleAvatar(
              child: Image.asset(
                'resources/logo_smart.png',
                height: 30,
                width: 30,
                fit: BoxFit.cover,
              ),
            ),
            contentPadding: EdgeInsets.zero,
            title: GestureDetector(
              onTap: () {
                widget.onItemSelected(2);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        userName,
                        style: GoogleFonts.robotoCondensed(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  Text(
                    email, // Display fetched email
                    style: GoogleFonts.robotoCondensed(
                        color: Colors.white,
                        fontSize: 14,
                        fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
          );
        }

        return Container(); // Return an empty container if no data or error
      },
    );
  }
}
