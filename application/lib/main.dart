import 'package:application/Auth/Login.dart';
import 'package:application/components/Bottom_tap.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  runApp(MyApp(
    token: prefs.getString('token'),
  ));
}

class MyApp extends StatelessWidget {
  final String? token;
  const MyApp({
    @required this.token,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: (token != null && !JwtDecoder.isExpired(token!))
            ? BottomTab(token: token)
            : const Login());
  }
}
