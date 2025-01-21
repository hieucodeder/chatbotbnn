import 'package:chatbotbnn/navigation/bottom_navigation.dart';
import 'package:chatbotbnn/navigation/drawer.dart';
import 'package:chatbotbnn/page/chat_page.dart';
import 'package:chatbotbnn/page/history_page.dart';
import 'package:chatbotbnn/page/home_page.dart';
import 'package:chatbotbnn/page/profile_page.dart';
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
  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return const HomePage();
      case 1:
        return const ChatPage();
      case 2:
        return const HistoryPage();
      case 3:
        return const ProfilePage();
      case 4:
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
        return 'TRANG CHỦ';
      case 1:
        return 'TRỢ LÝ AI BỘ NÔNG NGHIỆP';
      case 2:
        return 'LỊCH SỬ CHAT';
      case 3:
        return 'CÁ NHÂN';
      case 4:
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
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
        backgroundColor: selectedColor,
      ),
      body: _getPage(currentIndex),
      bottomNavigationBar: BottomNavigation(
        currentIndex: currentIndex,
        onTap: (index) {
          navigationProvider.setCurrentIndex(index);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
