// ignore_for_file: deprecated_member_use

import 'package:chatbotbnn/page/setting_page.dart';
import 'package:chatbotbnn/provider/provider_color.dart';
import 'package:chatbotbnn/service/login_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DrawerCustom extends StatefulWidget {
  final Function(int) onItemSelected;
  const DrawerCustom({super.key, required this.onItemSelected});

  @override
  State<DrawerCustom> createState() => _DrawerCustomState();
}

class _DrawerCustomState extends State<DrawerCustom> {
  final List<Map<String, String>> chatHistory = [
    {'role': 'user', 'message': 'Xin chào!'},
    {'role': 'bot', 'message': 'Chào bạn! Tôi có thể giúp gì?'},
    {'role': 'user', 'message': 'Hôm nay thời tiết thế nào?'},
    {'role': 'bot', 'message': 'Hôm nay trời nắng đẹp! 😊'},
    {'role': 'user', 'message': 'Hôm nay thời tiết thế nào?'},
    {'role': 'bot', 'message': 'Hôm nay trời nắng đẹp! 😊'},
    {'role': 'user', 'message': 'Hôm nay thời tiết thế nào?'},
    {'role': 'bot', 'message': 'Hôm nay trời nắng đẹp! 😊'},
    {'role': 'user', 'message': 'Hôm nay thời tiết thế nào?'},
    {'role': 'bot', 'message': 'Hôm nay trời nắng đẹp! 😊'},
    {'role': 'user', 'message': 'Hôm nay thời tiết thế nào?'},
    {'role': 'bot', 'message': 'Hôm nay trời nắng đẹp! 😊'},
    {'role': 'user', 'message': 'Hôm nay thời tiết thế nào?'},
    {'role': 'bot', 'message': 'Hôm nay trời nắng đẹp! 😊'},
    {'role': 'user', 'message': 'Hôm nay thời tiết thế nào?'},
    {'role': 'bot', 'message': 'Hôm nay trời nắng đẹp! 😊'},
    {'role': 'user', 'message': 'Hôm nay thời tiết thế nào?'},
    {'role': 'bot', 'message': 'Hôm nay trời nắng đẹp! 😊'},
  ];

  @override
  Widget build(BuildContext context) {
    final selectedColor = Provider.of<Providercolor>(context).selectedColor;
// Lọc danh sách chỉ chứa các câu hỏi từ người dùng
    final userQuestions =
        chatHistory.where((chat) => chat['role'] == 'user').toList();

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
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 450),
                      child: ListView.builder(
                        // shrinkWrap: true,
                        // physics: const NeverScrollableScrollPhysics(),
                        itemCount:
                            userQuestions.length, // Sử dụng danh sách đã lọc
                        itemBuilder: (context, index) {
                          final chat =
                              userQuestions[index]; // Lấy từ danh sách đã lọc
                          return Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            alignment: Alignment
                                .centerLeft, // Luôn căn trái (vì chỉ hiển thị câu hỏi của user)
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors
                                    .blue[100], // Dùng màu riêng cho câu hỏi
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                chat['message'] ??
                                    '', // Hiển thị nội dung câu hỏi
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
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
          // SvgPicture.asset(
          //   'resources/logo.svg',
          //   width: 80,
          //   height: 30,
          //   fit: BoxFit.contain,
          // ),

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
              child: CircularProgressIndicator(), // Show loading indicator
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
