import 'package:chatbotbnn/page/login_page.dart';
import 'package:chatbotbnn/provider/navigation_provider.dart';
import 'package:chatbotbnn/provider/provider_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final styleText = GoogleFonts.robotoCondensed(
      fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500);
  final List<Map<String, dynamic>> languages = [
    {'locale': const Locale('vi'), 'name': 'Tiếng Việt', 'flag': '🇻🇳'},
    {'locale': const Locale('en'), 'name': 'English', 'flag': '🇺🇸'},
  ];
  Locale? selectedLocale;
  @override
  void initState() {
    super.initState();
    selectedLocale = languages.first['locale']; // Đặt mặc định
  }

  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);
    // final localization = AppLocalizations.of(context);
    // final currentLocale = context.watch<LocaleProvider>().locale;
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.account_box,
                  size: 24,
                ),
                const SizedBox(width: 10),
                TextButton(
                  onPressed: () {
                    navigationProvider.setCurrentIndex(4);
                  },
                  child: Text('Thông tin cá nhân', style: styleText),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(
                  Icons.search,
                  size: 24,
                ),
                const SizedBox(width: 10),
                TextButton(
                  onPressed: () {
                    navigationProvider.setCurrentIndex(5);
                  },
                  child: Text('Đổi mật khẩu', style: styleText),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(color: Colors.black),
            Row(
              children: [
                const Icon(Icons.logout_outlined, size: 24),
                const SizedBox(
                  width: 10,
                ),
                TextButton(
                    onPressed: () {
                      _showAlertDialog(context);
                    },
                    child: Text('Đăng xuất', style: styleText))
              ],
            )
          ],
        ),
      ),
    );
  }

  void _showAlertDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Container(
                // margin: const EdgeInssets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Provider.of<Providercolor>(context).selectedColor),
                child: const Center(
                  child: Text(
                    'Thông báo!',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.white),
                  ),
                )),
            content: const Text('Bạn có muốn đăng xuất tài khoản không?'),
            actions: [
              Container(
                height: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    border: Border.all(
                        width: 1,
                        color:
                            Provider.of<Providercolor>(context).selectedColor)),
                child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Hủy',
                      style: TextStyle(
                          color: Provider.of<Providercolor>(context)
                              .selectedColor),
                    )),
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Provider.of<Providercolor>(context).selectedColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide.none),
                  ),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                        (Route<dynamic> route) => false);
                  },
                  child: const Text(
                    'Xác nhận',
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          );
        });
  }
}
