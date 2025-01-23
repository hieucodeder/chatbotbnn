import 'package:chatbotbnn/model/body_history.dart';
import 'package:chatbotbnn/navigation/drawer.dart';
import 'package:chatbotbnn/page/chat_page.dart';
import 'package:chatbotbnn/page/chatbot_page.dart';
import 'package:chatbotbnn/page/setting_page.dart';
import 'package:chatbotbnn/provider/navigation_provider.dart';
import 'package:chatbotbnn/provider/provider_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({super.key});

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  Widget _getPage(
    int index, {
    String history = '',
  }) {
    switch (index) {
      case 0:
        return ChatPage(
          historyId: history,
        );
      case 1:
        return ChatbotPage(
          onSelected: (int selectedIndex) {
            // Handle the selection logic here
            // You can pass the selected index to the parent or handle it locally
            print('Selected index: $selectedIndex');
          },
        );
      case 2:
        return const SettingPage();

      default:
        return const Center(
          child: Text(
            'Trang không tồn tại',
            style: TextStyle(fontSize: 18, color: Colors.red),
          ),
        );
    }
  }

  String _getAppBarTitle(BuildContext context, int index) {
    switch (index) {
      case 0:
        return 'TRỢ LÝ AI';
      case 1:
        return 'DANH TRỢ LÝ AI';
      case 2:
        return 'CÀI ĐẶT';

      default:
        return 'activity_report';
    }
  }

  bool isExpanded = false;

  void _toggleButtons() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  BodyHistory bodyHistory = BodyHistory();
  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);
    final currentIndex = navigationProvider.currentIndex;
    final selectedColor = Provider.of<Providercolor>(context).selectedColor;

    return Scaffold(
      drawer: DrawerCustom(
        onItemSelected: (index) {
          navigationProvider.setCurrentIndex(index);
          Navigator.pop(context);
        },
        bodyHistory: bodyHistory,
      ),
      appBar: AppBar(
        title: Text(
          _getAppBarTitle(context, currentIndex),
          style: GoogleFonts.robotoCondensed(
            fontSize: 17,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.drive_file_rename_outline_sharp)),
          )
        ],
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
        backgroundColor: selectedColor,
      ),
      body: _getPage(currentIndex),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
