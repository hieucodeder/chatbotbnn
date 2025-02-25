import 'package:chatbotbnn/model/body_forget_password.dart';
import 'package:chatbotbnn/model/respone_forgetpassword.dart';
import 'package:chatbotbnn/page/login_page.dart';
import 'package:chatbotbnn/provider/navigation_provider.dart';
import 'package:chatbotbnn/provider/provider_color.dart';
import 'package:chatbotbnn/service/forget_password_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  void showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Đổi mật khẩu"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: oldPasswordController,
                decoration: const InputDecoration(
                  labelText: "Nhập mật khẩu cũ",
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: newPasswordController,
                decoration: const InputDecoration(
                  labelText: "Nhập mật khẩu mới",
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: confirmPasswordController,
                decoration: const InputDecoration(
                  labelText: "Xác nhận mật khẩu mới",
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Hủy"),
            ),
            ElevatedButton(
              onPressed: () async {
                // Đóng bàn phím nếu đang mở
                FocusScope.of(context).unfocus();

                String oldPassword = oldPasswordController.text.trim();
                String newPassword = newPasswordController.text.trim();
                String confirmPassword = confirmPasswordController.text.trim();

                if (oldPassword.isEmpty ||
                    newPassword.isEmpty ||
                    confirmPassword.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Vui lòng nhập đầy đủ thông tin")),
                  );
                  return;
                }

                if (newPassword.length < 6) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Mật khẩu mới phải có ít nhất 6 ký tự")),
                  );
                  return;
                }

                if (newPassword != confirmPassword) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Mật khẩu mới không trùng khớp")),
                  );
                  return;
                }

                // Gọi hàm xử lý đổi mật khẩu
                handleForgetPassword(context);
              },
              child: const Text("Lưu"),
            ),
          ],
        );
      },
    );
  }

  void handleForgetPassword(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userid');
    String? userName = prefs.getString('username');

    BodyForgetPassword requestBody = BodyForgetPassword(
      passwordHash: oldPasswordController.text.trim(),
      newPassword: newPasswordController.text.trim(),
      newConfirmPassword: confirmPasswordController.text.trim(),
      username: userName,
      userId: userId,
    );

    ResponeForgetpassword response = await forgetPassword(requestBody);

    if (response.results == true) {
      print("Thành công: ${response.message}");

      // Xóa dữ liệu phiên đăng nhập
      await prefs.clear();

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (Route<dynamic> route) => false);
    } else {
      print("Thất bại: ${response.message}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi: ${response.message}")),
      );
    }
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
                    showChangePasswordDialog(context);
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
