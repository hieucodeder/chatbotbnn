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

  Widget _buildColorSelector(BuildContext context) {
    final colors = [
      const Color(0xFF0D448A),
      const Color(0xff004225),
      const Color(0xff6b240c),
    ];

    return Consumer<Providercolor>(
      builder: (context, providerColor, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: colors.map((color) {
            final isSelected = providerColor.selectedColor == color;

            return GestureDetector(
              onTap: () => providerColor.changeColor(color),
              child: Container(
                margin: const EdgeInsets.all(6),
                width: 23,
                height: 23,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? Colors.white : Colors.transparent,
                    width: 2,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                              color: color.withOpacity(0.5), blurRadius: 8)
                        ]
                      : [],
                ),
                child: Center(
                  child: isSelected
                      ? const Icon(Icons.check, color: Colors.white, size: 18)
                      : const SizedBox(height: 23),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.all(16),
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
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () {
                    navigationProvider.setCurrentIndex(4);
                  },
                  child: Text('Thông tin cá nhân', style: styleText),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.search,
                  size: 24,
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () {
                    navigationProvider.setCurrentIndex(5);
                  },
                  child: Text('Đổi mật khẩu', style: styleText),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.color_lens,
                  size: 24,
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () {
                    navigationProvider.setCurrentIndex(5);
                  },
                  child: Text('Màu sắc:', style: styleText),
                ),
                _buildColorSelector(context),
              ],
            ),
            const SizedBox(height: 8),
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
