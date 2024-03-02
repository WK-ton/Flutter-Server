import 'package:application/Auth/Login.dart';
import 'package:application/components/Bottom_tap.dart';
import 'package:flutter/material.dart';
import 'users.dart';

class CheckLogin extends StatefulWidget {
  const CheckLogin({Key? key}) : super(key: key);

  @override
  State<CheckLogin> createState() => _CheckLoginState();
}

class _CheckLoginState extends State<CheckLogin> {
  Future checkLogin() async {
    bool? signin = await Users.getsignin();
    if (signin == false) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Login()));
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const BottomTab()));
    }
  }

  @override
  void initState() {
    checkLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
