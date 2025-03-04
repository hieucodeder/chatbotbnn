import 'package:chatbotbnn/model/body_login.dart';
import 'package:chatbotbnn/page/app_screen.dart';
import 'package:chatbotbnn/page/chatbot_page.dart';
import 'package:chatbotbnn/service/login_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  final _loginService = LoginService();

  bool _isLoading = false; // Trạng thái đang tải

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đang xử lý dữ liệu...')),
      );

      final String username = _usernameController.text.trim();
      final String password = _passwordController.text.trim();

      // Create BodyLogin object from username and password
      final BodyLogin loginData =
          BodyLogin(username: username, password: password);

      try {
        Map<String, dynamic>? response = await _loginService.login(loginData);

        if (response != null) {
          // Successful login
          showLoginSnackbar(context);
        } else {
          setState(() {});
          showLoginErrorSnackbar(context); // Show error if login fails
        }
      } catch (error) {
        setState(() {});
        showLoginErrorSnackbar(context); // Show error if there's an exception
      }
    } else {
      // If form validation fails
      showValidationErrorSnackbar(context, 'Vui lòng điền đầy đủ thông tin.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        resizeToAvoidBottomInset: true,
        body: Container(
            constraints: const BoxConstraints.expand(),
            color: Colors.white,
            child: Form(
              key: _formKey,
              child: Stack(fit: StackFit.expand, children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: double.infinity,
                    height: 650,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          height: 650,
                          child: Image.asset(
                            'resources/bgr1.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          left: 0,
                          right: -270,
                          top: 10,
                          height: 650,
                          child: Image.asset(
                            'resources/bgr2.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 80),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Image.asset(
                      'resources/logo_smart.png',
                      width: 100,
                      height: 100,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  constraints: const BoxConstraints.expand(),
                  margin: const EdgeInsets.fromLTRB(0, 130, 0, 0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(height: 70),
                        Text(
                          'ĐĂNG NHẬP',
                          style: GoogleFonts.robotoCondensed(
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF064265),
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Đăng nhập để tiếp tục',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.robotoCondensed(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF064265),
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        SizedBox(
                          width: (MediaQuery.of(context).size.width),
                          height: 200,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Tài khoản',
                                    style: GoogleFonts.robotoCondensed(
                                        fontSize: 14,
                                        color: const Color(0xFF064265),
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    '*',
                                    style: GoogleFonts.robotoCondensed(
                                        fontSize: 14,
                                        color: const Color(0xffF5222D),
                                        fontWeight: FontWeight.w500),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  TextFormField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Vui lòng nhập tài khoản';
                                      }
                                      return null;
                                    },
                                    style: const TextStyle(color: Colors.black),
                                    controller: _usernameController,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: const Color.fromARGB(
                                          237, 250, 248, 248),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      hintText: 'Tài khoản',
                                      hintStyle: GoogleFonts.robotoCondensed(
                                          fontSize: 14,
                                          color: const Color(0xFF064265)),
                                      prefixIcon: const Icon(
                                        Icons.account_box_outlined,
                                        size: 24,
                                        color: Color(0xFF064265),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 12),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Colors.red,
                                          width: 1.5,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Colors.red,
                                          width: 1.5,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'Mật khẩu',
                                            style: GoogleFonts.robotoCondensed(
                                                fontSize: 14,
                                                color: const Color(0xFF064265)),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            '*',
                                            style: GoogleFonts.robotoCondensed(
                                                fontSize: 14,
                                                color: Colors.red),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          TextFormField(
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Vui lòng nhập mật khẩu';
                                              }
                                              return null;
                                            },
                                            style: const TextStyle(
                                                color: Colors.black),
                                            controller: _passwordController,
                                            obscureText: !_isPasswordVisible,
                                            decoration: InputDecoration(
                                              hintText: 'Mật khẩu',
                                              hintStyle:
                                                  GoogleFonts.robotoCondensed(
                                                fontSize: 14,
                                                color: const Color(0xFF064265),
                                              ),
                                              filled: true,
                                              fillColor: const Color.fromARGB(
                                                  237, 250, 248, 248),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              prefixIcon: const Icon(
                                                Icons.lock_outline,
                                                size: 24,
                                                color: Color(0xFF064265),
                                              ),
                                              suffixIcon: IconButton(
                                                icon: Icon(
                                                  _isPasswordVisible
                                                      ? Icons
                                                          .visibility_outlined
                                                      : Icons
                                                          .visibility_off_outlined,
                                                  color: const Color.fromARGB(
                                                      236, 85, 80, 80),
                                                  size: 18,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    _isPasswordVisible =
                                                        !_isPasswordVisible;
                                                  });
                                                },
                                              ),
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12),
                                              errorBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                  color: Colors.red,
                                                  width: 1.5,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                              ),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                  color: Colors.red,
                                                  width: 1.5,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 48,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF064265),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.all(8),
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              side: const BorderSide(
                                width: 2,
                                color: Color.fromARGB(255, 9, 105, 160),
                              ),
                            ),
                            onPressed: _login,
                            child: Row(
                              children: [
                                const Align(
                                    alignment: Alignment.centerLeft,
                                    child: Icon(
                                        Icons.keyboard_double_arrow_right)),
                                const Spacer(),
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Đăng nhập',
                                    style: GoogleFonts.robotoCondensed(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                                const Spacer()
                              ],
                            ),
                          ),
                        ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     const SizedBox(
                        //       width: 230,
                        //     ),
                            // SizedBox(
                            //   width: 130,
                            //   height: 40,
                            //   child: Row(
                            //     mainAxisAlignment: MainAxisAlignment.start,
                            //     children: [
                            //       TextButton(
                            //         onPressed: () {},
                            //         child: Text(
                            //           'Quên mật khẩu?',
                            //           style: GoogleFonts.robotoCondensed(
                            //               fontWeight: FontWeight.w400,
                            //               color: const Color(0xFF064265),
                            //               decoration: TextDecoration.underline,
                            //               decorationColor:
                            //                   const Color(0xFF064265)),
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                          ],
                        ),
                    //   ],
                    // ),
                  ),
                ),
              ]),
            )));
  }
}

void showLoginErrorSnackbar(BuildContext context) {
  final snackBar = SnackBar(
    backgroundColor: Colors.white,
    content: Text(
      'Sai tài khoản hoặc mật khẩu.',
      style: GoogleFonts.robotoCondensed(color: Colors.black),
    ),
    duration: const Duration(seconds: 3),
    action: SnackBarAction(
      label: 'Đóng',
      textColor: Colors.black,
      onPressed: () {},
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void showLoginSnackbar(BuildContext context) {
  var snackBar = SnackBar(
    backgroundColor: Colors.white,
    content: Text(
      'Đăng nhập thành công. Đang chuyển hướng....',
      style: GoogleFonts.robotoCondensed(color: Colors.black),
    ),
    duration: const Duration(seconds: 1),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);

  Future.delayed(const Duration(seconds: 1), () {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) =>  const AppScreen()),
    );
  });
}

// Thông báo check thông tin tài khoản, mật khẩu
void showValidationErrorSnackbar(BuildContext context, String message) {
  final snackBar = SnackBar(
    backgroundColor: Colors.white,
    content: Text(
      message,
      style: GoogleFonts.robotoCondensed(color: Colors.black),
    ),
    duration: const Duration(seconds: 3),
    action: SnackBarAction(
      label: 'Đóng',
      textColor: Colors.black,
      onPressed: () {},
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
