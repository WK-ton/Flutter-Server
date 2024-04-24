import 'package:application/Auth/register.dart';
import 'package:application/components/Bottom_tap.dart';
import 'package:application/components/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = GlobalKey<FormState>();
  bool _isVisible = false;

  // กำหนดตัวแปล
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  String _errorMessage = '';

  Future<void> doLogin() async {
    if (formKey.currentState!.validate()) {
      const url = 'http://localhost:8081/auth/userLogin';
      final headers = {'Content-Type': 'application/json'};
      final body =
          json.encode({'email': email.text, 'password': password.text});
      final response =
          await http.post(Uri.parse(url), headers: headers, body: body);
      final responseData = json.decode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true) {
        final token = responseData['token'];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => BottomTab(token: token)));
      } else {
        final errorMessage = responseData['message'];
        if (errorMessage == 'Email not found' ||
            errorMessage == 'Password not found') {
          setState(() {
            _errorMessage = 'อีเมลหรือรหัสผ่านไม่ถูกต้อง';
          });
        } else {
          setState(() {
            _errorMessage = errorMessage;
          });
        }
      }
    } else {
      setState(() {
        _errorMessage = 'Server error!';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3F6),
      body: SingleChildScrollView(
        child: Center(
            child: Column(
          children: [
            Row(
              children: [
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(35, 54, 0, 0),
                    child: Text(
                      'เข้าสู่ระบบ',
                      style: GoogleFonts.notoSansThai(
                          color: const Color(0xFF4C2CA4),
                          fontSize: 28,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 40),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: ThemeHepler().textInputDecoration(
                        'อีเมล',
                        'อีเมลของคุณ',
                      ),
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'กรุณากรอกอีเมลให้ถูกต้อง';
                        }
                        bool emailValid = RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(val);
                        if (!emailValid) {
                          return "กรุณากรอกอีเมลให้ถูกต้อง";
                        }
                        return null;
                      },
                      controller: email,
                    ),
                    const SizedBox(height: 25),
                    TextFormField(
                      obscureText: !_isVisible,
                      decoration: InputDecoration(
                        labelStyle: GoogleFonts.notoSansThai(),
                        labelText: 'รหัสผ่าน',
                        hintText: 'รหัสผ่านของคุณ - จำเป็น',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintStyle: GoogleFonts.notoSansThai(
                            color: const Color(0xFF8C5BF4).withOpacity(0.4)),
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding:
                            const EdgeInsets.fromLTRB(20, 25, 20, 10),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(color: Colors.white)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(color: Colors.white)),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(color: Colors.white)),
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(color: Colors.white)),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _isVisible = !_isVisible;
                            });
                          },
                          icon: _isVisible
                              ? const Icon(
                                  Icons.visibility,
                                  color: Colors.red,
                                )
                              : Icon(
                                  Icons.visibility_off,
                                  color:
                                      const Color(0xFF8C5BF4).withOpacity(0.4),
                                ),
                        ),
                      ),
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'กรุณากรอกรหัสผ่านให้ถูกต้อง';
                        }
                        return null;
                      },
                      controller: password,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    if (_errorMessage.isNotEmpty)
                      Text(
                        _errorMessage,
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    const SizedBox(height: 20),
                    // CupertinoButton(
                    //   onPressed: () {},
                    //   child: Padding(
                    //     padding: const EdgeInsets.symmetric(vertical: 5),
                    //     child: Image.network(
                    //       'https://www.freepnglogos.com/uploads/google-logo-png/google-logo-png-webinar-optimizing-for-success-google-business-webinar-13.png',
                    //       width: 50,
                    //       height: 50,
                    //     ),
                    //   ),
                    // ),
                    SizedBox(
                      width: 320,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF5C24D4),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15))),
                        onPressed: () {
                          doLogin();
                        },
                        child: Text(
                          'เข้าสู่ระบบ',
                          style: GoogleFonts.notoSansThai(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                      child: Row(
                        children: [
                          Text(
                            'ยังไม่เคยสมัครสมาชิก? ',
                            style: GoogleFonts.notoSansThai(
                                fontSize: 16, color: Colors.grey),
                          ),
                          const SizedBox(width: 2),
                          TextButton(
                            style: TextButton.styleFrom(
                                textStyle: const TextStyle(fontSize: 15),
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0)),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Register()));
                            },
                            child: Text(
                              'สมัครสมาชิกฟรี',
                              style: GoogleFonts.notoSansThai(
                                  fontSize: 16, color: const Color(0xFF5C24D4)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
