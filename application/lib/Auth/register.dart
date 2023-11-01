import 'package:application/Auth/Login.dart';
import 'package:application/components/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final formKey = GlobalKey<FormState>();
  bool _isVisible = false;
  bool _isVisible2 = false;

  String _errorMessage = '';

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController passRepeat = TextEditingController();
  TextEditingController phone = TextEditingController();

  //connect SQL
  Future<void> signUp() async {
    final url = Uri.parse('http://localhost:8081/auth/sign-up');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'name': name.text,
      'email': email.text,
      'password': password.text,
      'password_repeat': passRepeat.text,
      'phone': phone.text,
    });

    final response = await http.post(url, headers: headers, body: body);

    //ตรวจสอบข้อมูล
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      if (result['success'] == true) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Login(),
          ),
        );
        print('Registration successful');
      } else if (result['message'] == 'Duplicate data') {
        setState(() {
          _errorMessage = 'กรุณาใส่ข้อมูลให้ถูกต้อง';
        });
      } else {
        final errorMessage = result['message'];
        if (errorMessage == 'Email not found' ||
            errorMessage == 'Name not found' ||
            errorMessage == 'Phone not found') {
          setState(() {
            _errorMessage = 'ข้อมูลซ้ำ';
          });
        } else {
          setState(() {
            _errorMessage = errorMessage;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFF5F3F6),
        body: SingleChildScrollView(
          child: SafeArea(
              child: Column(children: [
            CupertinoButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Login()));
              },
              child: const Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 320, 10),
                child: Icon(
                  Icons.arrow_back,
                  color: Color(0xFF4C2CA4),
                ),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(35, 0, 0, 54),
                  child: Text(
                    'สมัครสมาชิก',
                    style: GoogleFonts.notoSansThai(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF4C2CA4)),
                  ),
                ),
              ],
            ),
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            const SizedBox(
              height: 15,
            ),
            Form(
              key: formKey,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(children: [
                    TextFormField(
                      decoration: ThemeHepler().textInputDecoration(
                        'ชื่อ',
                        'ชื่อของคุณ - จำเป็น',
                      ),
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'กรุณากรอกชื่อให้ถูกต้อง';
                        }
                        return null;
                      },
                      controller: name,
                    ),
                    const SizedBox(height: 25),
                    TextFormField(
                      decoration: ThemeHepler().textInputDecoration(
                        'อีเมล',
                        'อีเมล - จำเป็น',
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
                        hintText: 'อย่างน้อย 6 ตัว - จำเป็น',
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
                        } else if (val.length < 6) {
                          return 'กรุณากรอกรหัสผ่านให้ครบถ้วน';
                        }
                        return null;
                      },
                      controller: password,
                    ),
                    const SizedBox(height: 25),
                    TextFormField(
                      obscureText: !_isVisible2,
                      decoration: InputDecoration(
                        labelStyle: GoogleFonts.notoSansThai(),
                        labelText: 'ยืนยันรหัสผ่าน',
                        hintText: 'รหัสผ่านอีกครั้ง - จำเป็น',
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
                              _isVisible2 = !_isVisible2;
                            });
                          },
                          icon: _isVisible2
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
                        } else if (val != password.text) {
                          return 'รหัสผ่านไม่ตรงกัน กรุณาลองใหม่อีกครั้ง';
                        } else if (val.length < 6) {
                          return 'กรุณากรอกรหัสผ่านให้ครบถ้วน';
                        }
                        return null;
                      },
                      controller: passRepeat,
                    ),
                    const SizedBox(height: 25),
                    TextFormField(
                      decoration: ThemeHepler().textInputDecoration(
                        'เบอร์โทร',
                        'เบอร์โทรศัพท์ของคุณ - จำเป็น',
                      ),
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'โปรดใส่เบอร์โทรให้ถูกต้อง';
                        }
                        if (val.length != 10) {
                          return 'เบอร์โทรศัพท์ไม่ครบ 10 ตัว';
                        }
                        return null;
                      },
                      controller: phone,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10)
                      ],
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: 320,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF5C24D4),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15))),
                        onPressed: () {
                          bool pass = formKey.currentState!.validate();
                          if (pass) {
                            signUp();
                          }
                        },
                        child: Text(
                          'สมัครสมาชิก',
                          style: GoogleFonts.notoSansThai(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            )
          ])),
        ));
  }
}
