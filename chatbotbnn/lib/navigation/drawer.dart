// ignore_for_file: deprecated_member_use

import 'package:chatbotbnn/model/body_history.dart';
import 'package:chatbotbnn/model/history_all_model.dart';
import 'package:chatbotbnn/model/history_model.dart';
import 'package:chatbotbnn/page/chat_page.dart';
import 'package:chatbotbnn/provider/chatbot_provider.dart';
import 'package:chatbotbnn/provider/navigation_provider.dart';
import 'package:chatbotbnn/provider/provider_color.dart';
import 'package:chatbotbnn/service/history_all_service.dart';
import 'package:chatbotbnn/service/history_service.dart';
import 'package:chatbotbnn/service/login_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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

  @override
  void initState() {
    super.initState();
    _fetchHistoryAllModel();
  }

  void _fetchHistoryAllModel() {
    final chatbotCode =
        Provider.of<ChatbotProvider>(context, listen: false).currentChatbotCode;
    setState(() {
      _historyAllModel = fetchChatHistoryAll(chatbotCode, null, null);
    });
  }

  Future<void> _loadChatHistoryAndNavigate(String? historyId) async {
    try {
      if (historyId != null) {
        Provider.of<NavigationProvider>(context, listen: false)
            .setCurrentIndexHistoryId(historyId);
      } else {}
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    final selectedColor = Provider.of<Providercolor>(context).selectedColor;
    TextEditingController _startDateController = TextEditingController();
    TextEditingController _endDateController = TextEditingController();
    DateTime _startDate = DateTime.now();
    DateTime _endDate = DateTime.now();

    // Hàm chọn ngày
    Future<void> _selectStartDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _startDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      );
      if (picked != null && picked != _startDate)
        setState(() {
          _startDate = picked;
          _startDateController.text =
              DateFormat('dd/MM/yyyy').format(_startDate); // Định dạng ngày
        });
    }

    // Hàm chọn ngày kết thúc
    Future<void> _selectEndDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _endDate,
        firstDate: _startDate, // Ngày kết thúc không thể nhỏ hơn ngày bắt đầu
        lastDate: DateTime(2101),
      );
      if (picked != null && picked != _endDate)
        setState(() {
          _endDate = picked;
          _endDateController.text =
              DateFormat('dd/MM/yyyy').format(_endDate); // Định dạng ngày
        });
    }

    return Drawer(
      backgroundColor: selectedColor,
      child: SafeArea(
        minimum: const EdgeInsets.only(left: 5, top: 27, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            Text(
              'Chào mừng đến với Smart Chat!',
              style: GoogleFonts.robotoCondensed(
                  fontSize: 16, color: Colors.orange),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildListTile(
                      icon: Icons.chat,
                      title: 'Smart Chat',
                      onTap: () => widget.onItemSelected(0),
                    ),
                    _buildListTile(
                      icon: FontAwesomeIcons.message,
                      title: 'Danh sách Chat Bot',
                      onTap: () => widget.onItemSelected(1),
                    ),
                    const Divider(
                      color: Colors.white,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        children: [
                          TextField(
                            controller: _startDateController,
                            readOnly: true,
                            decoration: InputDecoration(
                              hintText: '  Ngày bắt đầu',
                              hintStyle: GoogleFonts.robotoCondensed(
                                  color: Colors.white),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 0),
                              suffixIcon: SizedBox(
                                width: 35,
                                height: 35,
                                child: GestureDetector(
                                  onTap: () {
                                    _selectStartDate(context);
                                  },
                                  child: const Icon(
                                    Icons.calendar_today,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              filled: true,
                              fillColor: Colors.grey,
                            ),
                            onTap: () => _selectStartDate(context),
                          ),
                          TextField(
                            controller: _endDateController,
                            readOnly:
                                true, // Chỉ cho phép chọn ngày qua DatePicker
                            decoration: InputDecoration(
                              hintText: '  Ngày kết thúc',
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 2, vertical: 3),
                              hintStyle: GoogleFonts.robotoCondensed(
                                color: Colors.white,
                              ),
                              suffixIcon: IconButton(
                                icon: const Icon(
                                  Icons.calendar_today,
                                  size: 20,
                                ),
                                color: Colors.white,
                                onPressed: () => _selectEndDate(context),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              filled: true,
                              fillColor: Colors.grey,
                            ),
                            onTap: () => _selectEndDate(
                                context), // Mở DatePicker khi nhấn vào TextField
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Lịch sử chat',
                            style: GoogleFonts.robotoCondensed(
                                color: Colors.white),
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
                              snapshot.data!.data!.map((history) {
                            final chatbotHistoryId =
                                (history.chatbotHistoryId ?? 'Không có ID')
                                    .toString();
                            final userMessage = history.messages?.lastWhere(
                              (msg) => msg.messageType != 'bot',
                              orElse: () =>
                                  Messages(content: 'Không có dữ liệu'),
                            );
                            final content =
                                (userMessage?.content ?? 'Không có dữ liệu')
                                    .toString();

                            // Trả về một Map với cả key và value là String
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
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 1),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 0),
                                  tileColor: Colors.grey,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  leading: const CircleAvatar(
                                    radius: 15,
                                    backgroundColor: Colors.grey,
                                    child: Icon(
                                      Icons.history,
                                      color: Colors.white,
                                      size: 20,
                                    ),
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
                                  trailing: const Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.white,
                                    size: 13.0,
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
            _buildColorSelector(context),
            _buildUserAccount(),
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

  Widget _buildColorSelector(BuildContext context) {
    final colors = [
      const Color(0xff042E4D),
      const Color(0xff004225),
      const Color(0xff6b240c)
    ];
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Text('Màu sắc:',
              style: GoogleFonts.robotoCondensed(
                  fontSize: 15, color: Colors.white)),
          const SizedBox(width: 5),
          Wrap(
            children: colors.map((color) {
              return GestureDetector(
                onTap: () => Provider.of<Providercolor>(context, listen: false)
                    .changeColor(color),
                child: Container(
                  margin: const EdgeInsets.all(4),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1),
                  ),
                  child: Provider.of<Providercolor>(context).selectedColor ==
                          color
                      ? const Icon(Icons.check, color: Colors.white, size: 16)
                      : const SizedBox.shrink(),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

// _buildUserAccount widget
  Widget _buildUserAccount() {
    final _loginService = LoginService();
    return FutureBuilder<Map<String, String>?>(
      future:
          _loginService.getAccountFullNameAndUsername(), // Fetch the user data
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
                height: 40,
                width: 40,
                fit: BoxFit.cover,
              ),
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
                        'Error loading user info', // Display error message
                        style: GoogleFonts.robotoCondensed(
                            fontSize: 16,
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
          final userName = snapshot.data?['username'] ?? 'Không có tên';
          final email = snapshot.data?['email'] ?? 'Không có email';

          return ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.asset(
                'resources/logo_smart.png',
                height: 40,
                width: 40,
                fit: BoxFit.cover,
              ),
            ),
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
                        userName, // Display fetched username
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
                    email, // Display fetched email
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

        return Container(); // Return an empty container if no data or error
      },
    );
  }
}
